import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_app/services/qibla_service.dart';

void main() {
  group('QiblaService Calculations Worldwide', () {
    test('Calculates accurate bearing for Islamabad, Pakistan', () {
      // Islamabad: 33.6844° N, 73.0479° E
      // Bearing towards Makkah (21.4225° N, 39.8262° E) is ~255.8° - 256.0°
      final bearing = QiblaService.calculateQiblaBearing(33.6844, 73.0479);
      expect(bearing, closeTo(255.86, 0.5));
      expect(bearing.round(), equals(256));
    });

    test('Calculates accurate bearing for Karachi, Pakistan', () {
      // Karachi: 24.8607° N, 67.0011° E -> ~267.4°
      final bearing = QiblaService.calculateQiblaBearing(24.8607, 67.0011);
      expect(bearing, closeTo(267.4, 0.5));
    });

    test('Calculates accurate bearing for London, UK', () {
      // London: 51.5074° N, -0.1278° W -> ~118.9°
      final bearing = QiblaService.calculateQiblaBearing(51.5074, -0.1278);
      expect(bearing, closeTo(118.9, 0.5));
    });

    test('Calculates accurate bearing for New York, USA', () {
      // New York: 40.7128° N, -74.0060° W -> ~58.5°
      final bearing = QiblaService.calculateQiblaBearing(40.7128, -74.0060);
      expect(bearing, closeTo(58.5, 0.5));
    });

    test('Calculates accurate bearing for Sydney, Australia', () {
      // Sydney: -33.8688° S, 151.2093° E -> ~277.5°
      final bearing = QiblaService.calculateQiblaBearing(-33.8688, 151.2093);
      expect(bearing, closeTo(277.5, 0.5));
    });

    test('Calculates accurate bearing for Tokyo, Japan', () {
      // Tokyo: 35.6762° N, 139.6503° E -> ~293.0°
      final bearing = QiblaService.calculateQiblaBearing(35.6762, 139.6503);
      expect(bearing, closeTo(293.0, 0.5));
    });

    test('Calculates accurate bearing for Cairo, Egypt', () {
      // Cairo: 30.0444° N, 31.2357° E -> ~136.0°
      final bearing = QiblaService.calculateQiblaBearing(30.0444, 31.2357);
      expect(bearing, closeTo(136.0, 0.5));
    });

    test('Calculates distance and formats it properly', () {
      // Distance from London to Makkah is ~4,788 km
      final distLondon = QiblaService.calculateDistanceKm(51.5074, -0.1278);
      expect(distLondon, closeTo(4788, 50));
      expect(QiblaService.formatDistance(distLondon), contains('km'));

      // Distance from Islamabad to Makkah is ~3,565 km
      final distIsl = QiblaService.calculateDistanceKm(33.6844, 73.0479);
      expect(distIsl, closeTo(3565, 50));
    });

    test('Angle normalization handles negative and large positive values', () {
      expect(QiblaService.normalizeAngle(-90), equals(270));
      expect(QiblaService.normalizeAngle(450), equals(90));
      expect(QiblaService.normalizeAngle(360), equals(0));
      expect(QiblaService.normalizeAngle(0), equals(0));
    });

    test('Shortest angle difference handles wraparound', () {
      expect(QiblaService.shortestAngleDifference(10, 350), equals(20));
      expect(QiblaService.shortestAngleDifference(350, 10), equals(-20));
      expect(QiblaService.shortestAngleDifference(180, 0), equals(180));
    });

    test('Smoothing moves smoothly across 0/360 border', () {
      final smoothed = QiblaService.smoothAngle(358, 2, factor: 0.5);
      expect(smoothed, closeTo(0.0, 0.1));
    });

    test('Alignment detection works with tolerance', () {
      expect(QiblaService.isAlignedWithQibla(256.0, 257.5, toleranceDeg: 3.0), isTrue);
      expect(QiblaService.isAlignedWithQibla(250.0, 257.5, toleranceDeg: 3.0), isFalse);
      expect(QiblaService.isAlignedWithQibla(359.0, 1.0, toleranceDeg: 3.0), isTrue);
    });
  });
}
