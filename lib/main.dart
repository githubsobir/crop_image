import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImageCropper',
      theme: ThemeData.light().copyWith(primaryColor: Colors.deepOrange),
      home: MyHomePage(
        title: 'ImageCropper',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _MyHomePageState extends State<MyHomePage> {
  AppState state;
  File imageFile;

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: imageFile != null ? Image.file(imageFile) : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          if (state == AppState.free)
            _pickImage();
          else if (state == AppState.picked)
            _cropImage();
          else if (state == AppState.cropped) _clearImage();
        },
        child: _buildButtonIcon(),
      ),
    );
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free)
      return Icon(Icons.add);
    else if (state == AppState.picked)
      return Icon(Icons.crop);
    else if (state == AppState.cropped)
      return Icon(Icons.clear);
    else
      return Container();
  }

  Future<Null> _pickImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    imageFile = pickedImage != null ? File(pickedImage.path) : null;
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
      print("1");
      print(imageFile.readAsBytes());
    }
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _clearImage() {
    setState(() {
      /// imagefile to base64
      // final bytes =imageFile.readAsBytesSync();
      // String img64 = base64Encode(bytes);

      final bytes = imageFile.readAsBytesSync().lengthInBytes;
      final kb = bytes / 1024;
      print("KB " + kb.toString());
      final mb = kb / 1024;
      print("=======");
      print("MB " + mb.toString());
      if (kb >= 2) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Qayta uruning ${"MB " + mb.toString()}")));
      }
      else{
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${"MB " + mb.toString()}")));
      }
      print("=======");
      // final size = ImageSizeGetter.getSize(FileInput(imageFile));
      // print('jpg = $size');
      print("-------");
      // print(bytes);
      print("-------");
      // print(img64);
      print("-------");
    });
    // print(imageFile.readAsBytes());

    //
    // setState(() {
    //   state = AppState.free;
    // });
  }
}
