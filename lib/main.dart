import 'package:binary_counter/binary_counter.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as Ui;
import 'widgets.dart';
import 'variables.dart';
import 'functions.dart';
import 'package:quick_share/quick_share.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: imageGenerator(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: QuickShareScreenshot(
                      shareButton: const ShareButton(), 
                      buttonPlacement: ButtonPlacement.top,
                      child: CustomPaint(
                        size: Size(
                          imageWidth,
                          imageHeight,
                        ),
                        painter: MyPainter(
                          pixels: snapshot.data as Ui.Image,
                        ),
                      ),
                    ),
                  ),
                  FramesController(
                    reload: (){
                      setState(() {
                        
                      });
                    },
                  ),
                ],
              );
            }else{
              return const LoadingThingy();
            }
          },
        ),
      ),
    );
  }
}

class FramesController extends StatelessWidget {
  const FramesController({
    Key? key,
    required this.reload,
  }) : super(key: key);
  final Function reload;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularButton(
            onPressed: (){
              try{
                String binaryImage = loadBinaryImage();
                binaryImage = binarySubtraction(
                  binaryNumber: binaryImage, 
                  binaryAmountToSubtract: framesToSkip,
                );
                saveBinaryImage(binaryImage);
                reload();
              }catch(error){
                //Clip value to 0
                String storedImage = "";
                int totalAmountOfPixels = imageHeight.toInt() * imageWidth.toInt() * 3 * 8;
                for(int i = 0; i < totalAmountOfPixels; i++){
                  storedImage = "0$storedImage";
                }
                saveBinaryImage(storedImage);
              }
            },
            icon: Icons.skip_previous,
          ),
          CircularButton(
            onPressed: (){
              try{
                String binaryImage = loadBinaryImage();
                binaryImage = binarySubtraction(
                  binaryNumber: binaryImage, 
                  binaryAmountToSubtract: "01",
                );
                saveBinaryImage(binaryImage);
                reload();
              }catch(error){
                //Clip value to 0
                String storedImage = "";
                int totalAmountOfPixels = imageHeight.toInt() * imageWidth.toInt() * 3 * 8;
                for(int i = 0; i < totalAmountOfPixels; i++){
                  storedImage = "0$storedImage";
                }
                saveBinaryImage(storedImage);
              }
            },
            icon: Icons.arrow_left,
          ),
          CircularButton(
            onPressed: (){
              try{
                String binaryImage = loadBinaryImage();
                binaryImage = binaryAddition(
                  binaryNumber1: binaryImage, 
                  binaryNumber2: "01",
                );
                if(binaryImage.length > (imageWidth * imageHeight * 3 * 8)){
                  saveBinaryImage(binaryImage);
                  reload();
                }else{
                  throw "";
                }
              }catch(err){
                //Clip value to 0
                String storedImage = "";
                int totalAmountOfPixels = imageHeight.toInt() * imageWidth.toInt() * 3 * 8;
                for(int i = 0; i < totalAmountOfPixels; i++){
                  storedImage = "1$storedImage";
                }
                saveBinaryImage(storedImage);
              }
            },
            icon: Icons.arrow_right,
          ),
          CircularButton(
            onPressed: (){
              try{
                String binaryImage = loadBinaryImage();
                binaryImage = binaryAddition(
                  binaryNumber1: binaryImage, 
                  binaryNumber2: framesToSkip,
                );
                if(binaryImage.length > (imageWidth * imageHeight * 3 * 8)){
                  saveBinaryImage(binaryImage);
                  reload();
                }else{
                  throw "";
                }
              }catch(err){
                //Clip value to 0
                String storedImage = "";
                int totalAmountOfPixels = imageHeight.toInt() * imageWidth.toInt() * 3 * 8;
                for(int i = 0; i < totalAmountOfPixels; i++){
                  storedImage = "1$storedImage";
                }
                saveBinaryImage(storedImage);
              }
            },
            icon: Icons.skip_next,
          ),
        ],
      ),
    );
  }
}
class MyPainter extends CustomPainter{
  MyPainter({
    required this.pixels,
  });
  final Ui.Image pixels;
  @override
  void paint(Ui.Canvas canvas, Ui.Size size){
    canvas.drawImage(pixels, const Offset(0,0), Paint());
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return false;
  }
}
/*Multithreading throws error
Future<Ui.Image> generateRandomImage()async{
  return await compute(imageGenerator,"Nothing");
}*/