import 'dart:async';
import 'package:flutter/material.dart';

class StopWatch extends StatefulWidget {
  @override
  State createState() => StopWatchState();

  final String name;
  final String email;

  // onst ({Key? key}) : super(key: key);
  const StopWatch({Key? key, required this.name, required this.email}) : super(key:
  key);
}

class StopWatchState extends State<StopWatch> {

  final itemHeight = 60.0;
  final scrollController = ScrollController();
  bool? isTicking = true;
  late Timer timer;
  final laps = [];
  int milliseconds = 0;

  @override
  void initState() {
    super.initState();
    // // timer = Timer.periodic(Duration(seconds: 1),
    // _onTick);
  }

  void _onTick(Timer time) {
    setState(() {
      milliseconds += 100;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),

      // body: _buildCounter(context),
      body: Column(
        children: [
          Expanded(child: _buildCounter(context)),
          Expanded(child: _buildLapDisplay()),
        ],
      ),
    );
  }

  Container _buildCounter(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Lap ${laps.length + 1}',
            style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.white),
          ),
          Text(_secondsText(milliseconds),
              style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.white)),
          SizedBox(height: 20),
          _buildControls()
        ],
      ),
    );
  }

  Row _buildControls() {
    return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           ElevatedButton(
             style: ButtonStyle(
               backgroundColor: MaterialStateProperty.all(Colors.green),
               foregroundColor: MaterialStateProperty.all(Colors.white),
             ),
             child: Text('Start'),
             onPressed: _startTimer,
           ),
            SizedBox(width: 20),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.yellow),
                ),
                onPressed: _lap,
                child: Text('Lap'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: Text('Stop'),
              onPressed: _stopTimer,
            ),
          ],
        );
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(milliseconds: 100),
    _onTick);

    setState(() {
      isTicking = true;
      laps.clear();
    });
  }

  void _stopTimer() {
    timer.cancel();
    setState(() {
      isTicking = false;
    });
  }

  String _secondsText(int milliseconds) {
    final seconds = milliseconds / 1000;
    return '$seconds seconds';
  }

  @override void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override void setState(VoidCallback fn) {
    super.setState(fn);
  }

  Widget _buildLapDisplay() {
    return Scrollbar(
      child: ListView.builder(
        controller: scrollController,
        itemExtent: itemHeight,
        itemCount: laps.length,
        itemBuilder: (context, index) {
          final milliseconds = laps[index];
          return ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 50),
            title: Text('Lap ${index + 1}'),
            trailing: Text(_secondsText(milliseconds)),
          );
        },
      ),
    );
  }

  void _lap() {
    setState(() {
        // laps.insert(0, milliseconds);
      laps.add(milliseconds);
        milliseconds = 0;
    });

    scrollController.animateTo(
        itemHeight * laps.length - 1,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInSine
    );
  }
}
