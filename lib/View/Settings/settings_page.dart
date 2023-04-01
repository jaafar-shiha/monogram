import 'package:flutter/material.dart';
import 'package:monogram/Constants/app_colors.dart';
import 'package:monogram/Constants/app_styles.dart';
import 'package:monogram/GetIt/main_app.dart';
import 'package:monogram/Providers/main_provider.dart';
import 'package:monogram/Providers/tabs_provider.dart';
import 'package:monogram/SharedWidgets/app_dialog.dart';
import 'package:monogram/Utils/tabs_enum.dart';
import 'package:monogram/View/Settings/setting_card.dart';
import 'package:monogram/generated/l10n.dart';
import 'package:monogram/locator.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {


  String getLanguageName(){
    if (Provider.of<MainProvider>(context).languageCode == 'en'){
      return 'English';
    }
    else{
      return 'العربية';
    }
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SettingCard(title: S.of(context).language,onTap: (){
            showModalBottomSheet(
                context: context,
                barrierColor: Colors.transparent,
                constraints: BoxConstraints(
                  maxHeight: 160,
                  minWidth: MediaQuery.of(context).size.width,
                ),
                backgroundColor: AppColors.grey,
                shape: const OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            Provider.of<MainProvider>(context,listen: false).setLanguage('en');
                          },
                          child: const Text(
                            'English',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          style: ButtonStyle(overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)),
                        ),
                        const Divider(
                          thickness: 0.5,
                          color: Colors.white,
                          height: 5,
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            Provider.of<MainProvider>(context,listen: false).setLanguage('ar');
                          },
                          child: const Text(
                            'العربية',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          style: ButtonStyle(overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)),
                        ),
                      ],
                    ),
                  );
                });
          }),
          SettingCard(title: S.of(context).logout,onTap: (){
            showDialog(
                context: context,
                builder: (context) =>
                    AppDialog.showAlertDialog(title: S().doYouWantToLogout, actions: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            S().no,
                            style: AppStyles.h3,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Provider.of<TabsProvider>(context,listen: false).changeCurrentTab(Tabs.feed);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            S().yes,
                            style: AppStyles.h3,
                          ),
                        ),
                      ),
                    ]));
          },)
        ],
      ),
    );
  }
}
