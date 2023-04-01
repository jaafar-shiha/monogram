import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:monogram/Blocs/RegisterBloc/register_bloc.dart';
import 'package:monogram/Blocs/RegisterBloc/register_event.dart';
import 'package:monogram/Blocs/RegisterBloc/register_state.dart';
import 'package:monogram/Constants/app_colors.dart';
import 'package:monogram/Constants/app_styles.dart';
import 'package:monogram/GetIt/main_app.dart';
import 'package:monogram/Models/user_model.dart';
import 'package:monogram/Repository/sign_in_register_repository.dart';
import 'package:monogram/SharedWidgets/app_snack_bar.dart';
import 'package:monogram/Utils/translate_firebase_error.dart';
import 'package:monogram/View/Registering/add_profile_photo_screen.dart';
import 'package:monogram/generated/l10n.dart';
import 'package:monogram/locator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool passwordVisibility = false;
  bool confirmPasswordVisibility = false;
  final SignInRegisterRepository _signInRegisterRepository = SignInRegisterRepository();
  late final RegisterBloc _registerBloc = BlocProvider.of<RegisterBloc>(context);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  late ValueNotifier<bool> isLoading = ValueNotifier(false);

  void showProgressIndicator(bool val) {
    isLoading.value = val;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (context) => RegisterBloc(signInRegisterRepository: _signInRegisterRepository),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<RegisterBloc, RegisterState>(
          bloc: _registerBloc,
          listenWhen: (previous, current) {
            return previous != current;
          },
          listener: (context, state) {
            showProgressIndicator(state is LoadingRegisterState);
            if (state is ErrorRegisterState) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar(reason: SnackBarClosedReason.hide)
                ..showSnackBar(
                    appSnackBar(text: translateErrorMessage(context, state.error.code, state.error.message)));
            }
            if (state is SuccessRegisterState) {
              // context.read<UserProvider>().setCurrentUser(
              //       UserModel(
              //         id: state.data.user.uid,
              //         name: nameController.text,
              //         email: emailController.text,
              //       ),
              //     );
              locator<MainApp>().user = UserModel(
                id: state.data.user.uid,
                name: nameController.text,
                email: emailController.text,
              );
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) => const AddProfilePhotoScreen()));
            }
          },
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              return ValueListenableBuilder(
                  valueListenable: isLoading,
                  builder: (context, val, child) {
                    return ModalProgressHUD(
                      inAsyncCall: isLoading.value,
                      progressIndicator: CircularProgressIndicator(
                        color: AppColors.monogramGrey,
                      ),
                      child: Container(
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
                                            passwordVisibility
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      obscuringCharacter: '*',
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: confirmPasswordController,
                                      obscureText: confirmPasswordVisibility ? false : true,
                                      decoration: AppStyles.textFormFieldDecoration(
                                        label: S.of(context).confirmPassword,
                                        prefixIcon: const Icon(
                                          Icons.lock_outline_rounded,
                                          color: Colors.black,
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              confirmPasswordVisibility = !confirmPasswordVisibility;
                                            });
                                          },
                                          icon: Icon(
                                            confirmPasswordVisibility
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
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
                                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
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
                                                if (nameController.text == '' ||
                                                    emailController.text == '' ||
                                                    passwordController.text == '' ||
                                                    confirmPasswordController.text == '') {
                                                  ScaffoldMessenger.of(context)
                                                    ..hideCurrentSnackBar(reason: SnackBarClosedReason.hide)
                                                    ..showSnackBar(appSnackBar(
                                                      text: S.of(context).pleaseFillAllFields,
                                                    ));
                                                  return;
                                                }
                                                if (passwordController.text != confirmPasswordController.text) {
                                                  ScaffoldMessenger.of(context)
                                                    ..hideCurrentSnackBar(reason: SnackBarClosedReason.hide)
                                                    ..showSnackBar(appSnackBar(
                                                      text: S.of(context).passwordsNotIdentical,
                                                    ));
                                                  return;
                                                }
                                                _registerBloc.add(
                                                  RegisterPressed(
                                                    name: nameController.text,
                                                    email: emailController.text,
                                                    password: passwordController.text,
                                                  ),
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                                child: Text(
                                                  S.of(context).register,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text.rich(TextSpan(
                                          text: '${S.of(context).alreadyHaveAnAccount} ',
                                          style: AppStyles.h2GreyBold.copyWith(color: Colors.black87),
                                          children: <InlineSpan>[
                                            TextSpan(
                                              text: S.of(context).signIn,
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.of(context).pop();
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
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}
