import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../models.dart';
import 'db.dart';

/// Lo que está sonando: una emisora (radio simulada) o un audio moment.
class NowPlaying {
  const NowPlaying(this.station, [this.moment]);
  final Station station;
  final Item? moment;

  String get id => moment?.id ?? station.id;
  String get title => moment?.title ?? station.name;
  String get imageUrl => (moment?.imageUrl.isNotEmpty ?? false)
      ? moment!.imageUrl
      : station.imageUrl;
  String get audioUrl => moment?.audioUrl ?? station.audioUrl;
}

/// Reproductor único de la app (un solo AudioPlayer).
class Player extends ChangeNotifier {
  Player._() {
    _audio.playerStateStream.listen((s) {
      // La "radio" no se acaba: al terminar el archivo, vuelve a empezar.
      if (s.processingState == ProcessingState.completed &&
          now?.moment == null) {
        _audio.seek(Duration.zero);
      }
      notifyListeners();
    });
  }

  static final instance = Player._();

  final _audio = AudioPlayer();
  NowPlaying? now;
  List<Station> _queue = [];
  String? error;
  Timer? _sleep;

  bool get playing => _audio.playing;
  bool get loading => const [
    ProcessingState.loading,
    ProcessingState.buffering,
  ].contains(_audio.processingState);
  bool get canSkip => _queue.length > 1;
  bool get sleepTimerOn => _sleep?.isActive ?? false;
  bool isCurrent(String id) => now?.id == id;

  Stream<Duration> get position => _audio.positionStream;
  Stream<Duration?> get duration => _audio.durationStream;
  Duration? get currentDuration => _audio.duration;

  Future<void> playStation(Station s, {List<Station>? queue}) {
    if (queue != null && queue.isNotEmpty) _queue = queue;
    unawaited(Db.addRecent(s.id).catchError((_) {}));
    return _play(NowPlaying(s));
  }

  Future<void> playMoment(Item m, Station s) => _play(NowPlaying(s, m));

  Future<void> _play(NowPlaying next) async {
    if (isCurrent(next.id)) return toggle();
    now = next;
    error = null;
    notifyListeners();
    try {
      await _audio.setUrl(next.audioUrl);
      unawaited(_audio.play()); // play() termina recién al pausar: no esperar
    } catch (e) {
      error = 'No se pudo reproducir este audio.';
    }
    notifyListeners();
  }

  Future<void> toggle() async {
    if (playing) {
      await _audio.pause();
    } else {
      if (_audio.processingState == ProcessingState.completed) {
        await _audio.seek(Duration.zero);
      }
      unawaited(_audio.play());
    }
    notifyListeners();
  }

  Future<void> seek(Duration d) => _audio.seek(d);

  /// Detiene todo (al cerrar sesión).
  Future<void> stop() async {
    await _audio.stop();
    now = null;
    sleepIn(null);
  }

  Future<void> skip(int step) async {
    if (!canSkip) return;
    final i = _queue.indexWhere((s) => s.id == now?.station.id);
    await playStation(_queue[(i + step) % _queue.length]);
  }

  /// Timer de sueño: pausa después de [d] (null = cancelar).
  void sleepIn(Duration? d) {
    _sleep?.cancel();
    _sleep = d == null ? null : Timer(d, _audio.pause);
    notifyListeners();
  }
}
