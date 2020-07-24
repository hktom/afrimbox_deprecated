import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class FireBaseStorageController {
  dynamic urlImage;
  FirebaseStorage store = FirebaseStorage.instance;
  //GET URL IMAGE
  Future<void> getImageUrl({path, img}) async {
    final ref = store.ref().child("$path/$img");
    final url = await ref.getDownloadURL();
    urlImage = url;
  }

  //UPLOAD IMAGE
  Future<String> setImage({File image, path}) async {
    String url = '';
    StorageReference storageReference =
        store.ref().child('$path/${Path.basename(image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    await storageReference.getDownloadURL().then((fileURL) {
      url = fileURL;
    });
    return url;
  }
}
