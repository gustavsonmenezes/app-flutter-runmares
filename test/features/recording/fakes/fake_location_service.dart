import 'package:runmares/features/recording/data/location_service.dart';
import 'package:runmares/features/recording/domain/location_failure.dart';
import 'package:runmares/features/recording/domain/track_point.dart';

class FakeLocationService implements LocationService {
  const FakeLocationService([
    this._positions = const Stream<TrackPoint>.empty(),
  ]);

  FakeLocationService.failing(LocationFailureReason reason)
    : _positions = Stream<TrackPoint>.error(LocationException(reason));

  final Stream<TrackPoint> _positions;

  @override
  Stream<TrackPoint> watchPosition() => _positions;

  @override
  Future<bool> openAppSettings() async => false;
}
