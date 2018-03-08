// import 'dart:async';
import 'package:flutter/material.dart';

import '../helpers/theme.dart';
import '../store.dart';

import '../models/user.dart';

class SideIcon {
  const SideIcon({this.title, this.key, this.route});
  final String title;
  final String key;
  final String route;
}

const List<SideIcon> sideicons = const <SideIcon> [
  const SideIcon(title: "Tasks", key:"tasks", route: "/"),
  // const SideIcon(title: "Guilds", key: "guilds", route: "/guilds")
];

class MainDrawer extends StatefulWidget {
  @override
  MainDrawerState createState() => new MainDrawerState();
}

class MainDrawerState extends State<MainDrawer> with RouteAware {
  
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

  ImageProvider _getProfilePicture() {
    return new NetworkImage(
      user.profile.imageUrl
    );
  }

  _onMenuButtonPressed(SideIcon sideicon) {
    Navigator.pop(context);
    // Navigator.of(context).pushReplacementNamed(name)
    // Navigator.popAndPushNamed(context, sideicon.route);
    // new Timer(const Duration(milliseconds: 100), () => _pushFromSideIcon(sideicon.route));
  }

  // _pushFromSideIcon(String route) {
  //   return Navigator.of(context).pushReplacementNamed(route); 
  // }
  
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return new Drawer(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new UserAccountsDrawerHeader(
              currentAccountPicture:
              (
                (user != null && user.profile != null && user.profile.imageUrl != null) ?
                new CircleAvatar(
                  backgroundImage: _getProfilePicture(),
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
            new Expanded(
              child: new Container(
                decoration: new BoxDecoration(
                  color: mainTheme.canvasColor,
                ),
                child: new ListView.builder(
                  padding: const EdgeInsets.all(0.0),
                  itemCount: sideicons.length,      
                  itemBuilder: (BuildContext context, int index) => 
                    new ListTile(
                      onTap: () => _onMenuButtonPressed(sideicons[index]),
                      key: new Key(sideicons[index].key),
                      leading: const Icon(
                        Icons.group,                        
                        color: Colors.black54,
                      ),
                      title: new Text(
                        sideicons[index].title,
                        style:mainTheme.textTheme.subhead
                      )
                    ),
                ),
              ),
            ),
          ],
        ),
      );
    }
}
