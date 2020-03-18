import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone/helper/enum.dart';
import 'package:flutter_twitter_clone/helper/utility.dart';
import 'package:flutter_twitter_clone/model/user.dart';
import 'package:flutter_twitter_clone/widgets/customWidgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart' as Path;
import 'appState.dart';
import 'package:firebase_database/firebase_database.dart' as dabase;

class AuthState extends AppState {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  bool isSignInWithGoogle = false;
  FirebaseUser user;
  String userId;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  dabase.Query _profileQuery;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User _profileUserModel;
  User _userModel;

  User get userModel => _userModel;

  User get profileUserModel => _profileUserModel;

  /// Logout from device
  void logoutCallback() {
    authStatus = AuthStatus.NOT_DETERMINED;
    userId = '';
    _userModel = null;
    _profileUserModel = null;
    if (isSignInWithGoogle) {
      _googleSignIn.signOut();
    } else {
      _auth.signOut();
    }
    notifyListeners();
  }

  /// Alter select auth method, login and sign up page
  void openSignUpPage() {
    authStatus = AuthStatus.NOT_LOGGED_IN;
    userId = '';
    notifyListeners();
  }

  databaseInit() {
    try {
      if (_profileQuery == null) {
        _profileQuery = _database.reference().child("profile");
        _profileQuery.onChildChanged.listen(_onProfileChanged);
      }
    } catch (error) {
      cprint(error, errorIn: 'databaseInit');
    }
  }

  /// Verify user's credentials for login
  Future<String> signIn(String email, String password,
      {GlobalKey<ScaffoldState> scaffoldKey}) async {
    try {
      var result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      userId = user.uid;
      return user.uid;
    } catch (error) {
      cprint(error, errorIn: 'signIn');
      customSnackBar(scaffoldKey, error.message);
      // logoutCallback();
      return null;
    }
  }

  /// Create user from `google login`
  Future<FirebaseUser> handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      user = (await _auth.signInWithCredential(credential)).user;
      authStatus = AuthStatus.LOGGED_IN;
      userId = user.uid;
      isSignInWithGoogle = true;
      createUserFromGoogleSignIn(user);
      notifyListeners();
      return user;
    } catch (error) {
      cprint(error, errorIn: 'handleGoogleSignIn');
      return null;
    }
  }

  /// Create user profile from google login
  createUserFromGoogleSignIn(FirebaseUser user) {
    User model = User(
      bio: 'Edit profile to update bio',
      dob: DateTime(1950, DateTime.now().month, DateTime.now().day + 3)
          .toString(),
      location: 'Somewhere in universe',
      profilePic: user.photoUrl,
      displayName: user.displayName,
      email: user.email,
      key: user.uid,
      userId: user.uid,
      contact: user.phoneNumber,
      isVerified: true,
    );
    createUser(model, newUser: true);
  }

  /// Create new user's profile in db
  Future<String> signUp(User userModel,
      {GlobalKey<ScaffoldState> scaffoldKey, String password}) async {
    try {
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: password,
      );
      user = result.user;
      authStatus = AuthStatus.LOGGED_IN;

      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = userModel.displayName;
      updateInfo.photoUrl = userModel.profilePic;
      await result.user.updateProfile(updateInfo);
      _userModel = userModel;
      _userModel.key = user.uid;
      _userModel.userId = user.uid;
      createUser(_userModel, newUser: true);
      return user.uid;
    } catch (error) {
      cprint(error, errorIn: 'signUp');
      customSnackBar(scaffoldKey, error.message);
      return null;
    }
  }

  /// `Create` and `Update` user
  /// IF `newUser` is true new user is created
  /// Else existing user will update with new values
  createUser(User user, {bool newUser = false}) {
    if (newUser) {
      // Create username by the combination of name and id
      user.userName = getUserName(id: user.userId, name: user.displayName);

      // Time at which user is created
      user.createdAt = DateTime.now().toUtc().toString();
    }
    _database
        .reference()
        .child('profile')
        .child(user.userId)
        .set(user.toJson());
    _userModel = user;
    if (_profileUserModel != null) {
      _profileUserModel = _userModel;
    }
    notifyListeners();
  }

  /// Fetch current user profile
  Future<FirebaseUser> getCurrentUser() async {
    try {
      user = await _firebaseAuth.currentUser();
      if (user != null) {
        authStatus = AuthStatus.LOGGED_IN;
        userId = user.uid;
        getProfileUser();
      } else {
        authStatus = AuthStatus.NOT_DETERMINED;
      }
      notifyListeners();
      return user;
    } catch (error) {
      cprint(error, errorIn: 'getCurrentUser');
      authStatus = AuthStatus.NOT_DETERMINED;
      return null;
    }
  }

  /// Sign out user
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    // user.sendEmailVerification();
  }

  /// Check if user's email is verified
  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  /// Send password reset link to email
  Future<void> forgetPassword(String email,
      {GlobalKey<ScaffoldState> scaffoldKey}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email).then((value) {
        customSnackBar(scaffoldKey,
            'A reset password link is sent yo your mail.You can reset your password from there');
      }).catchError((error) {
        print(error.message);
        return false;
      });
    } catch (error) {
      customSnackBar(scaffoldKey, error.message);
      return Future.value(false);
    }
  }

  /// `Update user` profile
  Future<void> updateUserProfile(User userModel, {File image}) async {
    try {
      if (image == null) {
        createUser(userModel);
      } else {
        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child('user/profile/${Path.basename(image.path)}');
        StorageUploadTask uploadTask = storageReference.putFile(image);
        await uploadTask.onComplete.then((value) {
          storageReference.getDownloadURL().then((fileURL) async {
            print(fileURL);
            UserUpdateInfo updateInfo = UserUpdateInfo();
            updateInfo.displayName = userModel?.displayName ?? user.displayName;
            updateInfo.photoUrl = fileURL;
            await user.updateProfile(updateInfo);
            if (userModel != null) {
              userModel.profilePic = fileURL;
              createUser(userModel);
            } else {
              _userModel.profilePic = fileURL;
              createUser(_userModel);
            }
          });
        });
      }
    } catch (error) {
      cprint(error, errorIn: 'updateUserProfile');
    }
  }

  /// Fetch user profile
  getProfileUser({String userProfileId}) {
    try {
      _profileUserModel = null;
      userProfileId = userProfileId == null ? userId : userProfileId;
      _database
          .reference()
          .child("profile")
          .child(userProfileId)
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          var map = snapshot.value;
          if (map != null) {
            _profileUserModel = User.fromJson(map);
            if (userProfileId == userId) {
              _userModel = _profileUserModel;
            }
            getFollowingUser();
            notifyListeners();
          }
        }
      });
    } catch (error) {
      cprint(error, errorIn: 'getProfileUser');
    }
  }

  List<String> followingList = [];

  /// Get following user
  getFollowingUser() {
    try {
      followingList = null;
      _database
          .reference()
          .child("followList")
          .child(profileUserModel.userId)
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          followingList = [];
          var map = snapshot.value;
          if (map != null) {
            map['following'].forEach((key, value) {
              followingList.add(key);
            });
            if (profileUserModel.userId == userId) {
              _userModel.following = followingList.length;
            } else {
              profileUserModel.following = followingList.length;
            }
            notifyListeners();
          }
        }
      });
    } catch (error) {
      cprint(error, errorIn: 'getProfileUser');
    }
  }

  /// Follow / Unfollow user
  followUser({bool removeFollower = false}) {
    try {
      if (removeFollower) {
        profileUserModel.followersList.remove(userModel.userId);

        profileUserModel.followers = profileUserModel.followersList.length;

        _database
            .reference()
            .child("followList")
            .child(userModel.userId)
            .child("following")
            .child(profileUserModel.userId)
            .remove();
        cprint('user removed from follwer list');
      } else {
        if (profileUserModel.followersList == null) {
          profileUserModel.followersList = [userModel.userId];
          // upda
        } else {
          profileUserModel.followersList.add(userModel.userId);
        }
        profileUserModel.followers = profileUserModel.followersList.length;

        _database
            .reference()
            .child("followList")
            .child(userModel.userId)
            .child("following")
            .child(profileUserModel.userId)
            .set({"userId": profileUserModel.userId});
        cprint('user added to follwer list');
      }
      _database
          .reference()
          .child('profile')
          .child(profileUserModel.userId)
          .set(profileUserModel.toJson());
      notifyListeners();
    } catch (error) {
      cprint(error, errorIn: 'getProfileUser');
    }
  }

  void _onProfileChanged(Event event) {
    if (event.snapshot != null) {
      _userModel = User.fromJson(event.snapshot.value);
      cprint('USer Updated');
      notifyListeners();
    }
  }
}
