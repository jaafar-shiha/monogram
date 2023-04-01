import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:monogram/Constants/app_colors.dart';
import 'package:monogram/Constants/app_styles.dart';
import 'package:monogram/GetIt/main_app.dart';
import 'package:monogram/Repository/account_repository.dart';
import 'package:monogram/SharedWidgets/app_snack_bar.dart';
import 'package:monogram/SharedWidgets/main_scaffold.dart';
import 'package:monogram/Utils/result_classes.dart';
import 'package:monogram/generated/l10n.dart';
import 'package:monogram/locator.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  TextEditingController nameController = TextEditingController(text: locator<MainApp>().user!.name);

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: MainScaffold(
        appBarTitle: S.of(context).accountPage,
        appBarLeading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        appBarLeadingWidth: 80,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: nameController,
                decoration: AppStyles.textFormFieldDecoration(
                  label: S.of(context).name,
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          )),
                          side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(
                              color: AppColors.monogramGrey,
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(AppColors.monogramGrey),
                        ),
                        onPressed: () async {
                          if (nameController.text.isEmpty ){
                            return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          await AccountRepository()
                              .updateUserAccount(
                            id: locator<MainApp>().user!.id,
                            name: nameController.text,
                          )
                              .then((value) {
                            setState(() {
                              isLoading = false;
                            });
                            if (value is SuccessState<bool>) {
                              locator<MainApp>().user!.name = nameController.text;
                              Navigator.pop(context);
                            } else if (value is ErrorState<bool>) {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar(reason: SnackBarClosedReason.hide)
                                ..showSnackBar(appSnackBar(text: value.error.message));
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                          child: Text(
                            S.of(context).edit,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
