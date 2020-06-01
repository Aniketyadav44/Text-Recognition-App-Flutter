import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Text Recognizer",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File image;
  String text = "";
  bool loading = false;

  pickImage() async {
    var pickedImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      loading = true;
      image = pickedImage;
      text="";
    });
  }

  clickImage() async {
    var pickedImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      loading = true;
      image = pickedImage;
      text="";
    });
  }

  showText() async {
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
    TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();
    VisionText finalText = await recognizer.processImage(visionImage);
    for (TextBlock block in finalText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          setState(() {
            text = text + word.text + " ";
          });
        }
        text=text+"\n";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text("Text Recognizer!")),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: h * 0.05),
              GestureDetector(
                onTap: () {
                  pickImage();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 160,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Choose Image",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      Icon(
                        Icons.image,
                        color: Colors.black,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: h * 0.05),
              GestureDetector(
                onTap: () {
                  clickImage();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 140,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Click Image",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: h * 0.05),
              loading
                  ? Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      height: 400,
                      width: double.infinity,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(image, fit: BoxFit.cover)),
                    )
                  : Container(
                      height: 400,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          "Select Image",
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
              SizedBox(height: h * 0.05),
              GestureDetector(
                onTap: () {
                  showText();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 120,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Read Text",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      Icon(
                        Icons.image,
                        color: Colors.black,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: h * 0.05),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Text(
                  text,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
