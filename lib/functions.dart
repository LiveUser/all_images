import 'package:flutter/foundation.dart';
import 'package:raw_settings/raw_settings.dart';
import 'variables.dart';
import 'dart:ui' as Ui;
import 'dart:typed_data';
import 'dart:math';
import 'dart:async';
import 'package:number_system/number_system.dart';

RawSettings settings = RawSettings("raw_ware_all_images");
//TODO: Save binary image
void saveBinaryImage(String binaryImage){
  settings.set(name: "binary_image", value: binaryImage);
}
//TODO: Load binary image
String loadBinaryImage(){
  String? storedImage = settings.get(name: "binary_image");
  if(storedImage != null){
    return storedImage;
  }else{
    //*3 because it is rgb *8 because it is 8 bit
    int totalAmountOfPixels = imageHeight.toInt() * imageWidth.toInt() * 3 * 8;
    storedImage = "";
    for(int i = 0; i < totalAmountOfPixels; i++){
      storedImage = "0$storedImage";
    }
    return storedImage!;
  }
}
Future<List<int>> loadAndParseImage(String nothing)async{
  List<int> rgba = [];
  //Load binary image 
  String binaryImage = loadBinaryImage();
  //TODO: Split for each 8 bits and translate each 8 bits into decimal number
  for(int i = 0; i < (imageHeight * imageWidth * 3 * 8); i += 24){
    String red = binaryImage.substring(i,i + 8);
    String green = binaryImage.substring(i + 8, i + 16);
    String blue = binaryImage.substring(i + 16, i + 24);
    int r = red.binaryToDec();
    int g = green.binaryToDec();
    int b = blue.binaryToDec();
    rgba.add(r);
    rgba.add(g);
    rgba.add(b);
    rgba.add(255);
  }
  return rgba;
}
//https://stackoverflow.com/questions/70669421/how-to-convert-rgb-pixmap-to-ui-image-in-dart
Future<Ui.Image> imageGenerator()async{
  List<int> rgba = await compute(loadAndParseImage,"");
  //Block the process until it is finished
  Completer<Ui.Image> blocker = Completer();
  Ui.decodeImageFromPixels(Uint8List.fromList(rgba), imageWidth.toInt(), imageHeight.toInt(), Ui.PixelFormat.rgba8888, (result) {
    blocker.complete(result);
  });
  return await blocker.future;
}