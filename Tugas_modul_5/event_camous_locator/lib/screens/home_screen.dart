import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as gc;

// Import file-file yang sudah dipisah
import '../models/campus_event.dart';
import '../widgets/status_card.dart';
import '../widgets/event_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _pos;
  String? _address;
  StreamSubscription<Position>? _sub;
  bool _tracking = false;

  // Default akurasi tinggi
  bool _useHighAccuracy = true;
  String _status = 'Siap. Silakan cek lokasi.';

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  // Cek Izin & Service GPS
  Future<bool> _ensureServiceAndPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _status = 'GPS Mati. Mohon aktifkan.');
      return false;
    }
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.deniedForever ||
        perm == LocationPermission.denied) {
      setState(() => _status = 'Izin lokasi ditolak user.');
      return false;
    }
    return true;
  }

  // Logic: Get Current Location (Sekali)
  Future<void> _getCurrent() async {
    if (!await _ensureServiceAndPermission()) return;

    setState(() => _status = 'Sedang mencari koordinat...');

    try {
      final accuracy = _useHighAccuracy
          ? LocationAccuracy.high
          : LocationAccuracy.low;

      final p = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: const Duration(seconds: 10),
      );

      setState(() {
        _pos = p;
        _status = 'Lokasi terkini didapat.';
      });
      _reverseGeocode(p);
    } catch (e) {
      setState(() => _status = 'Gagal: ${e.toString()}');
    }
  }

  // Logic: Reverse Geocoding (LatLong -> Alamat)
  Future<void> _reverseGeocode(Position p) async {
    try {
      final placemarks = await gc.placemarkFromCoordinates(
        p.latitude,
        p.longitude,
      );
      if (placemarks.isNotEmpty) {
        final m = placemarks.first;
        setState(() {
          // Format alamat: Jalan, Kecamatan, Kota
          _address = '${m.street}, ${m.locality}, ${m.subAdministrativeArea}';
        });
      }
    } catch (_) {
      // Ignore error jika offline/limit
    }
  }

  // Logic: Live Tracking Stream
  Future<void> _toggleTracking() async {
    if (_tracking) {
      await _sub?.cancel();
      setState(() {
        _tracking = false;
        _status = 'Live tracking berhenti.';
      });
      return;
    }

    if (!await _ensureServiceAndPermission()) return;

    // Setting Geolocator berdasarkan toggle user
    final accuracy = _useHighAccuracy
        ? LocationAccuracy.high
        : LocationAccuracy.low;
    final distanceFilter = _useHighAccuracy
        ? 10
        : 50; // Update tiap 10m atau 50m

    _sub =
        Geolocator.getPositionStream(
          locationSettings: LocationSettings(
            accuracy: accuracy,
            distanceFilter: distanceFilter,
          ),
        ).listen((p) {
          setState(() {
            _pos = p;
            _tracking = true;
            _status = 'Tracking Aktif (${_useHighAccuracy ? "High" : "Low"}).';
          });
          _reverseGeocode(p);
        }, onError: (e) => setState(() => _status = 'Stream Error: $e'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Kampus Locator'),
        backgroundColor: Colors.indigo.shade50,
      ),
      body: Column(
        children: [
          // 1. Widget Status Dashboard
          StatusCard(
            status: _status,
            position: _pos,
            address: _address,
            isTracking: _tracking,
            useHighAccuracy: _useHighAccuracy,
            onGetCurrent: _getCurrent,
            onToggleTracking: _toggleTracking,
            onToggleAccuracy: (val) {
              setState(() => _useHighAccuracy = val);
            },
          ),

          const Divider(height: 1),

          // 2. List Event
          Expanded(
            child: ListView.builder(
              itemCount: kCampusEvents.length,
              itemBuilder: (ctx, i) {
                return EventItem(event: kCampusEvents[i], userPosition: _pos);
              },
            ),
          ),
        ],
      ),
    );
  }
}
