import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inofa/api/api.dart';
import 'package:inofa/chat/group_detail.dart';
import 'package:inofa/invite/inviteProfile.dart';
import 'package:inofa/models/inovasi_models.dart';
import 'package:inofa/models/listUser_models.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

const double CAMERA_ZOOM = 15;
const LatLng SOURCE_LOCATION = LatLng(42.747932,-71.167889);
const LatLng DEST_LOCATION = LatLng(37.335685,-122.0605916);

const String ANOTHER_USER = "37.335685,-122.0605916";


class MapsUser extends StatefulWidget {
  final ListInovasi inovasis;
  MapsUser ({Key key, this.inovasis}) : super (key : key);
  _MapsUserState createState() => _MapsUserState();
}


class _MapsUserState extends State<MapsUser> {
  Completer<GoogleMapController> _controller = Completer();

  LocationData currentLocation;
  Location location;
  var loading = false;
  int userId=1;

  List <ListUser> _listUserModels = [];
  Future<String> _getListUser()async{
    setState(() {
      loading=true;
    });
    var response = await http.get(Uri.encodeFull(BaseUrl.listPengguna), headers: {"Accept": "application/json"});
    var data = json.decode(response.body);

    setState(() {
      for(Map i in data){
        _listUserModels.add(ListUser.fromJson(i));
      }
      loading=false;
      print(data);
    });
  }

  @override
  void initState(){
    super.initState();
    _getListUser();
    location = new Location();

    location.onLocationChanged().listen((LocationData cLoc) {
      currentLocation = cLoc;
      updatePinOnMap();
    });

    setInitialLocation();
    _marker();
  }

  void setInitialLocation() async {
    currentLocation = await location.getLocation();
  }



  void updatePinOnMap() async {
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition)
    );
  }

  List<Marker> _marker(){
    List<Marker> datas = [];
    for(var i=0; i<_listUserModels.length; i++){
      datas.add(Marker(
        markerId: MarkerId(_listUserModels[i].id_pendidikan.toString()),
        draggable: false,
        onTap: (){
          _onMarkerPressed(dateilUser :_listUserModels[i]);
        },
        icon: BitmapDescriptor.fromAsset('images/Pin.png'),
        position: LatLng(_listUserModels[i].latitude, _listUserModels[i].longitude)
      ));
    }
    return datas;
  }
 

  @override
  Widget build(BuildContext context) {

    CameraPosition initialCameraPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      target: SOURCE_LOCATION);

      if (currentLocation != null) {
        initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
        );
      }

    return Scaffold(
      backgroundColor: Colors.white,
        body: loading?
        Center(
          child: CircularProgressIndicator(),
        ):
        Stack(
          children: <Widget>[
            GoogleMap(
              myLocationEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: Set.from(_marker()),
            ),
            Container(
              padding: EdgeInsets.only(top: 40, left: 24),
              child: Container(
                width: 40.0,
                child: MaterialButton(
                  color: Colors.white,
                  height: 40.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)
                  ),
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(builder: (context)=>DetailGroup(inovasis: widget.inovasis),),
                    );
                  },
                  child: Image.asset('images/Back.png', height: 40,
                  color: Color(0xff000000)),
                ),
              ),
            ),
          ],
        ),
    );
  }

  void _onMarkerPressed({ListUser dateilUser}){
    showModalBottomSheet(
      context: context, 
      builder: (context){
        return Container(
          color: Color(0xff737373),
          height: 120,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
              )
            ),
            child: Container(
              padding: EdgeInsets.only(left: 24, right: 24),
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => InviteProfile(
                    inovasis: widget.inovasis, dataUser: dateilUser)));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Material(
                          child: Image.asset(
                              'images/dev.jpg',
                              width: 65.0,
                              height: 65.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(70.0)),
                            clipBehavior: Clip.hardEdge,
                        ),
                        SizedBox(width: 15,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(dateilUser.display_name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                            SizedBox(height: 3),
                            Text(dateilUser.email, style: TextStyle(fontSize: 16),)
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

}