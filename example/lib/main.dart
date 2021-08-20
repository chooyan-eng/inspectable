import 'package:flutter/material.dart';

import 'package:inspectable/inspectable.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inspectable Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Inspectable(
        child: MyHomePage(),
        colors: {
          Text: Colors.blue,
          Stack: Colors.teal,
          TextButton: Colors.brown,
          Material: Colors.red,
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inspectable Sample'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 60),
            Inspectable(
              child: InspectButton(),
              verbose: true,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class InspectButton extends StatelessWidget {
  const InspectButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Inspectable.of(context).inspect();
      },
      child: Text(
        'INSPECT',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
