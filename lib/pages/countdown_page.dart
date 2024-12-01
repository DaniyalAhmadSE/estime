import 'dart:async';
import 'package:estime/utils/duration_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_countdown/slide_countdown.dart';

class CountdownPage extends StatefulWidget {
  final double Function() _getResult;
  final String Function() _getUnitOfTime;
  final VoidCallback _restart;
  final Future<void> Function(double) _savePenalty;
  final Future<void> Function(double) _saveConfidence;

  const CountdownPage({
    super.key,
    required double Function() getResult,
    required String Function() getUnit,
    required void Function() resetData,
    required Future<void> Function(double) saveConfidence,
    required Future<void> Function(double) savePenalty,
  })  : _getResult = getResult,
        _getUnitOfTime = getUnit,
        _restart = resetData,
        _saveConfidence = saveConfidence,
        _savePenalty = savePenalty;

  @override
  State<CountdownPage> createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  late StreamDuration _downStreamController;
  late StreamDuration _upStreamController;
  bool _isCounting = false;
  bool _isCountingUp = false;
  bool _hasCountdownStarted = false;

  void _startCountdown() {
    setState(() {
      _isCounting = true;
      _hasCountdownStarted = true;
    });
    _downStreamController.play();
  }

  Future<void> _stopCountdown() async {
    setState(() {
      _isCounting = false;
    });
    _downStreamController.pause();
    _upStreamController.pause();

    await widget
        ._saveConfidence(_downStreamController.value.inSeconds.toDouble());
    await widget._savePenalty(_upStreamController.value.inSeconds.toDouble());
  }

  void _onZero() {
    _downStreamController.pause();
    setState(() {
      _isCountingUp = true;
    });
    _upStreamController.play();
  }

  void _initializeStreamControllers() {
    _downStreamController = StreamDuration(
      config: StreamDurationConfig(
        autoPlay: false,
        countDownConfig: CountDownConfig(
          duration: Duration(
            seconds: DurationUtils()
                .convertDurationToSeconds(
                  widget._getResult(),
                  widget._getUnitOfTime(),
                )
                .toInt(),
          ),
        ),
        onDone: _onZero,
      ),
    );

    _upStreamController = StreamDuration(
      config: const StreamDurationConfig(
        autoPlay: false,
        countUpConfig: CountUpConfig(
          initialDuration: Duration.zero,
          maxDuration: null,
        ),
        isCountUp: true,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeStreamControllers();
  }

  @override
  void setState(void Function() fn) {
    super.setState(fn);
    if (!_hasCountdownStarted) _initializeStreamControllers();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasCountdownStarted) _initializeStreamControllers();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Countdown',
            style: GoogleFonts.acme(
              textStyle: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          if (!_isCountingUp)
            SlideCountdown(
              streamDuration: _downStreamController,
              showZeroValue: true,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.teal,
              ),
            ),
          const SizedBox(),
          if (_isCountingUp)
            SlideCountdown(
              streamDuration: _upStreamController,
              showZeroValue: true,
              countUp: true,
              infinityCountUp: true,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.red,
              ),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _hasCountdownStarted ? null : _startCountdown,
                child: const Text('Start Countdown'),
              ),
              const SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: _isCounting ? _stopCountdown : widget._restart,
                child: Text(_isCounting ? 'Stop' : 'Restart'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
