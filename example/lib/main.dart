import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:md_insta_fb_share/md_insta_fb_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final dir = (await getTemporaryDirectory()).path;

                  final data = await rootBundle.load('assets/insta_big.png');
                  final buffer = data.buffer;
                  final fileName = 'insta_big-${DateTime.now().millisecondsSinceEpoch}.png';
                  final file = await File('$dir/$fileName').writeAsBytes(
                      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

                  MdInstaFbShare.shareInstaStory(file.path);
                },
                child: const Text('Test insta story share')
              ),
              ElevatedButton(
                  onPressed: () async {
                    final dir = (await getTemporaryDirectory()).path;

                    final data = await rootBundle.load('assets/insta_big.png');
                    final buffer = data.buffer;
                    final fileName =  'insta_big-${DateTime.now().millisecondsSinceEpoch}.png';
                    final file = await File('$dir/$fileName').writeAsBytes(
                        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

                    MdInstaFbShare.shareInstaFeed(file.path);
                  },
                  child: const Text('Test insta feed share')
              ),
              ElevatedButton(
                  onPressed: () async {
                    final dir = (await getTemporaryDirectory()).path;

                    final data = await rootBundle.load('assets/insta_big.png');
                    final buffer = data.buffer;
                    final fileName = 'insta_big-${DateTime.now().millisecondsSinceEpoch}.png';
                    final file = await File('$dir/$fileName').writeAsBytes(
                        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
                    MdInstaFbShare.shareFBStory(file.path);
                  },
                  child: const Text('Test FB story share')
              ),
              ElevatedButton(
                  onPressed: () async {
                    final dir = (await getTemporaryDirectory()).path;

                    final data = await rootBundle.load('assets/insta_big.png');
                    final buffer = data.buffer;
                    final fileName = 'insta_big-${DateTime.now().millisecondsSinceEpoch}.png';
                    final file = await File('$dir/$fileName').writeAsBytes(
                        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
                    MdInstaFbShare.shareFBFeed(file.path);
                  },
                  child: const Text('Test FB feed share')
              ),
              Image.asset('assets/insta_big.png', width: 150, fit: BoxFit.fitWidth),
              Row(
                children: [
                  const Text('FB App available: '),
                  FutureBuilder(
                    future: MdInstaFbShare.checkFBInstalled(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return Text('${snapshot.data}');
                      }
                      return Container();
                    },
                  )
                ],
              ),
              Row(
                children: [
                  const Text('Insta App available: '),
                  FutureBuilder(
                    future: MdInstaFbShare.checkInstaInstalled(),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        return Text('${snapshot.data}');
                      }
                      return Container();
                    },
                  )
                ],
              )
            ],
          )
        ),
      ),
    );
  }
}
