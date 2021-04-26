import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter_twitter_clone/ui/page/profile/profilePage.dart';

import 'dot_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_twitter_clone/model/user.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_twitter_clone/helper/utility.dart';
import 'package:flutter_twitter_clone/widgets/customWidgets.dart';

class ScanScreen extends StatefulWidget {
  final UserModel user;

  const ScanScreen({Key key, this.user}) : super(key: key);
  static MaterialPageRoute getRoute(UserModel user) {
    return new MaterialPageRoute(
        builder: (BuildContext context) => ScanScreen(user: user));
  }

  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreen> with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey();
  PageController pageController;
  double pageIndex = 0;
  Barcode result;
  bool isFound = false;
  QRViewController controller;
  GlobalKey globalKey = new GlobalKey();
  @override
  void initState() {
    super.initState();
    pageController = PageController()..addListener(pageListener);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  void pageListener() {
    setState(() {
      pageIndex = pageController.page;
    });
  }

  _capturePng() async {
    try {
      // isLoading.value = true;
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var path = await _localPath + "/${DateTime.now().toIso8601String()}.png";
      await writeToFile(byteData, path);

      Utility.shareFile([path], text: "");
      // isLoading.value = false;
    } catch (e) {
      print(e);
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: pageController,
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  // return QrCode(
                  //   user: widget.user,
                  //   globalKey: globalKey,
                  // );
                  return QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                        borderRadius: 40,
                        borderColor: Theme.of(context).colorScheme.onPrimary,
                        borderWidth: 10,
                        borderLength: MediaQuery.of(context).size.width * .5),
                  );
                } else {
                  return QrCode(user: widget.user, globalKey: globalKey);
                }
              },
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(color: Theme.of(context).colorScheme.onPrimary),
                  AnimatedContainer(
                    duration: Duration(microseconds: 200),
                    child: pageIndex == 0
                        ? SizedBox.shrink()
                        : IconButton(
                            onPressed: () async {
                              if (pageIndex == 1) {
                                _capturePng();
                              }
                            },
                            icon: Icon(
                              Icons.share_outlined,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            _controls()
          ],
        ),
      ),
    );
  }

  Widget _controls() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 50,
        child: DotsIndicator(
          controller: pageController,
          color: Theme.of(context).colorScheme.onPrimary,
          itemCount: 2,
          onPageSelected: (int page) {
            pageController.animateToPage(
              page,
              duration: Duration(milliseconds: 750),
              curve: Curves.ease,
            );
          },
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (isFound) {
        return;
      }
      setState(() {
        result = scanData;
      });
      if (result.code.contains("fwitter/profile/")) {
        isFound = true;
        Navigator.pop(context);
        var userId = result.code.split("/")[2];
        Navigator.push(context, ProfilePage.getRoute(profileId: userId));
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    pageController.dispose();
    super.dispose();
  }
}

class QrCode extends StatefulWidget {
  const QrCode({Key key, this.user, this.globalKey}) : super(key: key);
  final UserModel user;
  final GlobalKey globalKey;
  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  Color color = Color(0xff07B7A6);
  Color get randomColor {
    final colors = <Color>[
      Color(0xffFF7878),
      Color(0xffFFA959),
      Color(0xff83DA2D),
      Color(0xff1FE2D7),
      Color(0xffC13E6B),
      Color(0xffFF7878),
      Color(0xff07B7A6),
      Color(0xff1F7ACD),
      Color(0xffBB78FF),
      Color(0xffF14CD7),
      Color(0xffFF5757),
      Color(0xff28B446),
      // Color(0xffffffff)
    ];

    Random ran = Random.secure();
    return colors[ran.nextInt(11)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).dividerColor.withOpacity(.6),
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          color = randomColor;
          setState(() {});
        },
        child: RepaintBoundary(
          key: widget.globalKey,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  decoration: BoxDecoration(
                      color: color,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.onPrimary,
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(22),
                  child: QrImage(
                    data: "fwitter/profile/${widget.user.userId}",
                    embeddedImageStyle:
                        QrEmbeddedImageStyle(size: Size(60, 60)),
                    version: QrVersions.auto,
                    // foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: color,
                    size: MediaQuery.of(context).size.width * .7,
                  ),
                ),
              ),
              customImage(
                context,
                widget.user.profilePic,
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
