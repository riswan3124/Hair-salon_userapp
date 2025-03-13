import 'package:flutter/material.dart';
import 'package:hairsalon_prokit/screens/BHPaymentScreen.dart';

class BHBookAppointmentScreen extends StatefulWidget {
  @override
  _BHBookAppointmentScreenState createState() =>
      _BHBookAppointmentScreenState();
}

class _BHBookAppointmentScreenState extends State<BHBookAppointmentScreen> {
  int currentStep = 0;
  DateTime selectedDate = DateTime.now();
  String? selectedTimeSlot;

  final List<String> timeSlots = [
    '7:30 - 8:30 AM',
    '9:30 - 10:30 AM',
    '4:30 - 5:30 PM',
    '6:30 - 7:30 PM',
    '1:30 - 2:30 PM',
    '3:30 - 4:30 PM',
  ];

  Future<void> _pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null && picked != selectedDate) {
      Future.delayed(Duration(milliseconds: 50), () {
        setState(() {
          selectedDate = picked;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary:
                      Colors.deepOrangeAccent, // Change Continue button color
                ),
              ),
              child: Stepper(
                type: StepperType.vertical,
                currentStep: currentStep,
                onStepContinue: () {
                  if (currentStep < 1) {
                    setState(() {
                      currentStep += 1;
                    });
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BHPaymentScreen()),
                    );
                  }
                },
                onStepCancel: () {
                  if (currentStep > 0) {
                    setState(() {
                      currentStep -= 1;
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
                steps: [
                  Step(
                    title: Text('Select Date & Time'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pick a date for your appointment:'),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _pickDate(context),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Icon(Icons.calendar_today,
                                    color: Colors.black54),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text('Select a time slot:'),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: timeSlots.map((slot) {
                            return ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedTimeSlot = slot;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedTimeSlot == slot
                                    ? Colors.deepOrangeAccent
                                    : Colors.grey[200],
                                foregroundColor: selectedTimeSlot == slot
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              child: Text(slot),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    isActive: currentStep >= 0,
                    state: currentStep >= 0
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                    title: Text('Confirm Booking'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Review and confirm your booking:'),
                        SizedBox(height: 8),
                        Text(
                            '📅 Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                        Text(
                            '⏰ Time Slot: ${selectedTimeSlot ?? "Not selected"}'),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BHPaymentScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.deepOrangeAccent, // Button color
                            foregroundColor: Colors.white, // Text color
                          ),
                          child: Text('Proceed to Payment'),
                        ),
                      ],
                    ),
                    isActive: currentStep >= 1,
                    state: currentStep >= 1
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: currentStep == 0
                    ? null
                    : () {
                        setState(() {
                          currentStep -= 1;
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent, // Button color
                  foregroundColor: Colors.white, // Text color
                ),
                child: Text('Previous'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (currentStep < 1) {
                    setState(() {
                      currentStep += 1;
                    });
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BHPaymentScreen(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent, // Button color
                  foregroundColor: Colors.white, // Text color
                ),
                child: Text(currentStep == 1 ? 'Finish' : 'Next'),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
