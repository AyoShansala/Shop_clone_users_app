import 'package:amazon_universal_app/models/sellers.dart';
import 'package:amazon_universal_app/sellersScreen/sellers_ui_design_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String sellerNameText = "";
  Future<QuerySnapshot>? storesDocumentsList;

  initializeSearchingStores(String textEnterdByUser) async {
    storesDocumentsList = FirebaseFirestore.instance
        .collection("sellers")
        .where("name", isGreaterThanOrEqualTo: textEnterdByUser)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.pinkAccent,
                Colors.purpleAccent,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: TextField(
          onChanged: (textEntered) {
            setState(() {
              sellerNameText = textEntered;
            });
            initializeSearchingStores(sellerNameText);
          },
          decoration: InputDecoration(
            hintText: "Search Seller here......",
            hintStyle: const TextStyle(
              color: Colors.white54,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                initializeSearchingStores(sellerNameText);
              },
              icon: const Icon(Icons.search),
              color: Colors.white,
            ),
          ),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder(
        future: storesDocumentsList,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                Sellers searchmodel = Sellers.fromJson(
                    snapshot.data.docs[index].data() as Map<String, dynamic>);

                return SellersUIDesignWidget(
                  model: searchmodel,
                );
              },
            );
          } else {
            return const Center(
              child: Text("No Record Found."),
            );
          }
        },
      ),
    );
  }
}
