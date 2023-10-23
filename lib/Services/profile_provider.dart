import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileProvider extends ChangeNotifier {
  XFile? _profilePicture;
  String? _profilePictureUrl;
  bool _showFile = false;

  get profilePicture => _profilePicture;
  get profilePictureUrl => _profilePictureUrl;
  get showFile => _showFile;

  updateProfilePicture({required XFile profilePic}) {
    _profilePicture = profilePic;
    notifyListeners();
  }

  updateProfilePictureUrl({required String profilePic}) {
    _profilePictureUrl = profilePic;
    notifyListeners();
  }

  setShowFile({required bool show}) {
    _showFile = show;
    notifyListeners();
  }
}
