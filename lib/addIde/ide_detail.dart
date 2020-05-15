import 'package:flutter/material.dart';
import 'package:inofa/models/inovasi_models.dart';
import 'package:intl/intl.dart';

class IdeDetail extends StatefulWidget {
  final ListInovasi inovasis;
  IdeDetail ({Key key, this.inovasis }) : super (key: key);
  @override
  _IdeDetailState createState() => _IdeDetailState();
}

class _IdeDetailState extends State<IdeDetail> {

  final dateFormat = new DateFormat('dd-MM-yyyy');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0.0,
        title: Text(
          widget.inovasis.judul, 
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),

      body: Container(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        child: ListView(
          children: <Widget> [
            Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage('images/dev.jpg'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    widget.inovasis.pengguna_id.toString(),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black
                    ),),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    dateFormat.format(DateTime.parse(widget.inovasis.created_at)),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black
                    ),),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Container(
              child: Stack(
                children: <Widget>[
                  Material(
                    child: Image.asset(
                        'images/dev.jpg',
                        width: 400.0,
                        height: 150.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    )
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              child: Text(widget.inovasis.tagline, 
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              child: Text(widget.inovasis.description, 
                style: TextStyle(
                fontSize: 13.0,
                color: Colors.black
              ),),
            ),
            SizedBox(height: 20.0),
            Row(
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  child: new Container(
                    padding: EdgeInsets.all(7),
                    decoration: new BoxDecoration(
                      color: Color(0xff2968E2),
                      borderRadius: new BorderRadius.all(Radius.circular(5))
                    ),
                    child: new Center(
                      child: new Text(
                        widget.inovasis.kategori_id.toString(), 
                        style: TextStyle(
                          fontSize: 10.0, color: Colors.white
                        ),
                      ),
                    )
                  ),
                ),
              ],
            )
          ]
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
        child: Container(
          margin: EdgeInsets.only(left: 24, right: 24),
          child: RaisedButton(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(8.0),
              side: BorderSide(color: Color(0xff2968E2))),
            onPressed: () {},
            color: Color(0xff2968E2),
            textColor: Colors.white,
            child: Text("Gabung".toUpperCase(),
              style: TextStyle(fontSize: 15)),
          ),
        ),
      ),
    );
  }
}


