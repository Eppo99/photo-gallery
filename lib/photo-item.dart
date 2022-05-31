

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({Key? key,required this.id}) : super(key: key);
  final id;
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      maxScale: 4,
      minScale: 1,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black,),
        body:Center(child: Image.network(id)),
      ),
    );
  }
}
class StoreImageScreen extends StatelessWidget {
  const StoreImageScreen({Key? key,required this.id}) : super(key: key);
  final Widget id;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      maxScale: 4,
      minScale: 1,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black,),
        body:Center(child: id),
      ),
    );
  }
}