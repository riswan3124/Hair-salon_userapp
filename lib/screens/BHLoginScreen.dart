import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:hairsalon_prokit/utils/BHColors.dart';
import 'package:hairsalon_prokit/utils/BHConstants.dart';
import 'package:hairsalon_prokit/utils/BHImages.dart';

import 'BHDashedBoardScreen.dart';
import 'BHForgotPasswordScreen.dart';
import 'BHRegistrationScreen.dart';

class BHLoginScreen extends StatefulWidget {
  static String tag = '/LoginScreen';

  @override
  BHLoginScreenState createState() => BHLoginScreenState();
}

class BHLoginScreenState extends State<BHLoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailCont = TextEditingController();
  final TextEditingController passwordCont = TextEditingController();

  bool isLoading = false;
  String _errorMessage = "";
  bool _obscurePassword = true;

  Future<void> _loginUser() async {
    setState(() {
      isLoading = true;
      _errorMessage = "";
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: emailCont.text.trim(),
        password: passwordCont.text.trim(),
      );

      Fluttertoast.showToast(
          msg: "Login successful", backgroundColor: Colors.green);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BHDashedBoardScreen()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          _errorMessage = "No account found with this email.";
        } else if (e.code == 'wrong-password') {
          _errorMessage = "Incorrect password.";
        } else {
          _errorMessage = "Error: ${e.message}";
        }
        isLoading = false;
      });

      Fluttertoast.showToast(msg: _errorMessage, backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: BHColorPrimary,
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 24,
              child: Align(
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(BHAppLogo,
                    color: white.withOpacity(0.8), height: 150, width: 150),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 200),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15)),
                color: context.cardColor,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: emailCont,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: BHAppDividerColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: BHColorPrimary)),
                        labelText: "Email",
                        labelStyle: TextStyle(color: BHGreyColor, fontSize: 14),
                      ),
                    ),
                    TextFormField(
                      controller: passwordCont,
                      obscureText: _obscurePassword,
                      keyboardType: TextInputType.text,
                      style: primaryTextStyle(),
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: BHGreyColor, fontSize: 14),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          child: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: BHColorPrimary,
                              size: 20),
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: BHAppDividerColor)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: BHColorPrimary)),
                      ),
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(BHTxtForgetPwd,
                              style: TextStyle(
                                  color: BHAppTextColorSecondary, fontSize: 14))
                          .onTap(
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BHForgotPasswordScreen()),
                          );
                        },
                      ),
                    ),
                    16.height,
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: BHColorPrimary,
                          padding: EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        onPressed: isLoading ? null : _loginUser,
                        child: isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                BHBtnSignIn,
                                style: TextStyle(
                                    color: whiteColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                                height: 1,
                                color: BHAppDividerColor,
                                margin: EdgeInsets.only(right: 10))
                            .expand(),
                        Text(BHTxtOrSignIn, style: secondaryTextStyle()),
                        Container(
                                height: 1,
                                color: BHAppDividerColor,
                                margin: EdgeInsets.only(left: 10))
                            .expand(),
                      ],
                    ),
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.asset(BHTwitterIcon, height: 40, width: 40),
                        SvgPicture.asset(BHFacebookIcon, height: 40, width: 40),
                        SvgPicture.asset(BHPinterestIcon,
                            height: 40, width: 40),
                      ],
                    ),
                    24.height,
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text.rich(
                        TextSpan(
                          text: "You don't have an account! ",
                          style: TextStyle(color: BHAppTextColorSecondary),
                          children: <TextSpan>[
                            TextSpan(
                                text: BHBtnSignUp,
                                style: TextStyle(color: BHColorPrimary)),
                          ],
                        ),
                      ).onTap(
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BHRegistrationScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
