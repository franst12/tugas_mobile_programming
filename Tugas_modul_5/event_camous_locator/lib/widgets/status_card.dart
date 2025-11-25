import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class StatusCard extends StatelessWidget {
  final String status;
  final Position? position;
  final String? address;
  final bool isTracking;
  final bool useHighAccuracy;
  final VoidCallback onGetCurrent;
  final VoidCallback onToggleTracking;
  final ValueChanged<bool> onToggleAccuracy;

  const StatusCard({
    super.key,
    required this.status,
    required this.position,
    required this.address,
    required this.isTracking,
    required this.useHighAccuracy,
    required this.onGetCurrent,
    required this.onToggleTracking,
    required this.onToggleAccuracy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.indigo.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Status Text
          Text(
            'Status: $status',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Koordinat & Alamat
          if (position != null) ...[
            Text(
              'Lat: ${position!.latitude.toStringAsFixed(5)}, Lng: ${position!.longitude.toStringAsFixed(5)}',
            ),
            Text(
              'Akurasi Sinyal: ${position!.accuracy.toStringAsFixed(1)} m',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
            if (address != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '📍 $address',
                  style: const TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const SizedBox(height: 8),
          ] else
            const Text(
              'Lokasi belum diketahui.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),

          // Toggle Switch Akurasi
          SwitchListTile(
            title: const Text('Akurasi Tinggi (GPS)'),
            subtitle: Text(
              useHighAccuracy
                  ? 'Baterai boros, presisi tinggi'
                  : 'Hemat baterai, presisi rendah (Wifi/Cell)',
            ),
            value: useHighAccuracy,
            onChanged: isTracking ? null : onToggleAccuracy,
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),

          // Tombol Aksi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: onGetCurrent,
                icon: const Icon(Icons.my_location),
                label: const Text('Cek Sekali'),
              ),
              FilledButton.icon(
                onPressed: onToggleTracking,
                icon: Icon(isTracking ? Icons.stop : Icons.play_arrow),
                label: Text(isTracking ? 'Stop Live' : 'Start Live'),
                style: FilledButton.styleFrom(
                  backgroundColor: isTracking ? Colors.red : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
