class CampusEvent {
  final String title;
  final double lat;
  final double lng;
  final String description;

  CampusEvent({
    required this.title,
    required this.lat,
    required this.lng,
    required this.description,
  });
}

// Data Dummy (Ganti koordinat ini agar dekat dengan lokasi Anda saat testing)
final List<CampusEvent> kCampusEvents = [
  CampusEvent(
    title: 'Seminar Teknologi AI',
    lat: -6.200000,
    lng: 106.816666,
    description: 'Gedung Serbaguna Lt. 2',
  ),
  CampusEvent(
    title: 'Job Fair 2024',
    lat: -6.201000,
    lng: 106.817000,
    description: 'Lapangan Utama',
  ),
  CampusEvent(
    title: 'Expo UKM & Seni',
    lat: -6.200500,
    lng: 106.815000,
    description: 'Area Parkir Selatan',
  ),
  CampusEvent(
    title: 'Workshop Flutter',
    lat: -6.199500,
    lng: 106.814500,
    description: 'Lab Komputer 3',
  ),
];
