import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hairsalon_prokit/utils/BHWidgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:hairsalon_prokit/screens/BHDashedBoardScreen.dart';
import 'package:hairsalon_prokit/screens/BHLoginScreen.dart';
import 'package:hairsalon_prokit/utils/BHColors.dart';
import 'package:hairsalon_prokit/utils/BHConstants.dart';
import 'package:hairsalon_prokit/utils/BHImages.dart';

class BHRegistrationScreen extends StatefulWidget {
  static String tag = '/NewRegistrationScreen';

  @override
  NewRegistrationScreenState createState() => NewRegistrationScreenState();
}

class NewRegistrationScreenState extends State<BHRegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController fullNameCont = TextEditingController();
  final TextEditingController emailCont = TextEditingController();
  final TextEditingController passwordCont = TextEditingController();
  final TextEditingController dateOfBirthCont = TextEditingController();
  final TextEditingController addressCont = TextEditingController();

  bool isLoading = false;
  bool _obscurePassword = true;

  Future<void> _registerUser() async {
    if (fullNameCont.text.isEmpty ||
        emailCont.text.isEmpty ||
        passwordCont.text.isEmpty ||
        dateOfBirthCont.text.isEmpty ||
        addressCont.text.isEmpty) {
      Fluttertoast.showToast(msg: "All fields are required.");
      return;
    }

    setState(() => isLoading = true);

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailCont.text.trim(),
        password: passwordCont.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': fullNameCont.text.trim(),
          'email': user.email,
          'role': 'user',
          'dateOfBirth': dateOfBirthCont.text.trim(),
          'address': addressCont.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        Fluttertoast.showToast(msg: "Account Created Successfully!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BHDashedBoardScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? "Registration failed.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        dateOfBirthCont.text = pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(BHColorPrimary);

    return SafeArea(
      child: Scaffold(
        backgroundColor: BHColorPrimary,
        body: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 24),
              alignment: Alignment.topCenter,
              child: SvgPicture.asset(
                BHAppLogo,
                color: white.withOpacity(0.8),
                height: 150,
                width: 150,
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
                  topLeft: Radius.circular(15),
                ),
                color: context.cardColor,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _buildTextField(fullNameCont, "Full Name", Icons.person),
                    _buildTextField(emailCont, "Email", Icons.email),
                    _buildPasswordField(),
                    _buildDatePickerField(),
                    _buildTextField(
                        addressCont, "Your Address", Icons.location_on),
                    SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(12),
                        backgroundColor: BHColorPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: isLoading ? null : _registerUser,
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              BHBtnSignUp,
                              style: TextStyle(
                                color: whiteColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BHLoginScreen()),
                      ),
                      child: Text.rich(
                        TextSpan(
                          text: BHTxtAccount,
                          style: TextStyle(color: BHAppTextColorSecondary),
                          children: <TextSpan>[
                            TextSpan(
                              text: BHBtnSignIn,
                              style: TextStyle(color: BHColorPrimary),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            BackButton(color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      style: primaryTextStyle(),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: BHAppDividerColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: BHColorPrimary),
        ),
        labelText: label,
        labelStyle: secondaryTextStyle(),
        suffixIcon: Icon(icon, color: BHColorPrimary, size: 20),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordCont,
      obscureText: _obscurePassword,
      keyboardType: TextInputType.text,
      style: primaryTextStyle(),
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: secondaryTextStyle(),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          child: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: BHColorPrimary,
            size: 20,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: BHAppDividerColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: BHColorPrimary),
        ),
      ),
    );
  }

  Widget _buildDatePickerField() {
    return TextFormField(
      controller: dateOfBirthCont,
      readOnly: true,
      onTap: _pickDate,
      style: primaryTextStyle(),
      decoration: InputDecoration(
        labelText: "Date of Birth",
        labelStyle: secondaryTextStyle(),
        suffixIcon: Icon(Icons.calendar_today, color: BHColorPrimary, size: 16),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: BHAppDividerColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: BHColorPrimary),
        ),
      ),
    );
  }
}
