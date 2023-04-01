import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:monogram/Blocs/FeedBloc/feed_bloc.dart';
import 'package:monogram/Blocs/FriendsBloc/friends_bloc.dart';
import 'package:monogram/Blocs/RegisterBloc/register_bloc.dart';
import 'package:monogram/Blocs/SignInBloc/sign_in_bloc.dart';
import 'package:monogram/Providers/main_provider.dart';
import 'package:monogram/Providers/tabs_provider.dart';
import 'package:monogram/Repository/feed_repository.dart';
import 'package:monogram/Repository/friends_repository.dart';
import 'package:monogram/Repository/sign_in_register_repository.dart';
import 'package:monogram/View/splash_screen.dart';
import 'package:monogram/generated/l10n.dart';
import 'package:monogram/locator.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(signInRegisterRepository: SignInRegisterRepository()),
      ),
      BlocProvider<SignInBloc>(
        create: (context) => SignInBloc(signInRegisterRepository: SignInRegisterRepository()),
      ),
      BlocProvider<FeedBloc>(
        create: (context) => FeedBloc(feedRepository: FeedRepository()),
      ),
    BlocProvider<FriendsBloc>(
        create: (context) => FriendsBloc(friendsRepository: FriendsRepository()),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TabsProvider()),
        ChangeNotifierProvider(create: (_) => MainProvider()),
      ],
      child: Consumer<MainProvider>(builder: (context,mainProvider,_){
        return MaterialApp(
          title: 'Monogram',
          supportedLocales: S.delegate.supportedLocales,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.black,
            appBarTheme: const AppBarTheme(
              actionsIconTheme: IconThemeData(color: Colors.black),
              iconTheme: IconThemeData(color: Colors.black),
            ),
          ),
          locale: mainProvider.languageCode != null ? Locale(mainProvider.languageCode!) :
          null,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        );
      }),
    );
  }
}
