import 'package:file_picker/file_picker.dart';

class MediaService {

  MediaService(){}

  Future<PlatformFile?> pickFileFromLibrary() async {
    FilePickerResult? _results = await FilePicker.platform.pickFiles(type: FileType.image);
    if(_results != null) {
      return _results.files[0];
    }
    return null;
  }
}