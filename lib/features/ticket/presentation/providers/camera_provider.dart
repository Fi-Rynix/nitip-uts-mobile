import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/camera_service.dart';

final cameraServiceProvider = Provider((ref) => CameraService());

final cameraPermissionProvider = FutureProvider<bool>((ref) async {
  final cameraService = ref.watch(cameraServiceProvider);
  return await cameraService.isCameraPermissionGranted();
});

final requestCameraPermissionProvider = FutureProvider<bool>((ref) async {
  final cameraService = ref.watch(cameraServiceProvider);
  return await cameraService.requestCameraPermission();
});
