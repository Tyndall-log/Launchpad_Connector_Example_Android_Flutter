import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launchpad/test.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  //static const platform = MethodChannel('com.thinkabout.nativenaver/android');
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UNIQ Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Launchpad Connector Flutter Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var _console_text = "";
  var lib = NativeLib();

  late Timer _timer;
  final ScrollController _scrollController = ScrollController();
  var _scrollTargetPos = 0.0;
  var _scrollAnimateCount = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      var isab = isScrollAtBottom(_scrollController);
      var text = lib.getLog();
      if (text == "") return;
      setState(() { _console_text += text; });
      if (isab) _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    ++_scrollAnimateCount;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollTargetPos = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeOut,
      ).then((_) {
        --_scrollAnimateCount;
        //print("Scroll animation completed");
      });
    });
  }

  bool isScrollAtBottom(ScrollController controller) {
    if (0 < _scrollAnimateCount) return true;
    return controller.position.atEdge
        && controller.position.pixels >= controller.position.maxScrollExtent;
  }

  @override
  void dispose() {
    // 앱 종료 시 타이머 해제
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      lib.test();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Align(
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      _console_text,
                        textAlign: TextAlign.left
                    ),
                  ),
                 ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
