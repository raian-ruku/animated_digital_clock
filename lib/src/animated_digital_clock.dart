library;

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

/// Represents the angles for the hour and minute hands of a single clock segment.
class ClockSegment {
  /// The angle of the hour hand in degrees.
  final double hourAngle;

  /// The angle of the minute hand in degrees.
  final double minuteAngle;

  /// Creates a new [ClockSegment] with the given angles.
  const ClockSegment(this.hourAngle, this.minuteAngle);
}

/// Defines the colors for the AM/PM period indicator.
class PeriodColors {
  /// The background color for the active period (AM/PM).
  final Color activeBackground;

  /// The background color for the inactive period (AM/PM).
  final Color inactiveBackground;

  /// The text color for the active period (AM/PM).
  final Color activeText;

  /// The text color for the inactive period (AM/PM).
  final Color inactiveText;

  /// Creates a new [PeriodColors] object.
  const PeriodColors({
    this.activeBackground = Colors.black,
    this.inactiveBackground = Colors.grey,
    this.activeText = Colors.white,
    this.inactiveText = Colors.white,
  });
}

/// Defines the colors for the control buttons (start, pause, reset).
class ControlButtonColors {
  /// The background color for the start button.
  final Color startBackground;

  /// The background color for the pause button.
  final Color pauseBackground;

  /// The background color for the reset button.
  final Color resetBackground;

  /// The text color for the start button.
  final Color startText;

  /// The text color for the pause button.
  final Color pauseText;

  /// The text color for the reset button.
  final Color resetText;

  /// Creates a new [ControlButtonColors] object.
  const ControlButtonColors({
    this.startBackground = Colors.black,
    this.pauseBackground = Colors.black,
    this.resetBackground = Colors.black,
    this.startText = Colors.white,
    this.pauseText = Colors.white,
    this.resetText = Colors.white,
  });
}

/// Defines the colors for the various parts of the clock.
class ClockColors {
  /// The background color of the entire widget.
  final Color background;

  /// The color of the inner shadow of the clock face.
  final Color innerShadow;

  /// The color of the bottom shadow of the clock face.
  final Color bottomShadow;

  /// The color of the top shadow of the clock face.
  final Color topShadow;

  /// The color of the clock face.
  final Color clockFace;

  /// The color of the clock border.
  final Color border;

  /// The color of the clock hands.
  final Color hand;

  /// The colors for the AM/PM period indicator.
  final PeriodColors periodColors;

  /// The colors for the control buttons.
  final ControlButtonColors controlButtonColors;

  /// Creates a new [ClockColors] object.
  const ClockColors({
    this.background = Colors.transparent,
    this.bottomShadow = const Color(0xFFd0d0d0),
    this.innerShadow = const Color(0xFFd0d0d0),
    this.topShadow = Colors.white,
    this.clockFace = const Color(0xFFffffff),
    this.border = Colors.white,
    this.hand = Colors.black,
    this.periodColors = const PeriodColors(),
    this.controlButtonColors = const ControlButtonColors(),
  });
}

/// The mode of operation for the [ClockWidget].
enum ClockMode {
  /// Displays the current time.
  clock,

  /// A countdown timer.
  timer,

  /// A stopwatch.
  stopwatch,

  /// Displays a static, non-updating time.
  static
}

/// A controller for the [ClockWidget] when in timer or stopwatch mode.
class ClockController {
  /// A callback function to start the timer or stopwatch.
  VoidCallback? onStart;

  /// A callback function to pause the timer or stopwatch.
  VoidCallback? onPause;

  /// A callback function to reset the timer or stopwatch.
  VoidCallback? onReset;

  /// A [ValueNotifier] that indicates whether the timer or stopwatch is running.
  final ValueNotifier<bool> isRunning;

  /// A [ValueNotifier] that holds the current duration of the timer or stopwatch.
  final ValueNotifier<Duration> currentDuration;

  /// Creates a new [ClockController].
  ClockController()
      : isRunning = ValueNotifier(false),
        currentDuration = ValueNotifier(Duration.zero);
}

/// A widget that displays a digital clock made of analog clock faces.
class ClockWidget extends StatefulWidget {
  /// The size of each individual clock segment.
  final double clockSize;

  /// The height of the widget. If null, it's calculated based on [clockSize].
  final double? height;

  /// The color scheme for the clock.
  final ClockColors colors;

  /// Whether to use 12-hour format with an AM/PM indicator.
  final bool twelveHourFormat;

  /// The mode of operation for the clock.
  final ClockMode mode;

  /// The initial duration for the timer.
  final Duration? initialTimerDuration;

  /// Whether to display shadows on the clock faces.
  final bool shadow;

  /// The width of the border for each clock segment.
  final double borderWidth;

  /// The width of the hands for each clock segment.
  final double handWidth;

  /// A controller for the timer and stopwatch modes.
  final ClockController? controller;

  /// Whether to show the control buttons (start, pause, reset).
  final bool showControls;

  /// Whether to show the start button.
  final bool showStartButton;

  /// Whether to show the pause button.
  final bool showPauseButton;

  /// Whether to show the reset button.
  final bool showResetButton;

  /// The text for the start button.
  final String startButtonText;

  /// The text for the pause button.
  final String pauseButtonText;

  /// The text for the reset button.
  final String resetButtonText;

  /// The width of the control buttons.
  final double? buttonWidth;

  /// The height of the control buttons.
  final double? buttonHeight;

  /// The font size for the control button text.
  final double? buttonFontSize;

  /// The padding for the control buttons.
  final EdgeInsets? buttonPadding;

  /// The static time to display in [ClockMode.static].
  final DateTime? staticTime;

  /// Whether to animate the clock hands to their initial position in [ClockMode.static].
  final bool animateToPosition;

  /// Creates a [ClockWidget] that displays the current time.
  const ClockWidget.clock({
    super.key,
    this.clockSize = 20.0,
    this.height,
    this.colors = const ClockColors(),
    this.twelveHourFormat = false,
    this.shadow = true,
    this.borderWidth = 2.0,
    this.handWidth = 2.0,
    this.controller,
    this.showControls = false,
    this.showStartButton = true,
    this.showPauseButton = true,
    this.showResetButton = true,
    this.startButtonText = 'Start',
    this.pauseButtonText = 'Pause',
    this.resetButtonText = 'Reset',
    this.buttonWidth,
    this.buttonHeight,
    this.buttonFontSize,
    this.buttonPadding,
  })  : mode = ClockMode.clock,
        initialTimerDuration = null,
        staticTime = null,
        animateToPosition = false;

  /// Creates a [ClockWidget] that functions as a countdown timer.
  const ClockWidget.timer({
    super.key,
    this.clockSize = 20.0,
    this.height,
    this.colors = const ClockColors(),
    this.initialTimerDuration,
    this.shadow = true,
    this.borderWidth = 2.0,
    this.handWidth = 2.0,
    required this.controller,
    this.showControls = false,
    this.showStartButton = true,
    this.showPauseButton = true,
    this.showResetButton = true,
    this.startButtonText = 'Start',
    this.pauseButtonText = 'Pause',
    this.resetButtonText = 'Reset',
    this.buttonWidth,
    this.buttonHeight,
    this.buttonFontSize,
    this.buttonPadding,
  })  : mode = ClockMode.timer,
        twelveHourFormat = false,
        staticTime = null,
        animateToPosition = false;

  /// Creates a [ClockWidget] that functions as a stopwatch.
  const ClockWidget.stopwatch({
    super.key,
    this.clockSize = 20.0,
    this.height,
    this.colors = const ClockColors(),
    this.borderWidth = 2.0,
    this.handWidth = 2.0,
    required this.controller,
    this.showControls = false,
    this.showStartButton = true,
    this.showPauseButton = true,
    this.showResetButton = true,
    this.startButtonText = 'Start',
    this.pauseButtonText = 'Pause',
    this.resetButtonText = 'Reset',
    this.buttonWidth,
    this.buttonHeight,
    this.buttonFontSize,
    this.buttonPadding,
  })  : mode = ClockMode.stopwatch,
        shadow = true,
        twelveHourFormat = false,
        initialTimerDuration = null,
        staticTime = null,
        animateToPosition = false;

  /// Creates a [ClockWidget] that displays a static, non-updating time.
  const ClockWidget.static({
    super.key,
    this.clockSize = 20.0,
    this.height,
    this.colors = const ClockColors(),
    this.twelveHourFormat = false,
    this.shadow = true,
    this.borderWidth = 2.0,
    this.handWidth = 2.0,
    required this.staticTime,
    this.animateToPosition = true,
  })  : mode = ClockMode.static,
        controller = null,
        showControls = false,
        showStartButton = true,
        showPauseButton = true,
        showResetButton = true,
        startButtonText = 'Start',
        pauseButtonText = 'Pause',
        resetButtonText = 'Reset',
        buttonWidth = null,
        buttonHeight = null,
        buttonFontSize = null,
        buttonPadding = null,
        initialTimerDuration = null;

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget>
    with SingleTickerProviderStateMixin {
  static const H = ClockSegment(0, 180);
  static const V = ClockSegment(270, 90);
  static const TL = ClockSegment(180, 270);
  static const TR = ClockSegment(0, 270);
  static const BL = ClockSegment(180, 90);
  static const BR = ClockSegment(0, 90);
  static const E = ClockSegment(135, 135);

  static final List<List<ClockSegment>> digits = [
    [
      BR,
      H,
      H,
      BL,
      V,
      BR,
      BL,
      V,
      V,
      V,
      V,
      V,
      V,
      V,
      V,
      V,
      V,
      TR,
      TL,
      V,
      TR,
      H,
      H,
      TL,
    ],
    [
      BR,
      H,
      BL,
      E,
      TR,
      BL,
      V,
      E,
      E,
      V,
      V,
      E,
      E,
      V,
      V,
      E,
      BR,
      TL,
      TR,
      BL,
      TR,
      H,
      H,
      TL,
    ],
    [
      BR,
      H,
      H,
      BL,
      TR,
      H,
      BL,
      V,
      BR,
      H,
      TL,
      V,
      V,
      BR,
      H,
      TL,
      V,
      TR,
      H,
      BL,
      TR,
      H,
      H,
      TL,
    ],
    [
      BR,
      H,
      H,
      BL,
      TR,
      H,
      BL,
      V,
      E,
      BR,
      TL,
      V,
      E,
      TR,
      BL,
      V,
      BR,
      H,
      TL,
      V,
      TR,
      H,
      H,
      TL,
    ],
    [
      BR,
      BL,
      BR,
      BL,
      V,
      V,
      V,
      V,
      V,
      TR,
      TL,
      V,
      TR,
      H,
      BL,
      V,
      E,
      E,
      V,
      V,
      E,
      E,
      TR,
      TL,
    ],
    [
      BR,
      H,
      H,
      BL,
      V,
      BR,
      H,
      TL,
      V,
      TR,
      H,
      BL,
      TR,
      H,
      BL,
      V,
      BR,
      H,
      TL,
      V,
      TR,
      H,
      H,
      TL,
    ],
    [
      BR,
      H,
      H,
      BL,
      V,
      BR,
      H,
      TL,
      V,
      TR,
      H,
      BL,
      V,
      BR,
      BL,
      V,
      V,
      TR,
      TL,
      V,
      TR,
      H,
      H,
      TL,
    ],
    [
      BR,
      H,
      H,
      BL,
      TR,
      H,
      BL,
      V,
      E,
      E,
      V,
      V,
      E,
      E,
      V,
      V,
      E,
      E,
      V,
      V,
      E,
      E,
      TR,
      TL,
    ],
    [
      BR,
      H,
      H,
      BL,
      V,
      BR,
      BL,
      V,
      V,
      TR,
      TL,
      V,
      V,
      BR,
      BL,
      V,
      V,
      TR,
      TL,
      V,
      TR,
      H,
      H,
      TL,
    ],
    [
      BR,
      H,
      H,
      BL,
      V,
      BR,
      BL,
      V,
      V,
      TR,
      TL,
      V,
      TR,
      H,
      BL,
      V,
      BR,
      H,
      TL,
      V,
      TR,
      H,
      H,
      TL,
    ],
  ];

  final Random _random = Random();
  Timer? _updateTimer;
  Timer? _initialTimer;
  bool _initial = true;
  List<int> _time = List.filled(6, 0);
  late AnimationController _animationController;
  String _period = 'AM'; // AM or PM

  // Timer/Stopwatch specific variables
  Duration _timerDuration = Duration.zero;
  Duration _elapsedTime = Duration.zero;
  bool _isRunning = false;
  late Duration _initialDuration;

  // Controller
  late ClockController _internalController;

  final Map<String, _ClockAngles> _clockAngles = {};

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Initialize internal controller
    _internalController = ClockController();

    // Use provided controller or internal one
    final controller = widget.controller ?? _internalController;

    // Setup controller callbacks
    controller.onStart = _startControl;
    controller.onPause = _pauseControl;
    controller.onReset = _resetControl;

    // Initialize based on mode
    switch (widget.mode) {
      case ClockMode.clock:
        _initializeRandomAngles();
        _initialTimer = Timer(const Duration(milliseconds: 600), () {
          setState(() {
            _initial = false;
          });
          _animationController.forward();
          _updateTime();
        });
        break;
      case ClockMode.timer:
        _initialDuration =
            widget.initialTimerDuration ?? const Duration(minutes: 5);
        _timerDuration = _initialDuration;
        _updateTimeDigitsFromDuration(_timerDuration);
        _initializeRandomAngles();
        _initialTimer = Timer(const Duration(milliseconds: 600), () {
          setState(() {
            _initial = false;
          });
          _animationController.forward();
        });
        break;
      case ClockMode.stopwatch:
        _elapsedTime = Duration.zero;
        _updateTimeDigitsFromDuration(_elapsedTime);
        _initializeRandomAngles();
        _initialTimer = Timer(const Duration(milliseconds: 600), () {
          setState(() {
            _initial = false;
          });
          _animationController.forward();
        });
        break;
      case ClockMode.static:
        // For static mode, set the time directly from the provided DateTime
        _updateTimeDigitsFromDateTime(widget.staticTime!);
        if (widget.animateToPosition) {
          _initializeRandomAngles();
          _initialTimer = Timer(const Duration(milliseconds: 600), () {
            setState(() {
              _initial = false;
            });
            _animationController.forward();
          });
        } else {
          // Set directly to final positions without animation
          _setFinalAngles();
          _initial = false;
          _animationController.value = 1.0; // Set animation to complete
        }
        break;
    }
  }

  void _updateTimeDigitsFromDateTime(DateTime dateTime) {
    int hour = dateTime.hour;

    if (widget.twelveHourFormat) {
      _period = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      hour = hour == 0 ? 12 : hour;
    }

    final minutes = dateTime.minute;
    final seconds = dateTime.second;

    _time = [hour, minutes, seconds]
        .expand(
          (val) => val.toString().padLeft(2, '0').split('').map(int.parse),
        )
        .toList();
  }

  void _updateTimeDigitsFromDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    _time = [hours, minutes, seconds]
        .expand(
          (val) => val.toString().padLeft(2, '0').split('').map(int.parse),
        )
        .toList();
  }

  void _initializeRandomAngles() {
    for (int digitIndex = 0; digitIndex < 6; digitIndex++) {
      for (int clockIndex = 0; clockIndex < 24; clockIndex++) {
        final key = '$digitIndex-$clockIndex';
        _clockAngles[key] = _ClockAngles(
          hourAngle: _random.nextDouble() * 360,
          minuteAngle: _random.nextDouble() * 360,
        );
      }
    }
  }

  void _setFinalAngles() {
    for (int digitIndex = 0; digitIndex < 6; digitIndex++) {
      for (int clockIndex = 0; clockIndex < 24; clockIndex++) {
        final key = '$digitIndex-$clockIndex';
        final targetData = digits[_time[digitIndex]][clockIndex];
        _clockAngles[key] = _ClockAngles(
          hourAngle: targetData.hourAngle,
          minuteAngle: targetData.minuteAngle,
        );
      }
    }
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _initialTimer?.cancel();
    _animationController.dispose();
    _internalController.isRunning.dispose();
    _internalController.currentDuration.dispose();
    super.dispose();
  }

  // Clock mode methods
  List<int> _getTimeDigits() {
    final now = DateTime.now();
    int hour = now.hour;

    if (widget.twelveHourFormat) {
      _period = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      hour = hour == 0 ? 12 : hour;
    }

    return [hour, now.minute, now.second]
        .expand(
          (val) => val.toString().padLeft(2, '0').split('').map(int.parse),
        )
        .toList();
  }

  void _updateTime() {
    void update() {
      if (mounted) {
        setState(() {
          _time = _getTimeDigits();
        });
        _animationController.forward(from: 0.0);

        final now = DateTime.now().millisecondsSinceEpoch;
        final delay = 1000 - (now % 1000);
        _updateTimer = Timer(Duration(milliseconds: delay), update);
      }
    }

    update();
  }

  // Timer mode methods
  void _updateTimerDisplay() {
    if (_isRunning && _timerDuration > Duration.zero) {
      _updateTimer = Timer(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _timerDuration -= const Duration(seconds: 1);
            _updateTimeDigitsFromDuration(_timerDuration);
            _internalController.currentDuration.value = _timerDuration;
          });
          _animationController.forward(from: 0.0);

          if (_timerDuration <= Duration.zero) {
            _isRunning = false;
            _internalController.isRunning.value = false;
            // Timer completed
          } else {
            _updateTimerDisplay();
          }
        }
      });
    }
  }

  void _startTimer() {
    if (!_isRunning && _timerDuration > Duration.zero) {
      setState(() {
        _isRunning = true;
        _internalController.isRunning.value = true;
      });
      _updateTimerDisplay();
    }
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
      _internalController.isRunning.value = false;
    });
    _updateTimer?.cancel();
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _internalController.isRunning.value = false;
      _timerDuration = _initialDuration;
      _internalController.currentDuration.value = _timerDuration;
      _updateTimeDigitsFromDuration(_timerDuration);
    });
    _updateTimer?.cancel();
  }

  // Stopwatch mode methods
  void _updateStopwatchDisplay() {
    if (_isRunning) {
      _updateTimer = Timer(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _elapsedTime += const Duration(seconds: 1);
            _internalController.currentDuration.value = _elapsedTime;
            _updateTimeDigitsFromDuration(_elapsedTime);
          });
          _animationController.forward(from: 0.0);
          _updateStopwatchDisplay();
        }
      });
    }
  }

  void _startStopwatch() {
    if (!_isRunning) {
      setState(() {
        _isRunning = true;
        _internalController.isRunning.value = true;
      });
      _updateStopwatchDisplay();
    }
  }

  void _pauseStopwatch() {
    setState(() {
      _isRunning = false;
      _internalController.isRunning.value = false;
    });
    _updateTimer?.cancel();
  }

  void _resetStopwatch() {
    setState(() {
      _isRunning = false;
      _internalController.isRunning.value = false;
      _elapsedTime = Duration.zero;
      _internalController.currentDuration.value = _elapsedTime;
      _updateTimeDigitsFromDuration(_elapsedTime);
    });
    _updateTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final clockSize = widget.clockSize;
    final gap = clockSize * 0.05;
    final clockSegmentW = clockSize * 4 + gap * 3;
    final clockSegmentH = clockSize * 6 + gap * 5;

    // Calculate dynamic button sizes based on clockSize
    final double buttonWidth =
        widget.buttonWidth ?? max(clockSize * 2.5, 40.0); // Minimum 40 width
    final double buttonHeight =
        widget.buttonHeight ?? max(clockSize * 0.8, 20.0); // Minimum 20 height
    final double buttonFontSize = widget.buttonFontSize ??
        max(clockSize * 0.35, 10.0); // Minimum 10 font size
    final EdgeInsets buttonPadding = widget.buttonPadding ??
        EdgeInsets.symmetric(
          vertical: max(clockSize * 0.2, 2.0), // Minimum 4 padding
          horizontal: max(clockSize * 0.3, 6.0), // Minimum 8 padding
        );

    // Calculate total width - include space for AM/PM if needed
    double totalWidth = (clockSegmentW * 6) + (gap * 8) + (clockSize * 2);

    if (widget.twelveHourFormat) {
      totalWidth += clockSize * 3 + gap * 2;
    }

    // Add space for controls only if explicitly requested
    if (widget.mode != ClockMode.clock &&
        widget.mode != ClockMode.static &&
        widget.showControls) {
      totalWidth += buttonWidth + gap * 2;
    }

    final totalHeight = widget.height ?? clockSegmentH + gap * 4;

    return Container(
      color: widget.colors.background,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;
          final needsScroll = totalWidth > availableWidth;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: needsScroll
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            child: Container(
              height: totalHeight,
              width: needsScroll ? totalWidth : null,
              padding: EdgeInsets.symmetric(
                horizontal: gap * 2,
                vertical: gap * 2,
              ),
              child: Row(
                mainAxisAlignment: needsScroll
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Time digits
                  ..._time.asMap().entries.map((entry) {
                    final index = entry.key;
                    final digit = entry.value;
                    return Container(
                      margin: EdgeInsets.only(
                        right: index == 5
                            ? (widget.twelveHourFormat ? clockSize : gap)
                            : (index.isOdd ? clockSize : gap),
                      ),
                      width: clockSegmentW,
                      height: clockSegmentH,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: gap,
                          mainAxisSpacing: gap,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: 24,
                        itemBuilder: (context, clockIndex) {
                          final clockData = digits[digit][clockIndex];
                          return Container(
                            margin: EdgeInsets.all(gap * 0.3),
                            child: _buildAnimatedClock(
                              clockData,
                              '$index-$clockIndex',
                              clockSize: clockSize,
                            ),
                          );
                        },
                      ),
                    );
                  }),

                  // AM/PM indicator if 12-hour format is enabled (original style)
                  if (widget.twelveHourFormat) ...[
                    SizedBox(width: gap),
                    _buildPeriodIndicator(),
                  ],

                  // Controls for timer/stopwatch only if explicitly requested
                  if ((widget.mode == ClockMode.timer ||
                          widget.mode == ClockMode.stopwatch) &&
                      widget.showControls) ...[
                    SizedBox(width: gap * 2),
                    _buildControls(
                      buttonWidth: buttonWidth,
                      buttonHeight: buttonHeight,
                      buttonFontSize: buttonFontSize,
                      buttonPadding: buttonPadding,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPeriodIndicator() {
    return Container(
      width: widget.clockSize * 2,
      height: clockSegmentH,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPeriodSegment('A', _period == 'AM'),
          SizedBox(height: widget.clockSize * 0.8),
          _buildPeriodSegment('P', _period == 'PM'),
          SizedBox(height: widget.clockSize * 0.8),
          _buildPeriodSegment('M', true),
        ],
      ),
    );
  }

  Widget _buildPeriodSegment(String letter, bool isActive) {
    final periodColors = widget.colors.periodColors;

    return Container(
      width: widget.clockSize * 1.2,
      height: widget.clockSize * 1.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isActive
            ? periodColors.activeBackground
            : periodColors.inactiveBackground,
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            color:
                isActive ? periodColors.activeText : periodColors.inactiveText,
            fontSize: widget.clockSize * 0.6,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildControls({
    required double buttonWidth,
    required double buttonHeight,
    required double buttonFontSize,
    required EdgeInsets buttonPadding,
  }) {
    final controlButtons = <Widget>[];

    // Add Start button when not running
    if (!_isRunning && widget.showStartButton) {
      controlButtons.addAll([
        _buildControlButton(
          widget.startButtonText,
          _startControl,
          widget.colors.controlButtonColors.startBackground,
          widget.colors.controlButtonColors.startText,
          buttonWidth: buttonWidth,
          buttonHeight: buttonHeight,
          buttonFontSize: buttonFontSize,
          buttonPadding: buttonPadding,
        ),
        SizedBox(height: max(widget.clockSize * 0.3, 8.0)), // Minimum 8 spacing
      ]);
    }

    // Add Pause button when running
    if (_isRunning && widget.showPauseButton) {
      controlButtons.addAll([
        _buildControlButton(
          widget.pauseButtonText,
          _pauseControl,
          widget.colors.controlButtonColors.pauseBackground,
          widget.colors.controlButtonColors.pauseText,
          buttonWidth: buttonWidth,
          buttonHeight: buttonHeight,
          buttonFontSize: buttonFontSize,
          buttonPadding: buttonPadding,
        ),
        SizedBox(height: max(widget.clockSize * 0.3, 8.0)), // Minimum 8 spacing
      ]);
    }

    // Add Reset button
    if (widget.showResetButton) {
      controlButtons.add(
        _buildControlButton(
          widget.resetButtonText,
          _resetControl,
          widget.colors.controlButtonColors.resetBackground,
          widget.colors.controlButtonColors.resetText,
          buttonWidth: buttonWidth,
          buttonHeight: buttonHeight,
          buttonFontSize: buttonFontSize,
          buttonPadding: buttonPadding,
        ),
      );
    }

    return Container(
      width: buttonWidth,
      height: clockSegmentH,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: controlButtons,
      ),
    );
  }

  Widget _buildControlButton(
    String text,
    VoidCallback onPressed,
    Color backgroundColor,
    Color textColor, {
    required double buttonWidth,
    required double buttonHeight,
    required double buttonFontSize,
    required EdgeInsets buttonPadding,
  }) {
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: buttonPadding,
          minimumSize: Size(buttonWidth, buttonHeight),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: buttonFontSize,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _startControl() {
    switch (widget.mode) {
      case ClockMode.timer:
        _startTimer();
        break;
      case ClockMode.stopwatch:
        _startStopwatch();
        break;
      case ClockMode.clock:
      case ClockMode.static:
        break;
    }
  }

  void _pauseControl() {
    switch (widget.mode) {
      case ClockMode.timer:
        _pauseTimer();
        break;
      case ClockMode.stopwatch:
        _pauseStopwatch();
        break;
      case ClockMode.clock:
      case ClockMode.static:
        break;
    }
  }

  void _resetControl() {
    switch (widget.mode) {
      case ClockMode.timer:
        _resetTimer();
        break;
      case ClockMode.stopwatch:
        _resetStopwatch();
        break;
      case ClockMode.clock:
      case ClockMode.static:
        break;
    }
  }

  Widget _buildAnimatedClock(
    ClockSegment targetData,
    String key, {
    required double clockSize,
  }) {
    final currentAngles = _clockAngles[key] ??
        _ClockAngles(
          hourAngle: _random.nextDouble() * 360,
          minuteAngle: _random.nextDouble() * 360,
        );

    final targetHourAngle = _normalizeAngle(
      targetData.hourAngle,
      currentAngles.hourAngle,
    );
    final targetMinuteAngle = _normalizeAngle(
      targetData.minuteAngle,
      currentAngles.minuteAngle,
    );

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final animation = Curves.easeInOut.transform(
          _animationController.value,
        );

        final currentHourAngle = _initial
            ? currentAngles.hourAngle
            : currentAngles.hourAngle +
                (targetHourAngle - currentAngles.hourAngle) * animation;

        final currentMinuteAngle = _initial
            ? currentAngles.minuteAngle
            : currentAngles.minuteAngle +
                (targetMinuteAngle - currentAngles.minuteAngle) * animation;

        _clockAngles[key] = _ClockAngles(
          hourAngle: _initial ? currentAngles.hourAngle : currentHourAngle,
          minuteAngle:
              _initial ? currentAngles.minuteAngle : currentMinuteAngle,
        );

        return SizedBox(
          width: clockSize,
          height: clockSize,
          child: CustomPaint(
            painter: _ClockPainter(
              hourAngle: currentHourAngle,
              minuteAngle: currentMinuteAngle,
              clockSize: clockSize,
              colors: widget.colors,
              shadow: widget.shadow,
              borderWidth: widget.borderWidth,
              handWidth: widget.handWidth,
            ),
          ),
        );
      },
    );
  }

  double get clockSegmentH =>
      widget.clockSize * 6 + (widget.clockSize * 0.05) * 5;

  double _normalizeAngle(double next, double prev) {
    final delta = ((next - prev) % 360 + 360) % 360;
    return prev + (delta > 180 ? delta - 360 : delta);
  }
}

class _ClockAngles {
  final double hourAngle;
  final double minuteAngle;

  _ClockAngles({required this.hourAngle, required this.minuteAngle});
}

class _ClockPainter extends CustomPainter {
  final double hourAngle;
  final double minuteAngle;
  final double clockSize;
  final ClockColors colors;
  final bool shadow;
  final double borderWidth;
  final double handWidth;

  _ClockPainter({
    required this.hourAngle,
    required this.minuteAngle,
    required this.clockSize,
    required this.colors,
    required this.shadow,
    required this.borderWidth,
    required this.handWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final clockRadius = size.width / 2;

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [colors.innerShadow, colors.clockFace],
      stops: const [0.1, 1.0],
    );
    final backgroundPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: clockRadius),
      );
    if (shadow == true) {
      final darkShadowPaint = Paint()
        ..color = colors.bottomShadow
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      final lightShadowPaint = Paint()
        ..color = colors.topShadow
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      canvas.drawCircle(center.translate(-2, 2), clockRadius, darkShadowPaint);
      canvas.drawCircle(center.translate(2, -2), clockRadius, lightShadowPaint);
    }
    canvas.drawCircle(center, clockRadius, backgroundPaint);

    final borderPaint = Paint()
      ..color = colors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawCircle(center, clockRadius, borderPaint);

    final handPaint = Paint()
      ..color = colors.hand
      ..style = PaintingStyle.stroke
      ..strokeWidth = handWidth
      ..strokeCap = StrokeCap.round;

    final handLength = size.width * 0.47;

    final hourEnd = Offset(
      center.dx + handLength * cos(hourAngle * pi / 180),
      center.dy + handLength * sin(hourAngle * pi / 180),
    );
    final minuteEnd = Offset(
      center.dx + handLength * cos(minuteAngle * pi / 180),
      center.dy + handLength * sin(minuteAngle * pi / 180),
    );

    canvas.drawLine(center, hourEnd, handPaint);
    canvas.drawLine(center, minuteEnd, handPaint);
  }

  @override
  bool shouldRepaint(covariant _ClockPainter oldDelegate) {
    return hourAngle != oldDelegate.hourAngle ||
        minuteAngle != oldDelegate.minuteAngle ||
        clockSize != oldDelegate.clockSize ||
        colors.background != oldDelegate.colors.background ||
        colors.hand != oldDelegate.colors.hand;
  }
}