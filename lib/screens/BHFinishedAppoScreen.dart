import 'package:flutter/material.dart';
import 'package:hairsalon_prokit/main.dart';
import 'package:hairsalon_prokit/screens/BHDashedBoardScreen.dart';
import 'package:hairsalon_prokit/utils/BHColors.dart';
import 'package:hairsalon_prokit/utils/BHImages.dart';
import 'package:nb_utils/nb_utils.dart';
import 'BHPaymentScreen.dart'; // Make sure to import the screen where the user books an appointment

class BHFinishedAppScreen extends StatefulWidget {
  final String appointmentDate;
  final String appointmentTime;

  BHFinishedAppScreen(
      {required this.appointmentDate, required this.appointmentTime});

  @override
  FinishedScreenState createState() => FinishedScreenState();
}

class FinishedScreenState extends State<BHFinishedAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Booked',
            style: boldTextStyle(color: BHAppTextColorPrimary)),
        centerTitle: true,
        iconTheme: IconThemeData(color: appStore.isDarkModeOn ? white : black),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(right: 16, left: 16, top: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: context.cardColor,
              boxShadow: [
                BoxShadow(
                    color: BHGreyColor,
                    offset: Offset(0.0, 1.0),
                    blurRadius: 2.0)
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Conado Hair Salon', style: boldTextStyle(size: 14)),
                      8.height,
                      Text('301 Dorothy Walks, Chicago, US',
                          style: secondaryTextStyle())
                    ],
                  ),
                  16.height,
                  Text('Service: Makeup Marguerite',
                      style: boldTextStyle(size: 14)),
                  8.height,
                  Text('Stylist: Lettie Neal',
                      style: secondaryTextStyle(size: 14)),
                  16.height,
                  Text('Date: ${widget.appointmentDate}',
                      style: primaryTextStyle(size: 14)),
                  Text('Time: ${widget.appointmentTime}',
                      style: primaryTextStyle(size: 14)),
                  16.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Price: \$25', style: boldTextStyle(size: 14)),
                    ],
                  ),
                  16.height,
                ],
              ),
            ),
          ),
          // Buttons arranged vertically
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Align buttons vertically
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Stretch buttons to full width
              children: [
                // Go Back Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: BHColorPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 16), // Add space between buttons
// Make More Appointment Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BHDashedBoardScreen(
                            // You can pass default time or modify this part
                            ),
                      ),
                    );
                  },
                  child: Text(
                    'Make More Appointments',
                    style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: const Color.fromARGB(
                        255, 255, 255, 255), // White background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Colors
                            .orangeAccent, // Border color (orange in this case)
                        width: 2, // Border width
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
