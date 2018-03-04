import 'package:flutter/material.dart';

import '../helpers/theme.dart';
import '../store.dart';

import '../api/base.dart';

import '../models/user.dart';

class MainDrawer extends StatefulWidget {
  @override
  MainDrawerState createState() => new MainDrawerState();
}

class MainDrawerState extends State<MainDrawer> {
  
  User user = userstore.state.user;
  bool isLoading = userstore.state.isLoading;

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      userstore.onChange.listen((state) {
        if(mounted) {
          setState(() {
            user = state.user;
            isLoading = state.isLoading;
          });
        }
      });
    }
  
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              currentAccountPicture:
              ( 
                (user != null && user.profile != null && user.profile.imageUrl != null) ?
                new CircleAvatar(
                  backgroundImage: new NetworkImage(
                    user.profile.imageUrl,
                  ),
                ):
                null                                                                                                              
              ),
              accountName: new Text(
                (user != null && user.profile != null && user.profile.name != null) ? user.profile.name : "",
                style: mainTheme.primaryTextTheme.subhead
              ),
              accountEmail: new Text(
                (user != null && user.auth != null && user.auth.local != null && user.auth.local.email != null) ? user.auth.local.email : "",
                style: mainTheme.primaryTextTheme.caption
              ),
            ),
            new Text("Hello"),
          ],
        ),
      );
    }
}
