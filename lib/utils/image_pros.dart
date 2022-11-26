//import 'dart:convert';
//import 'package:flutter/services.dart';
//import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:store_manager/utils/utils.dart';
import 'dart:io';
//import 'dart:async';

/*Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}

Uint8List dataFromBase64String(String base64String) {
  return base64Decode(base64String);
}

String base64String(Uint8List data) {
  return base64Encode(data);
}

final String tag = "ImagePres";
pickImageFromGallery() {
 // Log(tag: tag, message: "Start pickImageFromGallery function");
  ImagePicker().pickImage(source: ImageSource.gallery).then((imgFile) async {
    return base64String(await imgFile!.readAsBytes());
  });
}

Future pickImage() async {
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemp = File(image.path);
  } on PlatformException catch (e) {
    print('Failed to pick image: $e');
  }
}*/

File? imageFil;
String? imageURL;

void setImage() async {
  //var image = await ImagePicker().getImage(source: ImageSource.gallery);
  var image = await ImagePicker().getImage(source: ImageSource.gallery);

  /*widget.imageFileChange(File(image!.path));
    setState(() {
      imageFil = File(image.path);
      print("image added");
      print("imageFil is null? " + (imageFil == null).toString());
    });*/
}
