import 'dart:convert';
import 'dart:io';

import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/components/loading_indicator.dart';
import 'package:doctorfriend/exeption/firestore_exception.dart';
import 'package:doctorfriend/exeption/handle_exception.dart';
import 'package:doctorfriend/models/app_user.dart';
import 'package:doctorfriend/models/verification.dart';
import 'package:doctorfriend/screens/user/components/camera_document.dart';
import 'package:doctorfriend/services/auth/auth_service.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/services/users/users_service.dart';
import 'package:doctorfriend/utils/firebase/firebase_storage_util.dart';
import 'package:doctorfriend/utils/firebase/firebase_tables_util.dart';
import 'package:doctorfriend/utils/tools_util.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

const cloudVisionAPIKey = "AIzaSyAMaZJVmbjn66pUAt75Kk6RQs7mxgYan_8";

class UserVerificationScreen extends StatefulWidget {
  const UserVerificationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  State<UserVerificationScreen> createState() => _UserVerificationScreenState();
}

class _UserVerificationScreenState extends State<UserVerificationScreen> {
  final AppUser _user = AuthService().currentUser!;
  XFile? _documentImage;
  XFile? _selfieImage;
  bool _loading = false;
  bool _documentImageError = false;
  bool _selfieImageError = false;
  String? _error;
  final String _lang = Translations.currentLocale.languageCode;

  Future<void> _pickDocumentImage() async {
    final XFile? pickedFile = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CameraDocument(),
      ),
    );

    setState(() {
      _error = null;
      _documentImageError = false;
      _documentImage = pickedFile;
    });
  }

  Future<void> _pickSelfieImage() async {
    final XFile? pickedFile = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CameraDocument(
          frontalCamera: true,
        ),
      ),
    );

    setState(() {
      _error = null;
      _selfieImageError = false;
      _selfieImage = pickedFile;
    });
  }

  Future<void> _verifyUser() async {
    if (_documentImage == null || _selfieImage == null) {
      return;
    }
    try {
      setState(() {
        _loading = true;
      });

      final bytesDocument = await _documentImage!.readAsBytes();
      final bytesSelfie = await _selfieImage!.readAsBytes();

      final responseOCR = await http.post(
        Uri.parse(
            'https://vision.googleapis.com/v1/images:annotate?key=$cloudVisionAPIKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'requests': [
            {
              'image': {'content': base64Encode(bytesDocument)},
              'features': [
                {'type': 'TEXT_DETECTION'},
                {'type': 'FACE_DETECTION'},
              ],
            },
          ],
        }),
      );

      if (responseOCR.statusCode == 200) {
        final ocrData = json.decode(responseOCR.body);
        final String? extractedText =
            ocrData['responses'][0]?['fullTextAnnotation']?['text'];
        final documentFace = ocrData['responses'][0]?['faceAnnotations']?[0];

        if (documentFace == null) {
          setState(() {
            _documentImageError = true;
          });
          throw HandleException('noFaceInDocument', _lang);
        }

        if (extractedText == null) {
          setState(() {
            _documentImageError = true;
          });
          throw HandleException('noTextInDocument', _lang);
        }

        final isUser = ToolsUtil.removeAccents(extractedText.toLowerCase())
            .contains(ToolsUtil.removeAccents(_user.name.toLowerCase()));

        if (!isUser) {
          setState(() {
            _documentImageError = true;
          });
          throw HandleException('noUsernameFoundInDocument', _lang);
        }

        final responseFaceDetection = await http.post(
          Uri.parse(
              'https://vision.googleapis.com/v1/images:annotate?key=$cloudVisionAPIKey'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'requests': [
              {
                'image': {'content': base64Encode(bytesSelfie)},
                'features': [
                  {'type': 'FACE_DETECTION'}
                ],
              },
            ],
          }),
        );

        if (responseFaceDetection.statusCode == 200) {
          final faceData = json.decode(responseFaceDetection.body);
          final selfieFace = faceData['responses'][0]?['faceAnnotations']?[0];

          if (selfieFace == null) {
            setState(() {
              _selfieImageError = true;
            });
            throw HandleException('noFaceInSelfie', _lang);
          }

          ///tudo certo! salvar documento e foto e verificar usuario
          await _uploadFiles(documentText: extractedText);
          return;
        } else {
          throw HandleException("failedToDetectFace", _lang);
        }
      } else {
        throw HandleException('failedToDetectDocument', _lang);
      }
    } on HandleException catch (error) {
      setState(() {
        _error = error.message;
      });
    } on FirestoreException catch (error) {
      Callback.snackBar(context, title: error.message);
    } catch (error) {
      Callback.snackBar(
        context,
        title: error.toString(),
      );
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _uploadFiles({required String documentText}) async {
    final table = "${FirebaseTablesUtil.userImages}/${_user.id}/verification";
    File documentFile = File(_documentImage!.path);
    File selfieFile = File(_selfieImage!.path);
    final String documentUrl = await FirebaseStorageUtil.uploadFileSimple(
      table: table,
      file: documentFile,
      fileName: "${_user.id}-document",
    );

    final String selfieUrl = await FirebaseStorageUtil.uploadFileSimple(
      table: table,
      file: selfieFile,
      fileName: "${_user.id}-selfie",
    );

    await UsersService().setVerification(
      Verification(
        id: _user.id,
        documentText: documentText,
        documentUrl: documentUrl,
        selfieUrl: selfieUrl,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final traslation = Translations.of(context).translate('user_verification');

    final placeholderImage = Center(
      child: Container(
        height: 150,
        width: 150 / 1.5,
        decoration: BoxDecoration(
          border: Border.all(
            width: .5,
            color: Colors.grey,
          ),
        ),
      ),
    );

    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(traslation["title"])),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        children: [
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                _error!,
                style: TextStyle(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
          TextButton.icon(
            onPressed: _pickDocumentImage,
            icon: const Icon(Icons.document_scanner),
            label: Text(traslation["document_capture"]),
          ),
          if (_documentImage != null)
            Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: _documentImageError
                        ? theme.colorScheme.error
                        : Colors.transparent,
                  ),
                ),
                child: Image.file(
                  height: 150,
                  File(_documentImage!.path),
                ),
              ),
            )
          else
            InkWell(
              onTap: _pickDocumentImage,
              child: placeholderImage,
            ),
          TextButton.icon(
            onPressed: _pickSelfieImage,
            icon: const Icon(Icons.add_a_photo_sharp),
            label: Text(traslation["selfie_capture"]),
          ),
          if (_selfieImage != null)
            Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: _selfieImageError
                        ? theme.colorScheme.error
                        : Colors.transparent,
                  ),
                ),
                child: Image.file(
                  height: 200,
                  File(_selfieImage!.path),
                ),
              ),
            )
          else
            InkWell(
              onTap: _pickSelfieImage,
              child: placeholderImage,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: ElevatedButton(
              onPressed: _documentImage == null ||
                      _selfieImage == null ||
                      _loading ||
                      _error != null
                  ? null
                  : _verifyUser,
              child: LoadingIndicator(
                loading: _loading,
                child: Text(traslation["verify_user"]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
