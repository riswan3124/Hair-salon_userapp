import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:hairsalon_prokit/utils/BHColors.dart';
import 'package:hairsalon_prokit/utils/BHImages.dart';
import 'package:hairsalon_prokit/main.dart';
import 'package:hairsalon_prokit/utils/BHWidgets.dart';
import 'BHFinishedAppoScreen.dart';

class BHPaymentScreen extends StatefulWidget {
  final String date;
  final String time;

  BHPaymentScreen({required this.date, required this.time});

  @override
  BookAppointmentScreenState createState() => BookAppointmentScreenState();
}

class BookAppointmentScreenState extends State<BHPaymentScreen> {
  int? _radioValue1 = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void something(int? value) {
    setState(() {
      _radioValue1 = value;
    });
  }

  Future<void> _confirmPayment() async {
    try {
      String paymentMethod = _radioValue1 == 0
          ? 'Visa Card'
          : _radioValue1 == 1
              ? 'MasterCard'
              : 'Cash';

      // Adding the appointment details to Firestore, including the selected time
      await _firestore.collection('appointments').add({
        'serviceName': 'Makeup Marguerite',
        'salonName': 'Conado Hair Studio',
        'location': '301 Dorthy Walks, Chicago, US',
        'stylist': 'Lettie Neal',
        'price': 25,
        'paymentMethod': paymentMethod,
        'status': 'Booked',
        'date': widget.date,
        'time': widget.time, // Storing the selected time here
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success!'),
          content: Text('Appointment successfully booked!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to the finished screen and pass the date and time
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BHFinishedAppScreen(
                      appointmentDate: widget.date, // Pass the date
                      appointmentTime: widget.time, // Pass the time
                    ),
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error storing payment details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment', style: boldTextStyle(size: 18)),
        centerTitle: true,
        iconTheme: IconThemeData(color: appStore.isDarkModeOn ? white : black),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: context.cardColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Services', style: boldTextStyle()),
              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: context.cardColor,
                  boxShadow: [
                    BoxShadow(
                        color: BHGreyColor.withOpacity(0.3),
                        offset: Offset(0.0, 1.0),
                        blurRadius: 2.0),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: CachedNetworkImage(
                            placeholder: placeholderWidgetFn() as Widget
                                Function(BuildContext, String)?,
                            imageUrl: BHDashedBoardImage4,
                            height: 70,
                            width: 130,
                            fit: BoxFit.cover,
                          ),
                        ),
                        8.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Conado Hair Studio',
                                style: boldTextStyle(size: 14)),
                            8.height,
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 14, color: BHAppTextColorSecondary),
                                Text(
                                  '301 Dorthy walks,chicago,Us.',
                                  style: secondaryTextStyle(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ).expand(),
                              ],
                            ),
                          ],
                        ).expand(),
                      ],
                    ),
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Makeup Marguerite',
                            style: boldTextStyle(size: 14)),
                        Text(widget.time,
                            style: primaryTextStyle(
                                color: BHColorPrimary, size: 14)),
                      ],
                    ),
                    16.height,
                    Row(
                      children: [
                        Icon(Icons.person,
                            size: 14, color: BHAppTextColorSecondary),
                        Text('Lettie Neal',
                                style: TextStyle(
                                    color: BHAppTextColorSecondary,
                                    fontSize: 14))
                            .paddingOnly(left: 4),
                      ],
                    ),
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.time, style: primaryTextStyle(size: 14)),
                        Text(widget.date, style: primaryTextStyle(size: 14)),
                        Text('\$25', style: boldTextStyle(size: 14)),
                      ],
                    ),
                  ],
                ),
              ),
              16.height,
              Text('Payment Methods', style: boldTextStyle(size: 14)),
              8.height,
              ..._buildPaymentMethods(),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(12),
                    backgroundColor: BHColorPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  onPressed: _confirmPayment,
                  child: Text(
                    'Confirm Payment',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
// This function builds the list of payment options for the user to choose from.

  List<Widget> _buildPaymentMethods() {
    return [
      _buildPaymentOption(BHVisaCardImg, '**** **** *123', 0),
      _buildPaymentOption(BHMasterCardImg, '**** **** *333', 1),
      _buildPaymentOption(null, 'Pay with cash', 2),
    ];
  }

// This widget is used to display each payment option.
  Widget _buildPaymentOption(String? image, String text, int value) {
    return ListTile(
      leading: image != null ? Image.asset(image, height: 40, width: 40) : null,
      title: Text(text, style: boldTextStyle()),
      trailing: Radio(
        value: value,
        groupValue: _radioValue1,
        activeColor: BHColorPrimary,
        onChanged: (dynamic val) => something(val),
      ),
    );
  }
}
