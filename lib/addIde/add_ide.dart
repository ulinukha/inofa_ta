import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:inofa/api/api.dart';
import 'package:inofa/models/kategori_model.dart';
import 'package:inofa/models/loginUser_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;


class AddIde extends StatefulWidget{
  final LoginUser userData;
  AddIde({Key key, this.userData}) : super(key: key);
  _AddIdeState createState() => _AddIdeState();
}

class _AddIdeState extends State<AddIde>{
  String judul, tagline, kategori_id, description, idUsers;
  final _key = new GlobalKey<FormState>();
  File _thumbnail;
  List <ListKategori> _listKategori = [];
  var loading = false;
  static String tokenUser ='';

  Future<String> _getListKategori()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    setState(() {
      loading=true;
    });
    var response = await http.get(Uri.encodeFull(BaseUrl.listKategori), 
    headers: {
      'Authorization': 'Bearer '+ token,
    });
    var data = json.decode(response.body);

    setState(() {
      for(Map i in data){
        _listKategori.add(ListKategori.fromJson(i));
        loading=false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getListKategori();
    setState(() {
      tokenUser = widget.userData.user.token;
      headers = {'Authorization': 'Bearer '+tokenUser};
    });
  }  

  _pilihGallery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _thumbnail = image;
    });
  }

  _pilihKamera() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1920.0,
      maxWidth: 1080.0,
    );
    setState(() {
      _thumbnail = image;
    });
  }

  check(){
    final form = _key.currentState;
    if(form.validate()){
      form.save();
      submit();
    }
  }

  Map<String, String> headers;

  submit() async{
    try {
      var stream = http.ByteStream(DelegatingStream.typed(_thumbnail.openRead()));
      var length = await _thumbnail.length();
      var url = Uri.parse(BaseUrl.createInovasi);
      var request = http.MultipartRequest("POST", url);
      request.headers.addAll(headers);
      request.fields['pengguna_id']=widget.userData.user.id_pengguna.toString();
      request.fields['judul']=judul;
      request.fields['tagline']=tagline;
      request.fields['kategori_id']=kategori_id;
      request.fields['description']=description;


      request.files.add(http.MultipartFile("thumbnail", stream, length,
      filename: path.basename(_thumbnail.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("image upload");
        setState(() {
          Navigator.pushReplacementNamed(context, '/CurrentTab');
        });
      } else {
        print("image failed");
      }
    } catch(e){
      debugPrint("Error $e");
    }
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 4,
        title: Text('Ide', style: TextStyle(
          color: Colors.black,
          ),
        ),
      ),

      body: loading? 
      Center(
        child: CircularProgressIndicator(),
      ):
      Form(
        key: _key,
            child: ListView(
              padding: EdgeInsets.all(24.0),
              children: <Widget>[
                // Row(
                //   children: <Widget>[
                //   Container(
                //     width: 240,
                //     child: TextFormField(
                //       controller: titleController,
                //       decoration: InputDecoration(labelText: 'Title'),
                //     ),
                //   )
                //   ],
                // ),
                TextFormField(
                  onSaved: (e)=>judul=e,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                SizedBox(height:15.0),
                // Container(
                //   width: double.infinity,
                //   height: 150.0,
                //   child: InkWell(
                //     onTap: () {
                //       _pilihGallery();
                //     },
                //     child: _imageFile == null
                //         ? placeholder
                //         : Image.file(
                //             _imageFile,
                //             fit: BoxFit.fill,
                //           ),
                //   ),
                // ),
                TextFormField(
                  onSaved: (e)=>tagline=e,
                  decoration: InputDecoration(labelText: 'Tagline'),
                ),
                SizedBox(height:15),
                Container(
                  child: DropdownButton(
                    isExpanded: true,
                    items: _listKategori.map((kategoris){
                      return new DropdownMenuItem(
                        child: new Text(kategoris.kategori),
                        value: kategoris.id_kategori.toString(),
                      );
                    }).toList(),
                    onChanged: (newVal){
                      setState(() {
                        kategori_id = newVal;
                        print(kategori_id);
                      });
                    },
                    hint: Text('Kategori'),
                    value: kategori_id,
                  ),
                ),
                
                TextFormField(
                  maxLines: 8,
                  onSaved: (e)=>description=e,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                SizedBox(height: 15),
                Container(
                  width: 300,
                  child: _thumbnail != null ?
                  Column(
                    children: <Widget>[
                      ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                          _thumbnail,
                          width: 130.0,
                      ),
                     ),
                    ]
                  ): 
                  Column(
                  )
                )
              ],
            ),
        ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.white,
          shape: CircularNotchedRectangle(),
          notchMargin: 10,
          child: Container(
            margin: EdgeInsets.only(left:24, right:24),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MaterialButton(
                      minWidth: 50,
                      onPressed: () {
                        _pilihGallery();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('images/Galery-Blue.png', width: 30,)
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    MaterialButton(
                      minWidth: 50,
                      onPressed: () {
                        check();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('images/Send-Blue-2.png', width: 30,)
                        ],
                      ),
                    )
                  ],
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}




