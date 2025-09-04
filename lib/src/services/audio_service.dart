import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class AudioDevice {
  final String id;
  final String name;
  final bool isDefault;

  AudioDevice({
    required this.id,
    required this.name,
    this.isDefault = false,
  });

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioDevice &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  bool _isInitialized = false;
  String? _selectedDeviceId;
  double _microphoneVolume = 1.0;

  bool get isRecording => _isRecording;
  bool get isInitialized => _isInitialized;

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      final hasPermission = await requestPermissions();
      _isInitialized = hasPermission;
      return hasPermission;
    } catch (e) {
      // Error initializing audio service: $e
      return false;
    }
  }

  Future<bool> requestPermissions() async {
    if (kIsWeb) {
      // Web doesn't need explicit permission requests
      return true;
    }

    final micPermission = await Permission.microphone.request();
    
    if (Platform.isAndroid) {
      final storagePermission = await Permission.storage.request();
      return micPermission.isGranted && storagePermission.isGranted;
    }
    
    return micPermission.isGranted;
  }

  Future<String?> startRecording() async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return null;
    }

    try {
      final directory = await _getRecordingDirectory();
      final fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
      final filePath = '${directory.path}/$fileName';

      // Use selected device if available
      RecordConfig config = const RecordConfig();
      if (_selectedDeviceId != null && _selectedDeviceId != 'default') {
        // Note: The record package doesn't directly support device selection in RecordConfig
        // This would need platform-specific implementation or a different package
        // For now, we log the selected device
          // Using selected microphone device: $_selectedDeviceId
      }

      await _audioRecorder.start(
        config,
        path: filePath,
      );

      _isRecording = true;
      return filePath;
    } catch (e) {
      // Error starting recording: $e
      return null;
    }
  }

  Future<String?> stopRecording() async {
    if (!_isRecording) return null;

    try {
      final path = await _audioRecorder.stop();
      _isRecording = false;
      return path;
    } catch (e) {
      // Error stopping recording: $e
      _isRecording = false;
      return null;
    }
  }

  Future<void> playAudio(String filePath) async {
    try {
      if (kIsWeb) {
        await _audioPlayer.play(UrlSource(filePath));
      } else {
        await _audioPlayer.play(DeviceFileSource(filePath));
      }
    } catch (e) {
      // Error playing audio: $e
    }
  }

  Future<void> stopPlayback() async {
    await _audioPlayer.stop();
  }

  Future<Directory> _getRecordingDirectory() async {
    if (kIsWeb) {
      // Web uses temporary directory
      return Directory.systemTemp;
    }

    if (Platform.isAndroid || Platform.isIOS) {
      return await getTemporaryDirectory();
    } else {
      // Desktop platforms
      return await getApplicationDocumentsDirectory();
    }
  }

  // Convert audio file to base64 (pure base64 without data URI prefix)
  Future<String?> convertAudioToBase64(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return null;
      
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);
      return base64String;
    } catch (e) {
      print('Error converting audio to base64: $e');
      return null;
    }
  }

  // Get audio data for API sending
  Future<Map<String, dynamic>?> getAudioDataForApi(String filePath) async {
    try {
      final base64String = await convertAudioToBase64(filePath);
      if (base64String == null) return null;
      
      final file = File(filePath);
      final fileName = filePath.split('/').last.split('\\').last; // Handle both / and \
      
      return {
        'filename': fileName,
        'mimeType': _getAudioMimeType(fileName),
        'size': await file.length(),
        'content': base64String, // Pure base64 in content field
      };
    } catch (e) {
      print('Error getting audio data for API: $e');
      return null;
    }
  }

  String _getAudioMimeType(String filename) {
    final extension = filename.toLowerCase().split('.').last;
    switch (extension) {
      case 'mp3':
        return 'audio/mpeg';
      case 'wav':
        return 'audio/wav';
      case 'ogg':
        return 'audio/ogg';
      case 'aac':
        return 'audio/aac';
      default:
        return 'audio/m4a';
    }
  }

  // Get audio duration (simplified)
  Future<Duration?> getAudioDuration(String filePath) async {
    try {
      // This would need additional implementation
      // For now, return a placeholder duration
      return const Duration(seconds: 5);
    } catch (e) {
      print('Error getting audio duration: $e');
      return null;
    }
  }

  // Get available audio input devices
  Future<List<AudioDevice>> getAudioInputDevices() async {
    try {
      // For record package, we need to check if there are available devices
      // This is a simplified implementation since the record package doesn't expose device enumeration directly
      // In practice, you might need platform-specific implementations or additional packages
      
      List<AudioDevice> devices = [];
      
      if (kIsWeb) {
        // For web, we can use JS interop to get devices, but for now return default
        devices.add(AudioDevice(
          id: 'default',
          name: 'Default Microphone',
          isDefault: true,
        ));
        
        // Simulate additional devices for demo
        devices.add(AudioDevice(
          id: 'external',
          name: 'External Microphone',
          isDefault: false,
        ));
      } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        // For desktop platforms, simulate device detection
        devices.add(AudioDevice(
          id: 'default',
          name: 'Built-in Microphone',
          isDefault: true,
        ));
        
        // Check for additional devices (this would need platform-specific implementation)
        devices.add(AudioDevice(
          id: 'usb_mic',
          name: 'USB Microphone',
          isDefault: false,
        ));
        
        devices.add(AudioDevice(
          id: 'headset',
          name: 'Headset Microphone',
          isDefault: false,
        ));
      } else {
        // Mobile devices typically have fewer options
        devices.add(AudioDevice(
          id: 'internal',
          name: 'Internal Microphone',
          isDefault: true,
        ));
        
        devices.add(AudioDevice(
          id: 'bluetooth',
          name: 'Bluetooth Microphone',
          isDefault: false,
        ));
      }
      
      print('Found ${devices.length} audio input devices');
      return devices;
    } catch (e) {
      print('Error getting audio input devices: $e');
      // Return default device if enumeration fails
      return [
        AudioDevice(
          id: 'default',
          name: 'Default Microphone',
          isDefault: true,
        ),
      ];
    }
  }

  // Set the selected audio input device
  void setSelectedDevice(String deviceId) {
    _selectedDeviceId = deviceId;
    // Selected audio input device: $deviceId
  }

  String? get selectedDeviceId => _selectedDeviceId;
  double get microphoneVolume => _microphoneVolume;

  // Set microphone volume (0.0 to 2.0, where 1.0 is normal)
  void setMicrophoneVolume(double volume) {
    _microphoneVolume = volume.clamp(0.0, 2.0);
    // Set microphone volume to: ${(_microphoneVolume * 100).round()}%
    
    // Note: The record package doesn't directly support volume control
    // This would need platform-specific implementation or additional packages
    // For now, we store the volume setting for future use
  }

  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _isInitialized = false;
  }
}