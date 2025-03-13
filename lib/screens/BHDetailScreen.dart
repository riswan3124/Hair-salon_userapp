import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hairsalon_prokit/main.dart';
import 'package:nb_utils/nb_utils.dart';

import 'package:hairsalon_prokit/model/BHModel.dart';
import 'package:hairsalon_prokit/screens/BHBookAppointmentScreen.dart';
import 'package:hairsalon_prokit/utils/BHColors.dart';
import 'package:hairsalon_prokit/utils/BHConstants.dart';
import 'package:hairsalon_prokit/utils/BHDataProvider.dart';
import 'package:hairsalon_prokit/utils/BHImages.dart';
import 'package:hairsalon_prokit/utils/BHWidgets.dart';

class BHDetailScreen extends StatefulWidget {
  static String tag = '/NewSliverCustom';

  @override
  BHDetailScreenState createState() => BHDetailScreenState();
}

class BHDetailScreenState extends State<BHDetailScreen>
    with SingleTickerProviderStateMixin {
  // Variables to store dynamic data
  String information = '';
  String contact = '';
  String openingTime = '';
  String address = '';

  @override

  // Fetch data from Firestore
  void fetchAboutDetails() async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('about')
          .doc('details')
          .get();

      if (doc.exists) {
        print("Document Data: ${doc.data()}"); // Debugging

        setState(() {
          information = doc['information'] ?? 'No details available';
          contact = doc['contact'] ?? 'No contact available';
          openingTime = doc['openingTime'] ?? 'No opening time available';
          address = doc['address'] ?? 'No address available';
        });
      } else {
        print("Document not found");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  int? _radioValue1 = 0;
  late TabController controller;

  List<BHGalleryModel> galleryList = [];
  late List<BHCategoryModel> categoryList;
  late List<BHOfferModel> offerList;
  late List<BHServicesModel> servicesList;
  late List<BHHairStyleModel> hairStyleList;
  late List<BHMakeUpModel> makeupList;

  @override
  void initState() {
    super.initState();
    changeStatusColor(Colors.transparent);
    galleryList = getGalleryList();
    categoryList = getCategory();
    offerList = getOfferList();
    servicesList = getServicesList();
    hairStyleList = getHairStyleList();
    makeupList = getMakeupList();
    controller = TabController(length: 3, vsync: this);
    fetchAboutDetails();
  }

  void something(int? value) {
    setState(() {
      _radioValue1 = value;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    changeStatusColor(appStore.isDarkModeOn ? scaffoldDarkColor : white);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: white),
                  onPressed: () {
                    finish(context);
                  },
                ),
                backgroundColor: BHColorPrimary,
                pinned: true,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background:
                      Image.asset(BHDashedBoardImage6, fit: BoxFit.cover),
                  centerTitle: true,
                ),
                bottom: TabBar(
                  controller: controller,
                  labelColor: whiteColor,
                  unselectedLabelColor: whiteColor,
                  indicatorColor: BHColorPrimary,
                  tabs: [
                    Tab(text: BHTabAbout),
                    Tab(text: BHTabGallery),
                    Tab(text: BHTabServices),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: controller,
            children: [
              aboutWidget(),
              galleryWidget(),
              serviceWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget aboutWidget() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('about')
          .doc('details')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator()); // Loading indicator
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error loading data"));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text("No details available"));
        }

        var doc = snapshot.data!;
        String information = doc['information'] ?? 'No details available';
        String contact = doc['contact'] ?? 'No contact available';
        String openingTime = doc['openingTime'] ?? 'No opening time available';
        String address = doc['address'] ?? 'No address available';

        return SingleChildScrollView(
          child: Column(
            children: [
              infoCard(BHTxtInformation, information),
              infoCard(BHTxtContact, contact),
              infoCard(BHTxtOpeningTime, openingTime),
              infoCard(BHTxtAddress, address),
            ],
          ),
        );
      },
    );
  }

  Widget galleryWidget() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 18.0,
        crossAxisSpacing: 16.0,
        children: galleryList.map((data) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(data.img!, fit: BoxFit.cover),
          );
        }).toList(),
      ),
    );
  }

  Widget serviceWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            itemCount: servicesList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  serviceCard(servicesList[index]),
                  SizedBox(height: 10), // Space between cards
                ],
              );
            },
          ),
          ElevatedButton(
            onPressed: () => BHBookAppointmentScreen().launch(context),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(12),
              backgroundColor: BHColorPrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
            child: Text(BHBtnBookAppointment,
                style: boldTextStyle(color: whiteColor)),
          ).paddingOnly(top: 8, bottom: 16),
        ],
      ),
    );
  }

  Widget serviceCard(BHServicesModel service) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: context.cardColor,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 69, 68, 68).withOpacity(0.3),
            offset: Offset(0, 1),
            blurRadius: 9.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 10.0), // Increased vertical padding for more height
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              child: commonCacheImageWidget(service.img, 80,
                  width: 80, fit: BoxFit.cover),
            ),
            8.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.serviceName!, style: boldTextStyle()),
                8.height,
                Text('${service.time} - \$${service.price}',
                    style: secondaryTextStyle(color: BHColorPrimary)),
              ],
            ).expand(),
            Radio(
              value: service.radioVal,
              groupValue: _radioValue1,
              activeColor: BHColorPrimary,
              onChanged: (dynamic value) => something(value),
            ),
          ],
        ),
      ),
    );
  }
}
