import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService({FirebaseRemoteConfig? remoteConfig})
      : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;

  // Default values
  final Map<String, dynamic> _defaults = {
    'show_promotional_message': false,
    'promotional_message': 'Welcome to Mobile Troubleshooter!',
  };

  Future<void> initialize() async {
    try {
      await _remoteConfig.setDefaults(_defaults);
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      print('Failed to initialize Remote Config: $e');
    }
  }

  bool get showPromotionalMessage => _remoteConfig.getBool('show_promotional_message');
  String get promotionalMessage => _remoteConfig.getString('promotional_message');
}

// Provider for the RemoteConfigService
final remoteConfigServiceProvider = Provider<RemoteConfigService>((ref) {
  final service = RemoteConfigService();
  service.initialize();
  return service;
});
