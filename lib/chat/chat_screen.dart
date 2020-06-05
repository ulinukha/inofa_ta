import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:inofa/chat/group_detail.dart';
import 'package:inofa/models/chat_models.dart';
import 'package:inofa/models/inovasi_models.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:inofa/custom/appBar.dart';
import 'package:inofa/models/loginUser_models.dart';
import 'package:http/http.dart' as http;
import 'package:inofa/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final ListInovasi inovasis;
ChatScreen({Key key, this.inovasis}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  SocketIO socketIO;
  List<String> messages;
  List<String> userNames;
  List<String> idUsers;
  List<String> profilePicture;
  TextEditingController textController;
  ScrollController scrollController;
  LoginUser _loginUser =  null;
  var loading = false;
  List <ListChat> _listChat = [];

  updateData()async{
    setState(() {
      loading = true;
    });
    _loginUser = await LoginUser.getDataUser();
    if(mounted) setState(() {
    });
    setState(() {
      _getListOltChat();
      loading = false;
    });
  }

  Future<void> _getListOltChat()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.getChat+
     widget.inovasis.id_inovasi.toString() != null?
     widget.inovasis.id_inovasi.toString() : widget.inovasis.inovasiId.toString(),
    headers: {
      'Authorization': 'Bearer '+ token,
    });
    final data = jsonDecode(response.body);
    setState(() {
      for(Map i in data){
        _listChat.add(ListChat.fromJson(i));
      }
    });
    loading = false;
  }

  postChat()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    final response = await http.post(BaseUrl.postChat+_loginUser.user.id_pengguna.toString(), 
    headers: {
      'Authorization': 'Bearer '+ _loginUser.user.token,
    },
    body: {
      "no_telp" : '',
    });
    Navigator.pushNamed(context, '/Otp');
  }

  void initState() {
    updateData();
    messages = List<String>();
    userNames = List<String>();
    idUsers = List<String>();
    profilePicture = List<String>();

    textController = TextEditingController();
    scrollController = ScrollController();
    socketIO = SocketIOManager().createSocketIO(
      'https://cobachat.herokuapp.com/',
      '/',
    );
    socketIO.init();
    socketIO.subscribe('receive_message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      this.setState(() => messages.add(data['content']));
      this.setState(() => userNames.add(data['display_name']));
      this.setState(() => idUsers.add(data['id_pengguna']));
      this.setState(() => profilePicture.add(data['profile_picture']));
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    });
    socketIO.connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        appBar: AppBar(
          iconTheme: IconThemeData(
                color: Colors.black,
              ),
          backgroundColor: Colors.white,
          elevation: 4.0,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  'http://192.168.20.102:8000/'+widget.inovasis.thumbnail
                ),
              ),
              SizedBox(width: 5,),
              Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  strutStyle: StrutStyle(fontSize: 12.0),
                  text: TextSpan(
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                      text: widget.inovasis.judul),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context, MaterialPageRoute(builder: (context)=>DetailGroup(inovasis: widget.inovasis, userData: _loginUser),
            ),
          );
        },
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
                child: Column(
                children: <Widget>[
                  _chat(),
                  _onChat(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: _inputChatMessage(),
      ),
    );
  }

  _chat(){
    return Container(
    padding: EdgeInsets.only(left: 24, right:24),
    child: ListView.builder(
    reverse: true,
    shrinkWrap: true,
    primary: false,
    itemCount: _listChat.length,
    itemBuilder: (context, i){
      return Container(
        width: 250,
        margin: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: _listChat[i].pengguna_id == -1? MainAxisAlignment.center :_listChat[i].pengguna_id ==_loginUser.user.id_pengguna? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            _listChat[i].pengguna_id == -1? SizedBox() : _listChat[i].pengguna_id ==_loginUser.user.id_pengguna?
            SizedBox() :
            Container(
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(_listChat[i].profile_picture),
              ),
            ),
            SizedBox(width: 8,),
            Container(
              padding: EdgeInsets.all(10),
              decoration: new BoxDecoration(
                color: Colors.black12,
                borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                  bottomLeft: _listChat[i].pengguna_id == -1? Radius.circular(8) : _listChat[i].pengguna_id == _loginUser.user.id_pengguna? Radius.circular(8) : Radius.circular(0),
                  bottomRight: _listChat[i].pengguna_id == -1? Radius.circular(8) : _listChat[i].pengguna_id == _loginUser.user.id_pengguna? Radius.circular(0) : Radius.circular(8),
                )
              ),
              child: Column(
              crossAxisAlignment: _listChat[i].pengguna_id==_loginUser.user.id_pengguna? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                _listChat[i].pengguna_id == -1?
                SizedBox():
                new Text(
                  _listChat[i].display_name,
                  style: TextStyle(
                    fontSize: 15.0, color: _listChat[i].pengguna_id == _loginUser.user.id_pengguna? Colors.yellow: Colors.blue,
                  ),
                ),
                new Text(
                  _listChat[i].content,
                  style: TextStyle(
                    fontSize: 13.0, color: _listChat[i].pengguna_id == _loginUser.user.id_pengguna? Colors.white: Colors.black,
                  ),
                ),
              ],
            ),
            ),
          ],
        )
      );
    },
        ),
      );
  }

  _onChat(){
    return Container(
      padding: EdgeInsets.only(left: 24, right:24, bottom: 15),
      child: ListView.builder(
        reverse: false,
        shrinkWrap: true,
        primary: false,
        controller: scrollController,
        itemCount: messages.length,
        itemBuilder: (context, i){
          return Container(
            width: 250,
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: idUsers[i]==_loginUser.user.id_pengguna.toString()? MainAxisAlignment.end : MainAxisAlignment.start,
              children: <Widget>[
                idUsers[i]==_loginUser.user.id_pengguna.toString()?
                SizedBox() :
                Container(
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(profilePicture[i]),
                  ),
                ),
                SizedBox(width: 8,),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: new BoxDecoration(
                    color: idUsers[i] == _loginUser.user.id_pengguna.toString()? Color(0xff2968E2) : Colors.black12,
                    borderRadius: new BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomLeft: idUsers[i] == _loginUser.user.id_pengguna.toString()? Radius.circular(8) : Radius.circular(0),
                      bottomRight: idUsers[i] == _loginUser.user.id_pengguna.toString()? Radius.circular(0) : Radius.circular(8),
                    )
                  ),
                  child: Column(
                    crossAxisAlignment: idUsers[i]==_loginUser.user.id_pengguna.toString()? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        userNames[i].toString(),
                        style: TextStyle(
                          fontSize: 15.0, color: idUsers[i] == _loginUser.user.id_pengguna.toString()? Colors.yellow: Colors.blue,
                        ),
                      ),
                      new Text(
                        messages[i].toString(),
                        style: TextStyle(
                          fontSize: 13.0, color: idUsers[i] == _loginUser.user.id_pengguna.toString()? Colors.white: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          );
        },
      ),
    );
  }

  _inputChatMessage() {
    return Container(
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
          notchMargin: 2,
          child: Container(
            margin: EdgeInsets.only(left:24, right:24),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Image.asset('images/Send-Blue-2.png', width: 30,)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 230,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 230,
                        height: 40,
                        child: TextFormField(
                          controller: textController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Ketik pesan disini', 
                            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18.0)),
                          )
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 30,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          if (textController.text.isNotEmpty) {
                            socketIO.sendMessage(
                                'send_message', json.encode({
                                  'content': textController.text,
                                  'display_name': _loginUser.user.display_name.toString(),
                                  'id_pengguna': _loginUser.user.id_pengguna.toString(),
                                  'profile_picture': _loginUser.user.id_pengguna.toString(),
                                }));
                            this.setState(() => messages.add(textController.text));
                            this.setState(() => idUsers.add(_loginUser.user.id_pengguna.toString()));
                            this.setState(() => userNames.add(_loginUser.user.display_name.toString()));
                            this.setState(() => profilePicture.add(_loginUser.user.profile_picture.toString()));
                            textController.text = '';
                            scrollController.animateTo(
                              scrollController.position.maxScrollExtent,
                              duration: Duration(milliseconds: 600),
                              curve: Curves.ease,
                            );
                          }
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
                ),
              ]
            ),
          ),
        ),
      );
  }

}