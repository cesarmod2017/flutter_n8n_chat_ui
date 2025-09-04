import 'package:flutter/material.dart';
import 'dart:async';
import '../services/audio_service.dart';
import '../localization/localization_helper.dart';

class AudioRecorderWidget extends StatefulWidget {
  final Function(String audioPath) onAudioRecorded;
  final Color? buttonColor;
  final Color? backgroundColor;
  final String? recordingHint;
  final String language;

  const AudioRecorderWidget({
    super.key,
    required this.onAudioRecorded,
    this.buttonColor,
    this.backgroundColor,
    this.recordingHint,
    this.language = 'pt-BR',
  });

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget>
    with TickerProviderStateMixin {
  final AudioService _audioService = AudioService();
  bool _isRecording = false;
  bool _isInitializing = false;
  bool _hasRecording = false;
  bool _isPlaying = false;
  String? _lastRecordingPath;
  Duration _recordingDuration = Duration.zero;
  Duration _finalRecordingDuration = Duration.zero;
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late final _localizations = LocalizationHelper.getLocalizations(widget.language);

  String _getLocalizedText(String key) {
    return _localizations.translate(key);
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeAudioService();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _initializeAudioService() async {
    if (mounted) {
      setState(() {
        _isInitializing = true;
      });
    }

    await _audioService.initialize();

    if (mounted) {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _recordingDuration = Duration(seconds: timer.tick);
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    if (mounted) {
      setState(() {
        _finalRecordingDuration = _recordingDuration; // Save the final duration
        _recordingDuration = Duration.zero; // Reset current recording duration
      });
    }
  }

  Future<void> _startRecording() async {
    try {
      final recordingPath = await _audioService.startRecording();
      if (recordingPath != null && mounted) {
        setState(() {
          _isRecording = true;
        });
        _startTimer();
        _animationController.repeat(reverse: true);
      } else if (mounted) {
        _showErrorSnackBar('Failed to start recording');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error: ${e.toString()}');
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      final recordingPath = await _audioService.stopRecording();
      if (recordingPath != null && mounted) {
        setState(() {
          _hasRecording = true;
          _lastRecordingPath = recordingPath;
        });
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error stopping recording: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRecording = false;
        });
      }
      _stopTimer();
      _animationController.stop();
      _animationController.reset();
    }
  }

  Future<void> _playRecording() async {
    if (_lastRecordingPath == null || !mounted) return;
    
    try {
      if (_isPlaying) {
        await _audioService.stopPlayback();
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });
        }
      } else {
        await _audioService.playAudio(_lastRecordingPath!);
        if (mounted) {
          setState(() {
            _isPlaying = true;
          });
          
          // Auto-stop after playing
          Future.delayed(const Duration(seconds: 5), () {
            if (mounted) {
              setState(() {
                _isPlaying = false;
              });
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error playing audio: ${e.toString()}');
      }
    }
  }

  void _sendRecording() {
    if (_lastRecordingPath != null) {
      widget.onAudioRecorded(_lastRecordingPath!);
      if (mounted) {
        setState(() {
          _hasRecording = false;
          _lastRecordingPath = null;
          _recordingDuration = Duration.zero;
          _finalRecordingDuration = Duration.zero;
        });
      }
    }
  }

  void _deleteRecording() {
    if (mounted) {
      setState(() {
        _hasRecording = false;
        _lastRecordingPath = null;
        _recordingDuration = Duration.zero;
        _finalRecordingDuration = Duration.zero;
        _isPlaying = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const CircularProgressIndicator();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isRecording) ...[
            Text(
              widget.recordingHint ?? _getLocalizedText('recording'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatDuration(_recordingDuration),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          if (_hasRecording) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.audiotrack, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        '${_getLocalizedText('audioRecorded')} (${_formatDuration(_finalRecordingDuration)}))',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Play/Pause button
                      IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                        ),
                        iconSize: 32,
                        color: Colors.blue,
                        onPressed: _playRecording,
                      ),
                      // Delete button
                      IconButton(
                        icon: const Icon(Icons.delete),
                        iconSize: 32,
                        color: Colors.red,
                        onPressed: _deleteRecording,
                      ),
                      // Send button
                      IconButton(
                        icon: const Icon(Icons.send),
                        iconSize: 32,
                        color: Colors.green,
                        onPressed: _sendRecording,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          
          if (!_hasRecording) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_isRecording) ...[
                  // Cancel button
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    iconSize: 40,
                    color: Colors.grey,
                    onPressed: () {
                      if (mounted) {
                        setState(() {
                          _isRecording = false;
                        });
                      }
                      _stopTimer();
                      _animationController.stop();
                      _animationController.reset();
                    },
                  ),
                  // Stop and save button
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: IconButton(
                          icon: const Icon(Icons.stop),
                          iconSize: 60,
                          color: Colors.red,
                          onPressed: _stopRecording,
                        ),
                      );
                    },
                  ),
                ] else ...[
                  // Start recording button
                  IconButton(
                    icon: const Icon(Icons.mic),
                    iconSize: 60,
                    color: widget.buttonColor ?? Colors.red,
                    onPressed: _startRecording,
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// Widget para exibir áudio gravado
class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;
  final Color? buttonColor;
  final bool isFromUser;

  const AudioPlayerWidget({
    super.key,
    required this.audioPath,
    this.buttonColor,
    this.isFromUser = true,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget>
    with TickerProviderStateMixin {
  final AudioService _audioService = AudioService();
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration? _audioDuration;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _initializeWaveAnimation();
    _loadAudioInfo();
  }

  void _initializeWaveAnimation() {
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _waveAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
  }

  Future<void> _loadAudioInfo() async {
    try {
      final duration = await _audioService.getAudioDuration(widget.audioPath);
      if (mounted) {
        setState(() {
          _audioDuration = duration;
        });
      }
    } catch (e) {
      print('Error loading audio info: $e');
    }
  }

  Future<void> _playPause() async {
    if (_isLoading || !mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isPlaying) {
        await _audioService.stopPlayback();
        _waveController.stop();
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });
        }
      } else {
        await _audioService.playAudio(widget.audioPath);
        _waveController.repeat(reverse: true);
        if (mounted) {
          setState(() {
            _isPlaying = true;
          });
          
          // Auto-stop after playing (using duration or default)
          final playDuration = _audioDuration ?? const Duration(seconds: 5);
          Future.delayed(playDuration, () {
            if (mounted && _isPlaying) {
              _waveController.stop();
              setState(() {
                _isPlaying = false;
              });
            }
          });
        }
      }
    } catch (e) {
      print('Error playing/pausing audio: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '--:--';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _waveController.dispose();
    // Stop any playing audio when widget is disposed
    _audioService.stopPlayback().catchError((e) {
      // Ignore errors during disposal
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.buttonColor ?? Colors.blue;
    final backgroundColor = widget.isFromUser
        ? Colors.white.withValues(alpha: 0.2)
        : Colors.grey.shade100;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: effectiveColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play/Pause icon
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: _isLoading
                ? Container(
                    padding: const EdgeInsets.all(8),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        effectiveColor,
                      ),
                    ),
                  )
                : IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                      color: effectiveColor,
                      size: 32,
                    ),
                    onPressed: _playPause,
                    padding: EdgeInsets.zero,
                  ),
          ),
          
          const SizedBox(width: 8),
          
          // Audio waveform visualization
          AnimatedBuilder(
            animation: _waveAnimation,
            builder: (context, child) {
              return Row(
                children: List.generate(12, (index) {
                  final height = _isPlaying
                      ? 3.0 + (_waveAnimation.value * 15 * (index % 3 + 1))
                      : 8.0;
                  return Container(
                    width: 2,
                    height: height,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: effectiveColor.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  );
                }),
              );
            },
          ),
          
          const SizedBox(width: 8),
          
          // Duration
          Text(
            _formatDuration(_audioDuration),
            style: TextStyle(
              color: widget.isFromUser 
                  ? Colors.white.withValues(alpha: 0.8)
                  : Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}