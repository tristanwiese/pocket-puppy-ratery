import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileProvider extends ChangeNotifier {
  XFile? _profilePicture;
  String? _profilePictureUrl;

  get profilePicture => _profilePicture;
  get profilePictureUrl => _profilePictureUrl;

  updateProfilePicture({required XFile profilePic}) {
    _profilePicture = profilePic;
    notifyListeners();
  }

  updateProfilePictureUrl({required String profilePic}) {
    _profilePictureUrl = profilePic;
    notifyListeners();
  }
}
