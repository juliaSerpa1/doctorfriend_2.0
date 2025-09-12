import 'package:firebase_storage/firebase_storage.dart';

class UploadStream {
  final Stream<TaskSnapshot> snapshotEvents;
  final Future<String> Function() getDownloadURL;
  double _progress = 0;
  bool _paused = false;
  bool _canceled = false;
  bool _error = false;
  bool _finished = false;
  String? _downloadURL;

  UploadStream({
    required this.snapshotEvents,
    required this.getDownloadURL,
  });

  double get progress => _progress;
  bool get paused => _paused;
  bool get canceled => _canceled;
  bool get error => _error;
  bool get finished => _finished;
  String? get downloadURL => _downloadURL;

  listen({required Function() sateChanged}) async {
    snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          _paused = false;
          _progress = progress;
          sateChanged();
          break;
        case TaskState.paused:
          _paused = true;
          sateChanged();
          break;
        case TaskState.canceled:
          _canceled = true;
          sateChanged();
          break;
        case TaskState.error:
          // Handle unsuccessful uploads
          _error = true;
          sateChanged();
          break;
        case TaskState.success:
          _downloadURL = await getDownloadURL();
          _finished = true;
          sateChanged();
          break;
      }
    });
  }

  Future<void> awaitFilishe() async {
    await Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      return !_finished;
    });
  }
}
