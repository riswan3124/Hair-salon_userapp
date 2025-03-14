import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hairsalon_prokit/screens/BHPaymentScreen.dart';

class BHBookAppointmentScreen extends StatefulWidget {
  @override
  _BHBookAppointmentScreenState createState() =>
      _BHBookAppointmentScreenState();
}

class _BHBookAppointmentScreenState extends State<BHBookAppointmentScreen> {
  // Variable to keep track of the current step in the appointment process
  int currentStep = 0;

  // DateTime variable to store the selected date for the appointment
  DateTime selectedDate = DateTime.now();

  // Variable to store the selected time slot for the appointment
  String? selectedTimeSlot;

  // Function to allow the user to pick a date from the calendar
  Future<void> _pickDate(BuildContext context) async {
    // Using showDatePicker to display a date picker dialog
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Default to the currently selected date
      firstDate: DateTime(
          DateTime.now().year), // Allow only current year and future dates
      lastDate:
          DateTime(DateTime.now().year + 1), // Allow dates within the next year
    );

    // If the picked date is different, update the selected date
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked; // Update the selected date
      });
      print(
          '[Line 21] 📅 Selected Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'), // Title in the app bar
        centerTitle: true, // Center the title
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Back button in the app bar
          onPressed: () =>
              Navigator.pop(context), // Navigates back to previous screen
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Colors
                      .deepOrangeAccent, // Set custom color for primary elements
                ),
              ),
              child: Stepper(
                type: StepperType
                    .vertical, // Vertical stepper (step-by-step process)
                currentStep:
                    currentStep, // Tracks the current step in the process
                controlsBuilder:
                    (BuildContext context, ControlsDetails details) {
                  return SizedBox(); // Remove default Continue & Cancel buttons
                },
                steps: [
                  // Step 1: Select Date & Time
                  Step(
                    title: Text('Select Date & Time'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('📅 Pick a date for your appointment:'),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _pickDate(
                              context), // Open date picker when tapped
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
                                    color: Colors.black54), // Calendar icon
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text('⏰ Select a time slot:'),
                        SizedBox(height: 8),

                        // Real-time Firestore StreamBuilder for available time slots
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('time_slots')
                              .snapshots(), // Listen for changes in the Firestore time slots collection
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Text("No available time slots.");
                            }

                            // Convert the Firestore document data into a list of time slots
                            List<String> timeSlots = snapshot.data!.docs
                                .map((doc) => doc['time'] as String)
                                .toList();

                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: timeSlots.map((slot) {
                                // Display each time slot as a button
                                return ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedTimeSlot =
                                          slot; // Update the selected time slot
                                    });
                                    print(
                                        '[Line 85] 📅 Selected Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}');
                                    print(
                                        '[Line 86] ⏰ Selected Time Slot: $slot');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: selectedTimeSlot == slot
                                        ? Colors.deepOrangeAccent
                                        : Colors.grey[
                                            200], // Highlight the selected slot
                                    foregroundColor: selectedTimeSlot == slot
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  child: Text(slot),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ],
                    ),
                    isActive: currentStep >= 0,
                    state: currentStep >= 0
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  // Step 2: Confirm Booking
                  Step(
                    title: Text('Confirm Booking'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('✅ Review and confirm your booking:'),
                        SizedBox(height: 8),
                        Text(
                            '📅 Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                        Text(
                            '⏰ Time Slot: ${selectedTimeSlot ?? "Not selected"}'),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: selectedTimeSlot == null
                              ? null
                              : () {
                                  print('[✅ Proceeding to Payment...]');
                                  print(
                                      '📅 Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}');
                                  print('⏰ Time Slot: $selectedTimeSlot');

                                  // Navigate to the payment screen with selected date and time
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BHPaymentScreen(
                                        date:
                                            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                                        time: selectedTimeSlot!,
                                      ),
                                    ),
                                  );
                                },
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

          // Custom Bottom Navigation Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // "Previous" button to navigate back to the previous step
              ElevatedButton(
                onPressed: currentStep == 0
                    ? null
                    : () {
                        setState(() {
                          currentStep -= 1; // Decrease currentStep to go back
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  foregroundColor: Colors.white,
                ),
                child: Text('Previous'),
              ),
              // "Next" or "Finish" button to proceed to the next step or finalize the booking
              ElevatedButton(
                onPressed: () {
                  if (currentStep < 1) {
                    setState(() {
                      currentStep += 1; // Increase currentStep to go forward
                    });
                  } else {
                    print('[✅ Finalizing booking...]');
                    print(
                        '📅 Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}');
                    print('⏰ Time Slot: ${selectedTimeSlot ?? "Not selected"}');

                    // Proceed to the payment screen once the booking is confirmed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BHPaymentScreen(
                          date:
                              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          time: selectedTimeSlot!,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  foregroundColor: Colors.white,
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
