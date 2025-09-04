import 'package:flutter/material.dart';

import '../localization/localization_helper.dart';
import '../services/audio_service.dart';

class MicrophoneSelector extends StatefulWidget {
  final Function(AudioDevice)? onMicrophoneSelected;
  final Color? primaryColor;
  final Function(double)? onVolumeChanged;
  final String language;

  const MicrophoneSelector({
    super.key,
    this.onMicrophoneSelected,
    this.primaryColor,
    this.onVolumeChanged,
    this.language = 'pt-BR',
  });

  @override
  State<MicrophoneSelector> createState() => _MicrophoneSelectorState();
}

class _MicrophoneSelectorState extends State<MicrophoneSelector> {
  final AudioService _audioService = AudioService();
  List<AudioDevice> _availableDevices = [];
  AudioDevice? _selectedDevice;
  bool _isLoading = true;
  double _microphoneVolume = 1.0;
  late final _localizations =
      LocalizationHelper.getLocalizations(widget.language);

  String _getLocalizedText(String key) {
    return _localizations.translate(key);
  }

  @override
  void initState() {
    super.initState();
    _loadAudioDevices();
  }

  Future<void> _loadAudioDevices() async {
    try {
      final devices = await _audioService.getAudioInputDevices();
      if (mounted) {
        setState(() {
          _availableDevices = devices;
          _selectedDevice = devices.firstWhere(
            (device) => device.isDefault,
            orElse: () => devices.isNotEmpty
                ? devices.first
                : AudioDevice(
                    id: 'default',
                    name: 'Default Microphone',
                    isDefault: true,
                  ),
          );
          _isLoading = false;
        });

        // Set the default selected device
        if (_selectedDevice != null) {
          _audioService.setSelectedDevice(_selectedDevice!.id);
        }
      }
    } catch (e) {
      print('Error loading audio devices: $e');
      if (mounted) {
        setState(() {
          _availableDevices = [
            AudioDevice(
              id: 'default',
              name: 'Default Microphone',
              isDefault: true,
            ),
          ];
          _selectedDevice = _availableDevices.first;
          _isLoading = false;
        });
      }
    }
  }

  void _onDeviceChanged(AudioDevice? device) {
    if (device != null && mounted) {
      setState(() {
        _selectedDevice = device;
      });

      _audioService.setSelectedDevice(device.id);

      if (widget.onMicrophoneSelected != null) {
        widget.onMicrophoneSelected!(device);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        widget.primaryColor ?? Theme.of(context).colorScheme.primary;

    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _getLocalizedText('detectingMicrophones'),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (_availableDevices.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              _getLocalizedText('noMicrophoneFound'),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.mic,
                color: effectiveColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _getLocalizedText('selectMicrophone'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: effectiveColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<AudioDevice>(
                value: _selectedDevice,
                isExpanded: true,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: effectiveColor,
                ),
                items: _availableDevices.map((AudioDevice device) {
                  return DropdownMenuItem<AudioDevice>(
                    value: device,
                    child: Row(
                      children: [
                        Icon(
                          device.isDefault ? Icons.mic : Icons.mic_external_on,
                          size: 18,
                          color: device.isDefault
                              ? effectiveColor
                              : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            device.name,
                            style: TextStyle(
                              fontSize: 14,
                              color: device.isDefault
                                  ? effectiveColor
                                  : Colors.black87,
                            ),
                          ),
                        ),
                        if (device.isDefault) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: effectiveColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _getLocalizedText('defaultMic'),
                              style: TextStyle(
                                fontSize: 10,
                                color: effectiveColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
                onChanged: _onDeviceChanged,
              ),
            ),
          ),

          // Volume control
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.volume_down,
                color: effectiveColor,
                size: 20,
              ),
              Expanded(
                child: Slider(
                  value: _microphoneVolume,
                  onChanged: (value) {
                    setState(() {
                      _microphoneVolume = value;
                    });
                    if (widget.onVolumeChanged != null) {
                      widget.onVolumeChanged!(value);
                    }
                    _audioService.setMicrophoneVolume(value);
                  },
                  min: 0.0,
                  max: 2.0,
                  divisions: 20,
                  activeColor: effectiveColor,
                  inactiveColor: effectiveColor.withValues(alpha: 0.3),
                  label: '${(_microphoneVolume * 100).round()}%',
                ),
              ),
              Icon(
                Icons.volume_up,
                color: effectiveColor,
                size: 20,
              ),
            ],
          ),

          Text(
            '${_getLocalizedText('volume')}: ${(_microphoneVolume * 100).round()}%',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),

          if (_availableDevices.length > 1) ...[
            const SizedBox(height: 12),
            Text(
              '${_availableDevices.length} ${_getLocalizedText('microphonesFound')}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
