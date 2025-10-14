import 'package:animated_digital_clock/animated_digital_clock.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Clock Widget Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ClockDemoPage(),
    );
  }
}

class ClockDemoPage extends StatefulWidget {
  const ClockDemoPage({super.key});

  @override
  State<ClockDemoPage> createState() => _ClockDemoPageState();
}

class _ClockDemoPageState extends State<ClockDemoPage> {
  int _currentTab = 0;

  final List<Widget> _tabs = [
    const ClockTab(),
    const TimerTab(),
    const StopwatchTab(),
    const StaticTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Clock Widget Demo'),
        bottom: TabBar(
          onTap: (index) => setState(() => _currentTab = index),
          tabs: const [
            Tab(text: 'Clock'),
            Tab(text: 'Timer'),
            Tab(text: 'Stopwatch'),
            Tab(text: 'Static'),
          ],
        ),
      ),
      body: _tabs[_currentTab],
    );
  }
}

class ClockTab extends StatelessWidget {
  const ClockTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Real-time Clock',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const ClockWidget.clock(
            clockSize: 15.0,
            twelveHourFormat: false,
          ),
          const SizedBox(height: 30),
          const Text(
            '12-Hour Format with AM/PM',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          const ClockWidget.clock(
            clockSize: 15.0,
            twelveHourFormat: true,
          ),
          const SizedBox(height: 30),
          const Text(
            'Custom Styled Clock',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          ClockWidget.clock(
            clockSize: 12.0,
            colors: ClockColors(
              hand: Colors.blue,
              clockFace: Colors.grey[100]!,
              border: Colors.blue,
              background: Colors.blue[50]!,
            ),
          ),
        ],
      ),
    );
  }
}

class TimerTab extends StatefulWidget {
  const TimerTab({super.key});

  @override
  State<TimerTab> createState() => _TimerTabState();
}

class _TimerTabState extends State<TimerTab> {
  final ClockController _controller = ClockController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Countdown Timer',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ClockWidget.timer(
            clockSize: 15.0,
            initialTimerDuration: const Duration(minutes: 5),
            controller: _controller,
            showControls: true,
            colors: ClockColors(
              hand: Colors.red,
              controlButtonColors: ControlButtonColors(
                startBackground: Colors.green,
                pauseBackground: Colors.orange,
                resetBackground: Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder<Duration>(
            valueListenable: _controller.currentDuration,
            builder: (context, duration, child) {
              return Text(
                'Remaining: ${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 16),
              );
            },
          ),
        ],
      ),
    );
  }
}

class StopwatchTab extends StatefulWidget {
  const StopwatchTab({super.key});

  @override
  State<StopwatchTab> createState() => _StopwatchTabState();
}

class _StopwatchTabState extends State<StopwatchTab> {
  final ClockController _controller = ClockController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Stopwatch',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ClockWidget.stopwatch(
            clockSize: 15.0,
            controller: _controller,
            showControls: true,
            colors: ClockColors(
              hand: Colors.green,
              controlButtonColors: ControlButtonColors(
                startBackground: Colors.green,
                pauseBackground: Colors.orange,
                resetBackground: Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder<Duration>(
            valueListenable: _controller.currentDuration,
            builder: (context, duration, child) {
              return Text(
                'Elapsed: ${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 16),
              );
            },
          ),
        ],
      ),
    );
  }
}

class StaticTab extends StatelessWidget {
  const StaticTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Static Time Display',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            'Fixed Time (No Animation)',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          ClockWidget.static(
            staticTime: DateTime(2023, 12, 25, 14, 30, 45),
            clockSize: 15.0,
            animateToPosition: false,
          ),
          const SizedBox(height: 30),
          const Text(
            'Fixed Time with Animation',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          ClockWidget.static(
            staticTime: DateTime(2023, 10, 31, 20, 15, 0),
            clockSize: 15.0,
            animateToPosition: true,
            colors: ClockColors(
              hand: Colors.orange,
              clockFace: Colors.black,
              border: Colors.white,
              background: Colors.grey[900]!,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Current Time (Static)',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          ClockWidget.static(
            staticTime: DateTime.now(),
            clockSize: 12.0,
            twelveHourFormat: true,
          ),
        ],
      ),
    );
  }
}
