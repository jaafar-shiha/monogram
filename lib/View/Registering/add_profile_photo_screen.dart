import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:monogram/Blocs/RegisterBloc/register_bloc.dart';
import 'package:monogram/Blocs/RegisterBloc/register_event.dart';
import 'package:monogram/Blocs/RegisterBloc/register_state.dart';
import 'package:monogram/Constants/app_colors.dart';
import 'package:monogram/GetIt/main_app.dart';
import 'package:monogram/Models/user_model.dart';
import 'package:monogram/SharedWidgets/profile_picture.dart';
import 'package:monogram/View/Home/home_page.dart';
import 'package:monogram/generated/l10n.dart';
import 'package:monogram/locator.dart';

class AddProfilePhotoScreen extends StatefulWidget {
  const AddProfilePhotoScreen({Key? key}) : super(key: key);

  @override
  _AddProfilePhotoScreenState createState() => _AddProfilePhotoScreenState();
}

class _AddProfilePhotoScreenState extends State<AddProfilePhotoScreen> {
  XFile? image;

  late final RegisterBloc _registerBloc = BlocProvider.of<RegisterBloc>(context);

  late ValueNotifier<bool> isLoading = ValueNotifier(false);

  void showProgressIndicator(bool val) {
    isLoading.value = val;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<RegisterBloc, RegisterState>(
        bloc: _registerBloc,
        listenWhen: (previous, current) {
          return previous != current;
        },
        listener: (context, state) {
          showProgressIndicator(state is LoadingRegisterState);
          if (state is SuccessRegisterState) {
            UserModel currentUser = locator<MainApp>().user!;
            locator<MainApp>().user = currentUser.copyWith(profilePictureUrl: state.data);

            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
          }
        },
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            return ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (context, value, child) {
                  return ModalProgressHUD(
                      inAsyncCall: isLoading.value,
                      child: SafeArea(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: Text(
                                    '${S.of(context).welcomeToMonogram}, ${locator<MainApp>().user!.name}',
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                                  child: Text(
                                    S.of(context).addAPictureForYourProfile,
                                    style: const TextStyle(
                                      fontSize: 28,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ProfilePicture(
                                    selectedImage: image,
                                    getNewSelectedImage: (selectedImage) {
                                      setState(() {
                                        image = selectedImage;
                                      });
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
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
                                      if (image == null) return;
                                      await image?.readAsBytes().then((value) => null);
                                      _registerBloc.add(
                                        AddProfilePicturePressed(
                                          id: locator<MainApp>().user!.id,
                                          profilePicture: image!,
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 8.0),
                                      child: Text(
                                        S.of(context).saveAndContinue,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(builder: (context) => const HomePage()));
                                    },
                                    child: Text(
                                      S.of(context).continueWithoutAddingAPhoto,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    style:
                                        ButtonStyle(overlayColor: MaterialStateProperty.all<Color>(Colors.transparent)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ));
                });
          },
        ),
      ),
    );
  }
}
