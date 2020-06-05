import 'dart:io';
import 'package:flutter/material.dart';

class OnBoarding extends StatefulWidget{
  OnBoarding({Key key}) : super(key: key);

  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding>{
  final int _totalPages = 3;
  final PageController _pageController = PageController(initialPage:0);
  int _currentPage = 0;

  Widget _buildPageIndicator(bool isCurrentPage){
    return AnimatedContainer(
      duration: Duration(milliseconds: 375),
      margin: EdgeInsets.symmetric(horizontal: 2),
      height: isCurrentPage? 10: 6,
      width: isCurrentPage? 10: 6,
      decoration: BoxDecoration(
        color: isCurrentPage? Colors.white : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        child: Container(
          child: PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              _currentPage = page;
              setState(() {});
            },
            children: <Widget>[
            _buildPageContent(
                  image: 'images/slider_1.png',
                  title: 'In hac habitasse platea dictumst.',
                  body:
                      'Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque.'),
              _buildPageContent(
                  image: 'images/slider_2.png',
                  title: 'In hac habitasse platea dictumst.',
                  body:
                      'Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque.'),
              _buildPageContent(
                  image: 'images/slider_3.png',
                  title: 'In hac habitasse platea dictumst.',
                  body:
                      'Donec facilisis tortor ut augue lacinia, at viverra est semper. Sed sapien metus, scelerisque nec pharetra id, tempor a tortor. Pellentesque non dignissim neque.')
            ],
          ),
        ),
      ),

      bottomSheet: _currentPage != 2
      ? Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // FlatButton(
            //   onPressed: () {
            //     _pageController.animateToPage(2, duration: Duration(milliseconds: 400), curve: Curves.linear);
            //           setState(() {});
            //   },
            //   splashColor: Colors.blue[50],
            //   child: Text(
            //     'Skip',
            //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            //     ),
            // ),

            Container(
                    child: Row(children: [
                      for (int i = 0; i < _totalPages; i++) i == _currentPage ? _buildPageIndicator(true) : _buildPageIndicator(false)
                    ]),
            ),

            FlatButton(
              onPressed: () {
                _pageController.animateToPage(_currentPage + 1, duration: Duration(milliseconds: 400), curve: Curves.linear);
                      setState(() {});
              },
              child: Text(
                'Next',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                ),
            ),
          ],
          ),
      )
      : InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/SignIn');
              },
              child: Container(
                height: Platform.isIOS ? 70 : 60,
                color: Colors.blue,
                alignment: Alignment.center,
                child: Text(
                  'GET STARTED NOW',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
    );
  }
Widget _buildPageContent({
    String image,
    String title,
    String body,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Image.asset(image),
          ),
          SizedBox(height: 40),
          Center(
            child: Text(
            title,
            style: TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w600),
          ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
            body,
            style: TextStyle(fontSize: 12, height: 1.5, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          ),
        ],
      ),
    );
  }
}