import 'package:flutter/material.dart';
import 'package:roadtech_gallery/apps_custom_list.dart';
import 'package:roadtech_gallery/apps_installed_list.dart';

void main() => runApp(const RTGalleryApp());

class RTGalleryApp extends StatelessWidget {
  const RTGalleryApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RT Gallery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'My Apps Gallery'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<Object>(
                        builder: (BuildContext context) =>
                            const AppsRoadTech()),
                  );
                },
                child: const Text('Custom Apps')),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<Object>(
                        builder: (BuildContext context) =>
                            const AppsInstalledListScreen()),
                  );
                },
                child: const Text('Installed Apps')),
          ],
        ),
      ),
    );
  }
}
