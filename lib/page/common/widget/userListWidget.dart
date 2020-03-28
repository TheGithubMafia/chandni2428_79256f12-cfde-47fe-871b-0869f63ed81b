import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone/helper/constant.dart';
import 'package:flutter_twitter_clone/helper/theme.dart';
import 'package:flutter_twitter_clone/model/user.dart';
import 'package:flutter_twitter_clone/state/authState.dart';
import 'package:flutter_twitter_clone/state/feedState.dart';
import 'package:flutter_twitter_clone/state/notificationState.dart';
import 'package:flutter_twitter_clone/widgets/customWidgets.dart';
import 'package:flutter_twitter_clone/widgets/newWidget/customUrlText.dart';
import 'package:flutter_twitter_clone/widgets/newWidget/emptyList.dart';
import 'package:flutter_twitter_clone/widgets/newWidget/rippleButton.dart';
import 'package:provider/provider.dart';

class UserListWidget extends StatelessWidget {
  final List<String> list;
  final fetchingListbool;
  final String emptyScreenText;
  final String emptyScreenSubTileText;
  String myId;
  UserListWidget(
      {Key key,
      this.list,
      this.emptyScreenText,
      this.fetchingListbool,
      this.emptyScreenSubTileText})
      : super(key: key);
  Widget _userTile(BuildContext context, User user) {
    bool isFollow = isFollowing(user);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      color: TwitterColor.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
              onTap: () {
                // Navigator.of(context).pushNamed('/ProfilePage/' + user?.userId);
              },
              leading: RippleButton(
                borderRadius: BorderRadius.all(Radius.circular(60)),
                child: customImage(context, user.profilePic, height: 60),
              ),
              title: Row(
                children: <Widget>[
                  UrlText(
                    text: user.displayName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: 3),
                  user.isVerified
                      ? customIcon(
                          context,
                          icon: AppIcon.blueTick,
                          istwitterIcon: true,
                          iconColor: AppColor.primary,
                          size: 13,
                          paddingIcon: 3,
                        )
                      : SizedBox(width: 0),
                ],
              ),
              subtitle: Text(user.userName),
              trailing: RippleButton(
                onPressed: () {},
                splashColor: TwitterColor.dodgetBlue_50.withAlpha(100),
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: isFollow ? 15 : 20, vertical: 3),
                  decoration: BoxDecoration(
                    color:
                        isFollow ? TwitterColor.dodgetBlue : TwitterColor.white,
                    border:
                        Border.all(color: TwitterColor.dodgetBlue, width: 1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    isFollow ? 'Following' : 'Follow',
                    style: TextStyle(
                        color: isFollow ? TwitterColor.white : Colors.blue,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )),
          getBio(user.bio) == null
              ? SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.only(left: 90),
                  child: Text(
                    getBio(user.bio),
                  ),
                )
        ],
      ),
    );
  }

  String getBio(String bio) {
    if (bio != null && bio.isNotEmpty && bio != "Edit profile to update bio") {
      if (bio.length > 100) {
        bio = bio.substring(0, 100) + '...';
        return bio;
      } else {
        return bio;
      }
    }
    return null;
  }

  bool isFollowing(User model) {
    if (model.followersList != null &&
        model.followersList.any((x) => x == myId)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context, listen: false);
    myId = state.userModel.key;
    return list != null && list.isNotEmpty
        ? ListView.separated(
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: state.getuserDetail(list[index]),
                builder: (context, AsyncSnapshot<User> snapshot) {
                  if (snapshot.hasData) {
                    return _userTile(context, snapshot.data);
                  } else if (index == 0) {
                    return Container(
                        child: SizedBox(
                      height: 3,
                      child: LinearProgressIndicator(),
                    ));
                  } else {
                    return SizedBox.shrink();
                  }
                },
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 0,
              );
            },
            itemCount: list.length,
          )
        : fetchingListbool
            ? SizedBox(
                height: 3,
                child: LinearProgressIndicator(),
              )
            : Container(
                width: fullWidth(context),
                padding: EdgeInsets.only(top: 0, left: 30, right: 30),
                child: NotifyText(
                  title: emptyScreenText,
                  subTitle: emptyScreenSubTileText,
                ),
              );
  }
}
