import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({Key? key}) : super(key: key);

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> with TickerProviderStateMixin{
  TextEditingController _statusController = TextEditingController();
  final double _textSize = 800;
  final double _baseFactor = 0.5;
  double _scaleFactor = 0.5;
  final _fontList = [
    'First',
    'Second',
    'Third',
    'Fourth',
    'Fifth',
    'Sixth',
    'Seventh',
    'Eighth',
    'Ninth'
  ];

  final _screenColorList = [
    Colors.lightGreen,
    Colors.white,
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.amber,
    Colors.cyan
  ];
  final _textColorList = [
    Colors.white,
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.amber,
    Colors.cyan
  ];

  int _currentFont = 0;
  int _currentScreenColor = 0;
  int _currentTextColor = 0;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BottomSheet.createAnimationController(this);

    // Animation duration for displaying the BottomSheet
    _controller.duration = const Duration(milliseconds: 500);

    // Animation duration for retracting the BottomSheet
    _controller.reverseDuration = const Duration(milliseconds: 500);
    // Set animation curve duration for the BottomSheet
    _controller.drive(CurveTween(curve: Curves.bounceInOut));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _currentFont++;
                    if (_currentFont == _fontList.length) {
                      _currentFont = 0;
                    }
                  });
                },
                icon: Icon(
                  Icons.font_download_sharp,
                  color: Colors.white,
                  size: 32,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    _currentScreenColor++;
                    if (_currentScreenColor == _screenColorList.length) {
                      _currentScreenColor = 0;
                    }
                  });
                },
                icon: Icon(
                  Icons.color_lens_sharp,
                  color: Colors.white,
                  size: 32,
                )),
            IconButton(
                onPressed: () {
                  setState(() {
                    _currentTextColor++;
                    if (_currentTextColor == _textColorList.length) {
                      _currentTextColor = 0;
                    }
                  });
                },
                icon: Icon(
                  Icons.format_color_fill,
                  color: Colors.white,
                  size: 32,
                )),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.close,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        body: GestureDetector(
          onScaleUpdate: (details) {
            setState(() {
              _scaleFactor = _baseFactor * details.scale;
            });
          },
          child: Container(
            color: _screenColorList[_currentScreenColor],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: AutoSizeTextField(
                  controller: _statusController,
                  textCapitalization: TextCapitalization.sentences,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minFontSize: 18,
                  style: TextStyle(
                      color: _textColorList[_currentTextColor],
                      fontSize: _textSize * (_scaleFactor * 0.1),
                      fontFamily: _fontList[_currentFont]),
                  decoration: InputDecoration(
                      hintText: 'Type a status',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          color: _textColorList[_currentTextColor],
                          fontFamily: _fontList[_currentFont])),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showPostingOptions();
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          splashColor: Colors.transparent,
          label: Text('Send to'),
          icon: Icon(Icons.chevron_right),
        ),
      ),
    );
  }

  void _showPostingOptions() {
    showModalBottomSheet(
        context: context,
        transitionAnimationController: _controller,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FadedSlideAnimation(
              beginOffset: Offset(0, 0.3),
              endOffset: Offset(0, 0),
              slideCurve: Curves.linearToEaseOut,
              child: Wrap(
                children:  [
                    SizedBox(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Create story',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                fontSize: 16
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Create post',
                              style: TextStyle(color: Colors.black, fontSize: 16),
                            )),
                      ),
                    )
                  ],

              ),
            ),
          );
        });
  }
}
