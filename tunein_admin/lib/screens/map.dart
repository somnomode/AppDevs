import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models.dart';
import '../services/db.dart';
import '../theme/tokens.dart';
import '../widgets.dart';
import 'player.dart';
import 'shell.dart';

/// Mapa (Figma: "mapa") con Google Maps. Pines naranjos = emisoras.
/// Necesita la API key en android/app/src/main/AndroidManifest.xml.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _map;
  Station? _selected;

  /// Centra la emisora pedida desde "Encontrar en el mapa".
  void _focus() {
    final s = AppNav.mapFocus.value;
    if (s == null || !s.hasLocation) return;
    setState(() => _selected = s);
    _map?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(s.lat!, s.lng!), 10));
    AppNav.mapFocus.value = null;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Station>?>(
      valueListenable: Store.stations,
      builder: (context, stations, _) {
        final located = (stations ?? []).where((s) => s.hasLocation).toList();
        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(-30, -64),
                zoom: 3.2,
              ),
              style: _darkStyle,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              onMapCreated: (c) {
                _map = c;
                _focus();
              },
              onTap: (_) => setState(() => _selected = null),
              markers: {
                for (final s in located)
                  Marker(
                    markerId: MarkerId(s.id),
                    position: LatLng(s.lat!, s.lng!),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      MapTokens.markerHue,
                    ),
                    onTap: () => setState(() => _selected = s),
                  ),
              },
            ),
            if (_selected case final s?)
              Positioned(
                left: MapTokens.cardInset,
                right: MapTokens.cardInset,
                bottom: MapTokens.cardBottom,
                child: ItemTile(
                  filled: true,
                  title: s.name,
                  subtitle: '${s.frequency} · ${s.location}',
                  imageUrl: s.imageUrl,
                  trailing: const Icon(Icons.play_arrow_outlined),
                  onTap: () => openStation(context, s, queue: located),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Mapa oscuro con colores TuneIn: tierra neutral-700, agua neutral-900,
/// calles neutral-500, textos neutral-100, ciudades primary-300.
const _darkStyle = '''[
 {"elementType":"geometry","stylers":[{"color":"#0D1028"}]},
 {"elementType":"labels.icon","stylers":[{"visibility":"off"}]},
 {"elementType":"labels.text.fill","stylers":[{"color":"#ABADCA"}]},
 {"elementType":"labels.text.stroke","stylers":[{"color":"#03040D"}]},
 {"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#4E5182"}]},
 {"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#FA916A"}]},
 {"featureType":"poi","stylers":[{"visibility":"off"}]},
 {"featureType":"transit","stylers":[{"visibility":"off"}]},
 {"featureType":"road","elementType":"geometry","stylers":[{"color":"#1F2249"}]},
 {"featureType":"road","elementType":"labels","stylers":[{"visibility":"off"}]},
 {"featureType":"water","elementType":"geometry","stylers":[{"color":"#03040D"}]}
]''';
