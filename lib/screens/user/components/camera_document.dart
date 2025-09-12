import 'package:camera/camera.dart';
import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/floating_button.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// CameraDocument is the Main Application.
class CameraDocument extends StatefulWidget {
  /// Default Constructor
  // final Function(XFile) onPick;
  final bool frontalCamera;
  const CameraDocument({
    super.key,
    this.frontalCamera = false,
    // required this.onPick,
  });

  @override
  State<CameraDocument> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraDocument> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  _loadCameras() async {
    await Permission.camera.request();
    _cameras = await availableCameras();
    final frontCamera = _cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );
    _controller = CameraController(
      widget.frontalCamera ? frontCamera : _cameras.first,
      ResolutionPreset.max,
    );
    _controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            Callback.snackBar(context, title: e.code);
            break;
          default:
            Callback.snackBar(context, title: e.code);
            break;
        }
      } else {
        Callback.snackBar(context, title: e.toString());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCameras();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null ||
        _controller != null && !_controller!.value.isInitialized) {
      return Container();
    }
    final traslation = Translations.of(context).translate('user_verification');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.frontalCamera
              ? traslation["pick_selfie_title"]
              : traslation["pick_document_title"],
        ),
      ),
      body: Center(child: CameraPreview(_controller!)),
      floatingActionButton: FloatingButton(
        onPress: () async {
          try {
            // await _initializeControllerFuture;

            final image = await _controller!.takePicture();
            // widget.onPick(image);
            Navigator.of(context).pop(image);
          } catch (e) {
            // print(e);
            Callback.snackBar(context, title: e.toString());
          }
        },
        icon: Icons.camera_alt,
        color: Theme.of(context).colorScheme.primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
