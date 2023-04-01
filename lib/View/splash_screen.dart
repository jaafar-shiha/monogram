import 'package:flutter/material.dart';
import 'package:monogram/View/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children:  const [
          FadeInImage(
            image: AssetImage(
                'assets/images/Monogram.png',
            ),
            placeholder: AssetImage('assets/images/placeholder-image.jpg',),
            fadeInDuration: Duration(seconds: 4),
          ),
          Positioned(
            bottom: 180,
            child: FadeInImage(
              image: AssetImage(
                'assets/images/monogram_text.png',
              ),
              placeholder: AssetImage('assets/images/placeholder-image.jpg',),
              height: 40,
              width: 190,
              fadeInDuration: Duration(seconds: 4),
            ),
          ),
        ],
      ),
    );
  }
}
