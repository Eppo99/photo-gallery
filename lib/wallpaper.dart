import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:photo_gallery/photo-item.dart';
class PhotoScreen extends StatefulWidget {
  const PhotoScreen({Key? key}) : super(key: key);

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  @override
  void initState() {
    // TODO: implement initState
    getApiData();
    _controller.addListener(() {
      if(_controller.position.maxScrollExtent==_controller.offset){
        getApiData();
      }
    });
    super.initState();
  }
  List urlData =[];
  int page = 1;
  final ScrollController _controller = ScrollController();
  dynamic photo;
  getApiData()async{
    var url = Uri.parse("https://api.unsplash.com/photos/?page=$page&per_page=20&client_id=-KHpJLAhb1G5ts_VmquitLQj24Zl2RJwfyeg1Rsdhms");
    final response = await http.get(url);
    final data =  jsonDecode(response.body);
    print(response.statusCode);
    urlData.addAll(data);
    getImageBytes();
    setState(() {
      page++;
    });
  }
  getImageBytes ()async{
    for(int i=0;i<20;i++) {
      photo = urlData[urlData.length-20+i]['urls']['small'];
      Uint8List bytes = (await NetworkAssetBundle(Uri.parse(photo)).load(photo))
          .buffer
          .asUint8List();
      Hive.openBox('wall');
      await Hive.box('wall').put('$i-photo', bytes);
      setState(() {
      });
    }
  }
  getStoragePic(index) {
    Hive.openBox('wall');
    // print(Hive.box('wall').get('$index-photo'));
    if(Hive.box('wall').get('$index-photo') != null) {
      return Image.memory(Hive.box('wall').get('$index-photo'));
    } else {
      return const CircularProgressIndicator();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: urlData.isEmpty?
        SizedBox(
          child: GridView.builder(itemCount:20,
              controller: _controller,
              scrollDirection:Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(mainAxisSpacing: 0,crossAxisCount: 3,crossAxisSpacing: 0,),
              itemBuilder: (context,i){
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return StoreImageScreen(id: getStoragePic(i),);
                    }));
                  },
                  child: getStoragePic(i),
                );
              }),
        ):
        SizedBox(
              child: Center(
                child: urlData.isEmpty ?
                const CircularProgressIndicator() :
                GridView.builder(itemCount:urlData.length+1,
                    controller: _controller,
                    scrollDirection:Axis.vertical,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(mainAxisSpacing: 0,crossAxisCount: 3,crossAxisSpacing: 0,),
                    itemBuilder: (context,i){
                  if(i<urlData.length) {
                    return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return ImageScreen(id: urlData[i]['urls']['small'],);
                      }));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(urlData[i]['urls']['small'])),
                      ),
                    ),
                  );
                  }
                  else {
                    return const CircularProgressIndicator();
                  }
                    }),
              ),
            ),
      ),
    );
  }
}


