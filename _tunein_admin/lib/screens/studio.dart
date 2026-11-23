import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models.dart';
import '../services/db.dart';
import '../services/storage.dart';
import '../theme/theme.dart';
import '../theme/tokens.dart';
import '../widgets.dart';

/// Studio: si el usuario no tiene emisora, la crea; si tiene, publica
/// posts y audio moments, y puede borrarlos.
class StudioScreen extends StatelessWidget {
  const StudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Store.myStationId,
      builder: (context, id, _) {
        final station = id == null ? null : Store.byId(id);
        if (station == null) return const _StudioForm(); // crear emisora
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(station.name),
              actions: [
                IconButton(
                  tooltip: 'Editar emisora',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _editStation(context, station),
                ),
              ],
              bottom: const TabBar(
                indicatorColor: SocialTokens.accent,
                labelColor: SocialTokens.accent,
                tabs: [
                  Tab(text: 'Posts'),
                  Tab(text: 'Audio Moments'),
                ],
              ),
            ),
            // Builder: da un context "dentro" del DefaultTabController.
            floatingActionButton: Builder(
              builder: (context) => FloatingActionButton.extended(
                backgroundColor: SocialTokens.accent,
                foregroundColor: SocialTokens.onAccent,
                icon: const Icon(Icons.add),
                label: const Text('Publicar'),
                onPressed: () {
                  final moments = DefaultTabController.of(context).index == 1;
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          _StudioForm(station: station, moment: moments),
                    ),
                  );
                },
              ),
            ),
            body: TabBarView(
              children: [
                for (final moments in [false, true])
                  StreamBuilder(
                    stream: Db.itemsOf(station.id, moments: moments),
                    builder: (context, snap) {
                      final items = snap.data ?? [];
                      if (items.isEmpty) {
                        return const EmptyState('Toca "Publicar" para empezar');
                      }
                      return ListView(
                        children: [
                          for (final i in items)
                            ItemTile(
                              title: i.title,
                              subtitle:
                                  '♥ ${i.likeCount}  ·  💬 ${i.commentCount}',
                              imageUrl: i.imageUrl,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Editar',
                                    icon: const Icon(Icons.edit_outlined),
                                    onPressed: () => _editItem(context, i),
                                  ),
                                  IconButton(
                                    tooltip: 'Borrar',
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => Db.deleteItem(i),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Editar la emisora propia: datos, ubicación del mapa y portada
/// (image_picker, igual que en el ejemplo del profesor).
Future<void> _editStation(BuildContext context, Station s) async {
  final c = {
    'name': TextEditingController(text: s.name),
    'genre': TextEditingController(text: s.genre),
    'location': TextEditingController(text: s.location),
    'frequency': TextEditingController(text: s.frequency),
    'description': TextEditingController(text: s.description),
    'lat': TextEditingController(text: s.lat?.toString() ?? ''),
    'lng': TextEditingController(text: s.lng?.toString() ?? ''),
  };
  String v(String k) => c[k]!.text.trim();
  Uint8List? newImage;
  var saving = false;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheet) => StatefulBuilder(
      builder: (sheet, refresh) {
        Future<void> pickImage() async {
          final bytes = await Storage.pickImageFromGallery();
          if (bytes != null) refresh(() => newImage = bytes);
        }

        Future<void> save() async {
          refresh(() => saving = true);
          try {
            await Db.updateStation(s.id, {
              'name': v('name'),
              'genre': v('genre'),
              'location': v('location'),
              'frequency': v('frequency'),
              'description': v('description'),
              'lat': double.tryParse(v('lat')),
              'lng': double.tryParse(v('lng')),
              if (newImage != null)
                'imageUrl': await Storage.uploadImage(newImage!, s.id),
            });
            if (sheet.mounted) Navigator.pop(sheet);
          } catch (e) {
            refresh(() => saving = false);
            if (sheet.mounted) showAlert(sheet, 'Error: $e', error: true);
          }
        }

        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppPadding.paddingL16,
            AppPadding.paddingS8,
            AppPadding.paddingL16,
            MediaQuery.viewInsetsOf(sheet).bottom + AppPadding.padding2xl24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Editar emisora',
                  style: AppTypography.h3.copyWith(
                    color: AppSemanticColors.colorTextMain,
                  ),
                ),
                const SizedBox(height: AppGap.gapL16),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.radiusS),
                      child: newImage != null
                          ? Image.memory(
                              newImage!,
                              width: CardTokens.m,
                              height: CardTokens.m,
                              fit: BoxFit.cover,
                            )
                          : Cover(s.imageUrl, size: CardTokens.m),
                    ),
                    const SizedBox(width: AppGap.gapM12),
                    OutlinedButton.icon(
                      onPressed: saving ? null : pickImage,
                      icon: const Icon(Icons.image_outlined),
                      label: const Text('Cambiar portada'),
                    ),
                  ],
                ),
                const SizedBox(height: AppGap.gapL16),
                LabeledField('Nombre', c['name']!),
                LabeledField('Género', c['genre']!),
                LabeledField('Ciudad', c['location']!),
                LabeledField('Frecuencia', c['frequency']!),
                LabeledField('Descripción', c['description']!),
                LabeledField('Latitud (para el mapa)', c['lat']!, number: true),
                LabeledField('Longitud', c['lng']!, number: true),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: saving ? null : save,
                    child: Text(saving ? 'GUARDANDO…' : 'GUARDAR CAMBIOS'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

/// Editar un post o audio moment ya publicado: título, texto (posts) y
/// portada. La portada se elige con image_picker, como en el ejemplo del
/// profesor (showModalBottomSheet + StatefulBuilder).
Future<void> _editItem(BuildContext context, Item item) async {
  final title = TextEditingController(text: item.title);
  final summary = TextEditingController(text: item.summary);
  Uint8List? newImage; // portada nueva (null = no cambió)
  var saving = false;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheet) => StatefulBuilder(
      builder: (sheet, refresh) {
        Future<void> pickImage() async {
          final bytes = await Storage.pickImageFromGallery();
          if (bytes != null) refresh(() => newImage = bytes);
        }

        Future<void> save() async {
          refresh(() => saving = true);
          try {
            await Db.updateItem(item, {
              'title': title.text.trim(),
              if (!item.isMoment) 'summary': summary.text.trim(),
              if (newImage != null)
                'imageUrl': await Storage.uploadImage(
                  newImage!,
                  item.stationId,
                ),
            });
            if (sheet.mounted) Navigator.pop(sheet);
          } catch (e) {
            refresh(() => saving = false);
            if (sheet.mounted) showAlert(sheet, 'Error: $e', error: true);
          }
        }

        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppPadding.paddingL16,
            AppPadding.paddingS8,
            AppPadding.paddingL16,
            MediaQuery.viewInsetsOf(sheet).bottom + AppPadding.padding2xl24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.isMoment ? 'Editar audio moment' : 'Editar post',
                  style: AppTypography.h3.copyWith(
                    color: AppSemanticColors.colorTextMain,
                  ),
                ),
                const SizedBox(height: AppGap.gapL16),
                LabeledField('Título', title),
                if (!item.isMoment) LabeledField('Resumen', summary),
                Row(
                  children: [
                    // Vista previa: la portada nueva o la actual.
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.radiusS),
                      child: newImage != null
                          ? Image.memory(
                              newImage!,
                              width: CardTokens.m,
                              height: CardTokens.m,
                              fit: BoxFit.cover,
                            )
                          : Cover(item.imageUrl, size: CardTokens.m),
                    ),
                    const SizedBox(width: AppGap.gapM12),
                    OutlinedButton.icon(
                      onPressed: saving ? null : pickImage,
                      icon: const Icon(Icons.image_outlined),
                      label: const Text('Cambiar portada'),
                    ),
                  ],
                ),
                const SizedBox(height: AppGap.gapL16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: saving ? null : save,
                    child: Text(saving ? 'GUARDANDO…' : 'GUARDAR CAMBIOS'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

/// Un solo formulario para tres casos:
///   station == null        → crear emisora
///   station + moment=false → nuevo post (imagen + título + resumen)
///   station + moment=true  → nuevo audio moment (audio + título)
class _StudioForm extends StatefulWidget {
  const _StudioForm({this.station, this.moment = false});
  final Station? station;
  final bool moment;

  @override
  State<_StudioForm> createState() => _StudioFormState();
}

class _StudioFormState extends State<_StudioForm> {
  final _form = GlobalKey<FormState>();
  final _c = {
    for (final k in [
      'name',
      'genre',
      'location',
      'frequency',
      'description',
      'lat',
      'lng',
      'title',
      'summary',
      'imageUrl',
      'audioUrl',
    ])
      k: TextEditingController(),
  };
  PlatformFile? _image, _audio;
  bool _saving = false;

  bool get _isStation => widget.station == null;
  bool get _needsAudio => _isStation || widget.moment;

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  String _v(String k) => _c[k]!.text.trim();

  /// Usa el archivo elegido (subiéndolo a Storage) o la URL pegada.
  Future<String> _url(PlatformFile? file, String key, String stationId) async =>
      file != null ? Storage.upload(file, stationId) : _v(key);

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    if (_needsAudio && _audio == null && _v('audioUrl').isEmpty) {
      showAlert(context, 'Falta el audio', error: true);
      return;
    }
    setState(() => _saving = true);
    try {
      final id = widget.station?.id ?? Db.stations.doc().id;
      final image = await _url(_image, 'imageUrl', id);
      final audio = _needsAudio ? await _url(_audio, 'audioUrl', id) : '';
      if (_isStation) {
        await Db.createStation(
          id,
          Station(
            id: id,
            name: _v('name'),
            genre: _v('genre'),
            location: _v('location'),
            frequency: _v('frequency'),
            description: _v('description'),
            imageUrl: image,
            audioUrl: audio,
            lat: double.tryParse(_v('lat')),
            lng: double.tryParse(_v('lng')),
          ),
        );
      } else {
        await Db.addItem(
          Item(
            id: '',
            stationId: id,
            isMoment: widget.moment,
            title: _v('title'),
            summary: _v('summary'),
            imageUrl: image,
            audioUrl: audio,
          ),
        );
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) showAlert(context, 'No se pudo guardar: $e', error: true);
    }
    if (mounted) setState(() => _saving = false);
  }

  /// Botón "Elegir archivo" + campo para pegar una URL.
  Widget _media(String label, bool audio) {
    final file = audio ? _audio : _image;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppPadding.paddingL16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.sub2.copyWith(
              color: AppSemanticColors.colorTextMain,
            ),
          ),
          const SizedBox(height: AppGap.gapS8),
          OutlinedButton.icon(
            icon: Icon(audio ? Icons.audio_file : Icons.image_outlined),
            label: Text(file?.name ?? 'Elegir archivo'),
            onPressed: () async {
              final f = await Storage.pick(audio: audio);
              if (f != null) setState(() => audio ? _audio = f : _image = f);
            },
          ),
          if (file == null)
            TextField(
              controller: _c[audio ? 'audioUrl' : 'imageUrl'],
              decoration: const InputDecoration(hintText: 'o pega una URL'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _isStation
        ? 'Crear emisora'
        : widget.moment
        ? 'Nuevo audio moment'
        : 'Nuevo post';
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(AppPadding.paddingXl20),
          children: [
            if (_isStation) ...[
              LabeledField(
                'Nombre',
                _c['name']!,
                hint: 'Radio Cordillera',
                required: true,
              ),
              LabeledField(
                'Género',
                _c['genre']!,
                hint: 'Música, Noticias…',
                required: true,
              ),
              LabeledField('Ciudad', _c['location']!, hint: 'Santiago, Chile'),
              LabeledField('Frecuencia', _c['frequency']!, hint: '88.5 FM'),
              LabeledField('Descripción', _c['description']!),
              LabeledField(
                'Latitud (para el mapa)',
                _c['lat']!,
                hint: '-33.45',
                number: true,
              ),
              LabeledField(
                'Longitud',
                _c['lng']!,
                hint: '-70.66',
                number: true,
              ),
            ] else ...[
              LabeledField('Título', _c['title']!, required: true),
              if (!widget.moment) LabeledField('Resumen', _c['summary']!),
            ],
            if (_needsAudio)
              _media(
                _isStation ? 'Audio de la transmisión' : 'Audio del clip',
                true,
              ),
            _media(_isStation ? 'Logo' : 'Imagen', false),
            const SizedBox(height: AppGap.gapL16),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(_saving ? 'GUARDANDO…' : 'GUARDAR'),
            ),
          ],
        ),
      ),
    );
  }
}
