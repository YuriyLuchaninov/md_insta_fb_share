import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:md_insta_fb_share/md_insta_fb_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
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
                  const fileName = 'insta_big.png';
                  final file = await File('$dir/$fileName').writeAsBytes(
                      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

                  final stickerData = await rootBundle.load('assets/insta_small.png');
                  final stickerBuffer = data.buffer;
                  const stickerFileName = 'insta_small.png';
                  final stickerFile = await File('$dir/$stickerFileName').writeAsBytes(
                      stickerBuffer.asUint8List(stickerData.offsetInBytes, stickerData.lengthInBytes));

                  MdInstaFbShare.shareInsta(
                    file.path,
                    stickerImage: stickerFile.path,
                    backgroundTopColor: '#FF0000', // red
                    backgroundBottomColor: '#2DFF00', // green
                    contentURL: 'http://google.com'
                  );
                },
                child: const Text('Test insta share')
              ),
              Image.asset('assets/insta_big.png', width: 150, fit: BoxFit.fitWidth)
            ],
          )
        ),
      ),
    );
  }
}
