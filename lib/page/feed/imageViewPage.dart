import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone/helper/constant.dart';
import 'package:flutter_twitter_clone/helper/utility.dart';
import 'package:flutter_twitter_clone/model/feedModel.dart';
import 'package:flutter_twitter_clone/model/user.dart';
import 'package:flutter_twitter_clone/state/authState.dart';
import 'package:flutter_twitter_clone/state/feedState.dart';
import 'package:flutter_twitter_clone/widgets/customWidgets.dart';
import 'package:provider/provider.dart';

import 'widgets/tweetIconsRow.dart';

class ImageViewPge extends StatefulWidget {
  _ImageViewPgeState createState() => _ImageViewPgeState();
}

class _ImageViewPgeState extends State<ImageViewPge> {
  TextEditingController _textEditingController;
  FocusNode _focusNode;
  bool isToolAvailable = true;
  @override
  void initState() {
    _focusNode = FocusNode();
     _textEditingController = TextEditingController();
    super.initState();
  }

  Widget _body() {
    var state = Provider.of<FeedState>(context,);
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            color: Colors.brown.shade700,
            constraints: BoxConstraints(maxHeight: fullHeight(context)),
            child: InkWell(
              onTap: (){
                setState(() {
                   isToolAvailable = !isToolAvailable;
                });
              },
               child:_imageFeed(state.tweetDetailModel.last.imagePath)
            )
          ),
        ),
        !isToolAvailable ? Container() :
        Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.brown.shade700.withAlpha(200)
                  ),
                  child: Wrap(children: <Widget>[BackButton(
                    color: Colors.white,
                  ),],)
              ),
            )),
     !isToolAvailable ? Container() :
      Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TweetIconsRow(model:state.tweetDetailModel.last,iconColor: Theme.of(context).colorScheme.onPrimary,iconEnableColor:  Theme.of(context).colorScheme.onPrimary,),
                Container(
                  color: Colors.brown.shade700.withAlpha(200),
                  padding: EdgeInsets.only(right: 10,left:10,bottom:10),
                  child: TextField(
                    controller: _textEditingController,
                    maxLines: null,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      fillColor: Colors.blue,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {_submitButton();},
                        icon: Icon(Icons.send, color: Colors.white),
                      ),
                      focusColor: Colors.black,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      hintText: 'Comment here..',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ))),
      ],
    );
  }
  Widget _imageFeed(String _image) {
    return _image == null
        ? Container()
        : Container(
            alignment: Alignment.center,
            child: Container(
                child: customNetworkImage(_image, fit: BoxFit.fitWidth)));
  }

  void addLikeToTweet() {
    var state = Provider.of<FeedState>(context,);
    var authState = Provider.of<AuthState>(context,);
    state.addLikeToTweet(state.tweetDetailModel.last, authState.userId);
  }
  void _submitButton(){
     var state = Provider.of<FeedState>(context,);
     var authState = Provider.of<AuthState>(context,);
     var user = authState.user;
     var profilePic = user.photoUrl ;
     if(profilePic== null){
       profilePic = dummyProfilePic;
     }
     var commentedUser = User(displayName: user.displayName ?? user.email.split('@')[0],profilePic: profilePic,userId: user.uid,);
     var postId = state.tweetDetailModel.last.key;
     var tags = getHashTags(_textEditingController.text);
     FeedModel reply = FeedModel(description:  _textEditingController.text,user:commentedUser,createdAt: DateTime.now().toString(),tags:tags,userId: commentedUser.userId );
     state.addcommentToPost(postId,reply);
     FocusScope.of(context).requestFocus(_focusNode);
      setState(() {
        _textEditingController.text = '';
      });
    
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body());
  }
}
