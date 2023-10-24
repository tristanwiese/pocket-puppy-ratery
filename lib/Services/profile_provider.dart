import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocket_puppy_rattery/Models/user.dart';

class ProfileProvider extends ChangeNotifier {
  XFile? _profilePicture;
  bool _showFile = false;
  UserModel? _user;

  get profilePicture => _profilePicture;
  get showFile => _showFile;
  UserModel get user => _user!;

  updateProfilePicture({required XFile profilePic}) {
    _profilePicture = profilePic;
    notifyListeners();
  }

  setShowFile({required bool show}) {
    _showFile = show;
    notifyListeners();
  }

  updateUser({required UserModel user}) {
    _user = user;
    // notifyListeners();
  }
}
