import 'package:flutter/material.dart';
import 'package:inofa/notifikasi/requestJoinDetail.dart';
import 'package:inofa/notifikasi/requestInvite.dart';

class Notif extends StatefulWidget{
  Notif({Key key}) : super(key: key);
  _NotifState createState() => _NotifState();
}

class _NotifState extends State<Notif>{
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 4,
        title: Text('Notification', style: TextStyle(
          color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 24, right: 24, bottom: 19, top: 1),
        children: <Widget>[
          _requestJoin(context),
          _requestInvite(context),
        ],
      )
    );
  }
}

_requestJoin(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(bottom: 5),
    child: GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context)=>RequstJoin(),
            ),
          );
      },
      child: Container(
        width: 400,
        color: Colors.transparent,
        child: new Container(
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 3.0, //extend the shadow
              )
            ],
            borderRadius: new BorderRadius.all(Radius.circular(10))
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Material(
                    child: Image.asset(
                        'images/dev.jpg',
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      ),
                    borderRadius: BorderRadius.all(Radius.circular(45.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                      width: 245,
                      child: Column(
                        children: <Widget>[
                          new Text('Anggit ingin bergabung ke group anda',
                          style: TextStyle(fontSize: 12),)
                        ],
                      )
                  )
                ],
              )
            ]
          ),
        ),
      )
    ),
  );
}

_requestInvite(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(bottom: 5),
    child: GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context)=>RequestInvite(),
            ),
          );
        },
      child: Container(
        width: 400,
        color: Colors.transparent,
        child: new Container(
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 3.0, //extend the shadow
              )
            ],
            borderRadius: new BorderRadius.all(Radius.circular(10))
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Material(
                    child: Image.asset(
                        'images/dev.jpg',
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      ),
                    borderRadius: BorderRadius.all(Radius.circular(45.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                      width: 245,
                      child: Column(
                        children: <Widget>[
                          new Text('Anggit ingin mengundang anda untuk bergabung idenya',
                          style: TextStyle(fontSize: 12),)
                        ],
                      )
                  )
                ],
              )
            ]
          ),
        ),
      )
    ),
  );
}