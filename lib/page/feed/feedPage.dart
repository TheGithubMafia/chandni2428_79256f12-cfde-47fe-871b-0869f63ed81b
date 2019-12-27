import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone/helper/constant.dart';
import 'package:flutter_twitter_clone/state/feedState.dart';
import 'package:flutter_twitter_clone/widgets/customAppBar.dart';
import 'package:flutter_twitter_clone/widgets/customWidgets.dart';
import 'package:flutter_twitter_clone/widgets/tweet.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatefulWidget {
  
  final GlobalKey<ScaffoldState> scaffoldKey;
  const FeedPage({Key key, this.scaffoldKey}) : super(key: key);_FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  @override
  void initState() { 
    super.initState();
    var state = Provider.of<FeedState>(context,listen: false);
    state.databaseInit();
    state.getDataFromDatabase();
  }
  Widget _floatingActionButton(){
    return FloatingActionButton(
      onPressed: (){
         Navigator.of(context).pushNamed('/CreateFeedPage');
       },
      child: customIcon(context,icon:AppIcon.fabTweet,istwitterIcon: true, iconColor:Theme.of(context).colorScheme.onPrimary, size:25)
    );
  }
  Widget _body(){
      var state = Provider.of<FeedState>(context,);
      if(state.isBusy && state.feedlist == null){
        return loader();
      }
      else if(!state.isBusy && state.feedlist == null){
        return EmptyListWidget(
            title:'No Feed',
            subTitle: 'Seems like no feed available yet',
            packageImage: PackageImage.Image_2,
          );
      }
      else{
        return ListView.builder(
          itemCount: state.feedlist.length,
          itemBuilder: (context,index) => Tweet(model:state.feedlist[index]),
        );
      }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _floatingActionButton(),
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(scaffoldKey: widget.scaffoldKey,title: customTitleText('Home',),),
      body: Container(
        height: fullHeight(context),
        width: fullWidth(context),
        child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: ()async{
          var state = Provider.of<FeedState>(context,);
            state.getDataFromDatabase();
            return Future.value(true);
        },
        child:  _body(),)
      ),
    );
  }
}