import 'package:flutter/material.dart';
import 'package:expandable_bottom_navbar/expandable_bottom_navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<IconData> _icons = [
    Icons.home,
    Icons.search,
    Icons.add_circle,
    Icons.notifications,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demos'),
      ),
      body: Center(
        child: Text('Selected index: $_selectedIndex'),
      ),
      bottomNavigationBar: ExpandableBottomNavBar(
        icons: _icons,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            debugPrint('Selected index: $index');
          });
        },
        mainButtonColor: Colors.lightGreen,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.lightGreen,
        unselectedItemColor: Colors.grey,
        height: 50,
        buttonSize: 50,
      ),
    );
  }
}
