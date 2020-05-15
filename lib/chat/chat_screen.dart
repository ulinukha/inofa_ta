import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:inofa/chat/group_detail.dart';
import 'package:inofa/models/inovasi_models.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:inofa/custom/appBar.dart';

class ChatScreen extends StatefulWidget {
  final ListInovasi inovasis;
ChatScreen({Key key, this.inovasis}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  SocketIO socketIO;
  List<String> messages;
  TextEditingController textController;
  ScrollController scrollController;

  void initState() {
    //Initializing the message list
    messages = List<String>();
    //Initializing the TextEditingController and ScrollController
    textController = TextEditingController();
    scrollController = ScrollController();
    //Creating the socket
    socketIO = SocketIOManager().createSocketIO(
      'https://cobachat.herokuapp.com/',
      '/',
    );
    //Call init before doing anything with socket
    socketIO.init();
    //Subscribe to an event to listen to
    socketIO.subscribe('receive_message', (jsonData) {
      //Convert the JSON data received into a Map
      Map<String, dynamic> data = json.decode(jsonData);
      this.setState(() => messages.add(data['message']));
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    });
    //Connect to the socket
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
          title: Text(widget.inovasis.judul, 
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
        onTap: () {
          Navigator.push(
            context, MaterialPageRoute(builder: (context)=>DetailGroup(inovasis: widget.inovasis),
            ),
          );
        },
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            _onChat(),
            _inputChatMessage(),
          ],
        ),
      ),
    );
  }

  _chat(){
    return Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 24, right:24),
        child: ListView.builder(
          reverse: true,
          shrinkWrap: true,
          primary: false,
          itemCount: 15,
          itemBuilder: (context, i){
            return Container(
              width: 250,
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    
                    padding: EdgeInsets.all(10),
                    decoration: new BoxDecoration(
                      color: Colors.black12,
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(8)
                      )
                    ),
                    child: new Center(
                      child: new Text(
                        "Ekonomi", 
                        style: TextStyle(
                          fontSize: 13.0, color: Colors.black
                        ),
                      ),
                    )
                  ),
                ],
              )
            );
          },
        ),
      ),
    );
  }

  _onChat(){
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 24, right:24, bottom: 15),
        child: ListView.builder(
          reverse: true,
          shrinkWrap: true,
          primary: false,
          controller: scrollController,
          itemCount: messages.length,
          itemBuilder: (context, i){
            return Container(
              width: 250,
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    
                    padding: EdgeInsets.all(10),
                    decoration: new BoxDecoration(
                      color: Colors.black12,
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(8)
                      )
                    ),
                    child: new Center(
                      child: new Text(
                        messages[i], 
                        style: TextStyle(
                          fontSize: 13.0, color: Colors.black
                        ),
                      ),
                    )
                  ),
                ],
              )
            );
          },
        ),
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
                            Image.asset('images/Send-Blue-2.png', width: 30,)
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
                            //Send the message as JSON data to send_message event
                            socketIO.sendMessage(
                                'send_message', json.encode({'message': textController.text}));
                            //Add the message to the list
                            this.setState(() => messages.add(textController.text));
                            textController.text = '';
                            //Scrolldown the list to show the latest message
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