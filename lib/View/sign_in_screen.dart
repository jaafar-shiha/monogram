import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:monogram/Blocs/SignInBloc/sign_in_bloc.dart';
import 'package:monogram/Blocs/SignInBloc/sign_in_event.dart';
import 'package:monogram/Blocs/SignInBloc/sign_in_state.dart';
import 'package:monogram/Constants/app_colors.dart';
import 'package:monogram/Constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:monogram/GetIt/main_app.dart';
import 'package:monogram/Models/user_model.dart';
import 'package:monogram/SharedWidgets/app_snack_bar.dart';
import 'package:monogram/Utils/translate_firebase_error.dart';
import 'package:monogram/View/Home/home_page.dart';
import 'package:monogram/generated/l10n.dart';
import 'package:monogram/locator.dart';
import 'Registering/register_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool passwordVisibility = false;

  late final SignInBloc _signInBloc = BlocProvider.of<SignInBloc>(context);


  late ValueNotifier<bool> isLoading = ValueNotifier(false);

  void showProgressIndicator(bool val) {
    isLoading.value = val;
  }

  @override
  void initState() {
    locator<MainApp>().user = null;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: isLoading, builder: (context, val, child){
      return ModalProgressHUD(
        inAsyncCall: isLoading.value,
        child: BlocListener<SignInBloc, SignInState>(
          bloc: _signInBloc,
          listenWhen: (previous, current) {
            return previous != current;
          },
          listener: (context, state) {
            showProgressIndicator(state is LoadingSignInState);
            if (state is SuccessSignInState<UserCredential>) {
              locator<MainApp>().user = UserModel(
                id: state.data.user!.uid,
                name: state.data.user!.displayName!,
                email: state.data.user!.email!,
                profilePictureUrl: state.data.user!.photoURL,
              );
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
            }
            else if (state is ErrorSignInState<UserCredential>) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar(reason: SnackBarClosedReason.hide)
                ..showSnackBar(
                    appSnackBar(text: translateErrorMessage(context, state.error.code, state.error.message)));
            }
            else if (state is SuccessGoogleSignInState<UserCredential>) {
              locator<MainApp>().user = UserModel(
                id: state.data.user!.uid,
                name: state.data.user!.displayName!,
                email: state.data.user!.email!,
              );
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
            }
          },
          child: Scaffold(
            body: Container(
              color: Colors.white,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.asset(
                            'assets/images/Monogram.png',
                            height: 200,
                            width: 300,
                          ),
                        ),
                        const SizedBox.shrink(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: emailController,
                            decoration: AppStyles.textFormFieldDecoration(
                              label: S.of(context).email,
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: passwordVisibility ? false : true,
                            decoration: AppStyles.textFormFieldDecoration(
                              label: S.of(context).password,
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: Colors.black,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordVisibility = !passwordVisibility;
                                  });
                                },
                                icon: Icon(
                                  passwordVisibility ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            obscuringCharacter: '*',
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
                                    onPressed: () {
                                      if (emailController.text == '' || passwordController.text == '') {
                                        ScaffoldMessenger.of(context)
                                          ..hideCurrentSnackBar(reason: SnackBarClosedReason.hide)
                                          ..showSnackBar(appSnackBar(
                                            text: S.of(context).pleaseFillAllFields,
                                          ));
                                        return;
                                      }
                                      _signInBloc.add(
                                        SignInWithCredentialsPressed(
                                            email: emailController.text, password: passwordController.text),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                      child: Text(
                                        S.of(context).signIn,
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
                        const SizedBox.shrink(),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Divider(
                                  thickness: 1.1,
                                  height: 2.0,
                                  color: AppColors.grey,
                                ),
                              ),
                            ),
                            Text(
                              S.of(context).or,
                              style: AppStyles.h2GreyBold,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Divider(
                                  thickness: 1.1,
                                  height: 2.0,
                                  color: AppColors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox.shrink(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2.5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                _signInBloc.add(SignInWithGooglePressed());
                              },
                              icon: Image.asset(
                                'assets/images/google.png',
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text.rich(TextSpan(
                                text: '${S.of(context).newUser} ',
                                style: AppStyles.h2GreyBold.copyWith(color: Colors.black87),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: S.of(context).register,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => const RegisterScreen(),
                                          ),
                                        );
                                      },
                                    style: AppStyles.h2GreyBold.copyWith(
                                      color: AppColors.monogramGrey,
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.underline,
                                    ),
                                  )
                                ])),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
