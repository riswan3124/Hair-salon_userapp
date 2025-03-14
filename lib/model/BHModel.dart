import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class BHBestSpecialModel {
  String? title;
  String? subTitle;
  String? img;

  BHBestSpecialModel({this.title, this.subTitle, this.img});
}

class BHCallModel {
  String? img;
  String? name;
  IconData? callImg;
  String? callStatus;
  String? videoCallIcon;
  String? audioCallIcon;

  BHCallModel(
      {this.img,
      this.name,
      this.callImg,
      this.callStatus,
      this.videoCallIcon,
      this.audioCallIcon});
}

class BHCategoryModel {
  String? img;
  String? categoryName;

  BHCategoryModel({this.img, this.categoryName});
}

class BHGalleryModel {
  String img;

  BHGalleryModel({required this.img});

  factory BHGalleryModel.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return BHGalleryModel(
      img: data['img'] ?? '', // Ensure Firestore field is correct
    );
  }
}

class BHHairStyleModel {
  String? img;
  String? name;

  BHHairStyleModel({this.img, this.name});
}

class BHIncludeServiceModel {
  String? serviceImg;
  String? serviceName;
  String? time;
  int? price;

  BHIncludeServiceModel(
      {this.serviceImg, this.serviceName, this.time, this.price});
}

class BHMakeUpModel {
  String? img;
  String? name;

  BHMakeUpModel({this.img, this.name});
}

class MessageModel {
  String? img;
  String? name;
  String? message;
  String? lastSeen;

  MessageModel({this.img, this.name, this.message, this.lastSeen});
}

class BHNotificationModel {
  String? img;
  String? name;
  String? msg;
  String? status;
  String? callInfo;

  BHNotificationModel(
      {this.img, this.name, this.msg, this.status, this.callInfo});
}

class BHNotifyModel {
  String? img;
  String? name;
  String? address;
  double? rating;
  double? distance;

  BHNotifyModel(
      {this.img, this.name, this.address, this.rating, this.distance});
}

class BHOfferModel {
  String? img;
  String? offerName;
  String? offerDate;
  int? offerOldPrice;
  int? offerNewPrice;

  BHOfferModel(
      {this.img,
      this.offerName,
      this.offerDate,
      this.offerOldPrice,
      this.offerNewPrice});
}

class BHReviewModel {
  String? img;
  String? name;
  double? rating;

  String? day;
  String? review;

  BHReviewModel({this.img, this.name, this.rating, this.day, this.review});
}

class BHServicesModel {
  String img;
  String serviceName;
  String time;
  int price;
  int radioVal;

  BHServicesModel({
    required this.img,
    required this.serviceName,
    required this.time,
    required this.price,
    required this.radioVal,
  });

  // ✅ Corrected Factory Method for Firestore
  factory BHServicesModel.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return BHServicesModel(
      img: data['img'] ?? '', // Ensure this is a valid image URL
      serviceName: data['serviceName'] ?? 'Unknown Service',
      time: data['time'] ?? 'Unknown Time',
      price: (data['price'] ?? 0).toInt(),
      radioVal: (data['radioVal'] ?? 0).toInt(),
    );
  }
}

class BHSpecialOfferModel {
  String? img;
  String? title;
  String? subtitle;

  BHSpecialOfferModel({this.img, this.title, this.subtitle});
}

class BHMessageModel {
  int? senderId;
  int? receiverId;
  String? msg;
  String? time;

  BHMessageModel({this.senderId, this.receiverId, this.msg, this.time});
}

class BHDetailModel with ChangeNotifier {
  List<BHServicesModel> _servicesList = [];
  List<BHGalleryModel> _galleryList = [];

  List<BHServicesModel> get servicesList => _servicesList;
  List<BHGalleryModel> get galleryList => _galleryList;

  // ✅ Fetch Services from Firestore
  Future<void> fetchServices() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('services').get();
    _servicesList =
        snapshot.docs.map((doc) => BHServicesModel.fromFirestore(doc)).toList();
    notifyListeners();
  }

  // ✅ Fetch Gallery from Firestore
  Future<void> fetchGallery() async {
    var snapshot = await FirebaseFirestore.instance.collection('gallery').get();
    _galleryList =
        snapshot.docs.map((doc) => BHGalleryModel.fromFirestore(doc)).toList();
    notifyListeners();
  }

  void updateGalleryList(List<BHGalleryModel> newList) {
    _galleryList = newList;
    notifyListeners();
  }
}

class AppointmentModel {
  final String serviceName;
  final String salonName;
  final String location;
  final String stylist;
  final double price;
  final String paymentMethod;
  final String status;
  final DateTime selectedDate;
  final String selectedTimeSlot;

  AppointmentModel({
    required this.serviceName,
    required this.salonName,
    required this.location,
    required this.stylist,
    required this.price,
    required this.paymentMethod,
    required this.status,
    required this.selectedDate,
    required this.selectedTimeSlot,
  });

  Map<String, dynamic> toMap() {
    return {
      'serviceName': serviceName,
      'salonName': salonName,
      'location': location,
      'stylist': stylist,
      'price': price,
      'paymentMethod': paymentMethod,
      'status': status,
      'date': selectedDate.toIso8601String(),
      'timeSlot': selectedTimeSlot,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
