import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/campus_event.dart';

class EventItem extends StatelessWidget {
  final CampusEvent event;
  final Position? userPosition;

  const EventItem({super.key, required this.event, required this.userPosition});

  double _calculateDistance() {
    if (userPosition == null) return 0.0;
    return Geolocator.distanceBetween(
      userPosition!.latitude,
      userPosition!.longitude,
      event.lat,
      event.lng,
    );
  }

  @override
  Widget build(BuildContext context) {
    final distance = _calculateDistance();

    // LOGIKA GEOFENCING SEDERHANA
    // Jika jarak kurang dari 50 meter, anggap user sudah sampai (Check-in visual)
    final bool isNearby = userPosition != null && distance < 50.0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: isNearby ? 4 : 1,
      // Ubah warna background jika dekat
      color: isNearby ? Colors.green.shade50 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isNearby
            ? const BorderSide(color: Colors.green, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isNearby ? Colors.green : Colors.indigo,
          child: Icon(
            isNearby ? Icons.check : Icons.event_available,
            color: Colors.white,
          ),
        ),
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.description),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isNearby ? Colors.green : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                userPosition == null
                    ? 'Menunggu lokasi...'
                    : isNearby
                    ? 'ANDA DI LOKASI!'
                    : '${distance.toStringAsFixed(0)} meter lagi',
                style: TextStyle(
                  color: isNearby ? Colors.white : Colors.orange.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
