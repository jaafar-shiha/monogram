import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:monogram/Constants/app_colors.dart';
import 'package:monogram/Constants/app_styles.dart';
import 'package:monogram/Providers/tabs_provider.dart';
import 'package:monogram/Utils/tabs_enum.dart';
import 'package:provider/provider.dart';

class MainScaffold extends StatefulWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final bool showBottomNavigationBar;
  final Widget? appBarLeading;
  final double appBarLeadingWidth;
  final List<Widget>? appBarActions;
  final String appBarTitle;

  const MainScaffold({
    Key? key,
    required this.body,
    this.floatingActionButton,
    this.showBottomNavigationBar = false,
    this.appBarLeading,
    this.appBarActions,
    this.appBarLeadingWidth = 10,
    required this.appBarTitle,
  }) : super(key: key);

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  void changeCurrentTab(int index) {
    Provider.of<TabsProvider>(context, listen: false).changeCurrentTab(Tabs(index));
  }

  @override
  Widget build(BuildContext context) {
    //TODO: make user non-nullable the user must be signed in first to open home page (It is null for testing).
    return Container(
      color: AppColors.monogramGrey,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: widget.appBarLeading,
            leadingWidth: widget.appBarLeadingWidth,
            actions: widget.appBarActions,
            backgroundColor: AppColors.monogramGrey,
            title: Text(widget.appBarTitle, style: AppStyles.h1),
          ),
          body: widget.body,
          floatingActionButton: widget.floatingActionButton,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: widget.showBottomNavigationBar ? AnimatedBottomNavigationBar(
            icons: const [Icons.home, Icons.notifications, Icons.people_alt, Icons.settings],
            activeIndex: 0,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.softEdge,
            leftCornerRadius: 30,
            rightCornerRadius: 30,
            onTap: changeCurrentTab,
            //other params
          ) : const SizedBox(),
        ),
      ),
    );
  }
}
