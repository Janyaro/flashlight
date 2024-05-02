import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isFlashlightOn = false;
  CameraController? _controller;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: Colors.blue,
          title: const Text(
            'Flash Light',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        backgroundColor: (_isFlashlightOn ? Colors.white : Colors.black),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                onTap: () {
                  _toggleFlashlight();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                        color: _isFlashlightOn ? Colors.black : Colors.white,
                        width: 8),
                  ),
                  child: Icon(
                    _isFlashlightOn ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Flash Light mode :',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: _isFlashlightOn ? Colors.black : Colors.white),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  _isFlashlightOn ? 'OFF' : 'ON',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: _isFlashlightOn ? Colors.black : Colors.white),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // Functions

  void _toggleFlashlight() async {
    if (_isFlashlightOn) {
      _controller?.dispose();
      setState(() {
        _isFlashlightOn = false;
      });
    } else {
      if (await _isPermissionGranted()) {
        List<CameraDescription> cameras = await availableCameras();
        if (cameras.isNotEmpty) {
          _controller = CameraController(cameras[0], ResolutionPreset.low);
          await _controller!.initialize();
          await _controller!.setFlashMode(FlashMode.torch);
          setState(() {
            _isFlashlightOn = true;
          });
        }
      }
    }
  }

  Future<bool> _isPermissionGranted() async {
    PermissionStatus status = await Permission.camera.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.camera.request();
    }
    return status == PermissionStatus.granted;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
