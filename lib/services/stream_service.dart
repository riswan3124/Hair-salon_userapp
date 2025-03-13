import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// FirestoreService: Handles Firebase Firestore operations
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetches real-time data from the 'services' collection
  Stream<QuerySnapshot> getServices() {
    return _db.collection('services').snapshots();
  }
}

// ServicesPage: Displays services from Firestore
class ServicesPage extends StatelessWidget {
  final FirestoreService _firestoreService =
      FirestoreService(); // Instance of FirestoreService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Our Services")), // AppBar Title
      body: StreamBuilder<QuerySnapshot>(
        stream:
            _firestoreService.getServices(), // Calls FirestoreService function
        builder: (context, snapshot) {
          // If data is still loading, show a loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // If no data is available, show a message
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No services available"));
          }

          var services = snapshot.data!.docs; // Stores Firestore data

          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: services.length, // Number of items in the list
            itemBuilder: (context, index) {
              var data = services[index].data()
                  as Map<String, dynamic>; // Convert Firestore doc to Map

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10)), // Rounded corners for the card
                elevation: 3, // Shadow effect
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      data['imageUrl'] ?? '', // Service image from Firestore
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/placeholder.png', // Placeholder image if imageUrl is invalid
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    data['name'] ?? 'No name', // Service name
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "${data['time']} - \$${data['price']}"), // Service time & price
                ),
              );
            },
          );
        },
      ),
    );
  }
}
