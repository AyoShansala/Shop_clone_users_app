import 'package:amazon_universal_app/brandsScreens/brands_ui_design_widget.dart';
import 'package:amazon_universal_app/models/sellers.dart';
import 'package:amazon_universal_app/widgets/text_delegate_header_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/brands.dart';
import '../widgets/my_drawer.dart';

class BrandsScreen extends StatefulWidget {
  Sellers? model;

  BrandsScreen({
    this.model,
  });

  @override
  State<BrandsScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<BrandsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: MyDrawer(),
      appBar: AppBar(
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
        title: const Text(
          "iShop",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextDelegateHeaderWidget(
                title: widget.model!.name.toString() + " - Brands"),
          ),
          //1.write query
          //2.model
          //3.design widget
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(widget.model!.uid.toString())
                .collection("brands")
                .orderBy("publisedDate", descending: true)
                .snapshots(),
            builder: (context, dataSnapshot) {
              if (dataSnapshot.hasData) {
                //if brand exists
                //display brands
                return SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                  itemBuilder: (context, index) {
                    Brands brandsModel = Brands.fromJson(
                      dataSnapshot.data!.docs[index].data()
                          as Map<String, dynamic>,
                    );
                    return BrandsUiDesignWidget(
                      model: brandsModel,
                    );
                  },
                  itemCount: dataSnapshot.data!.docs.length,
                );
              } else {
                //if brand NOT exixts
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text("No brands exists"),
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
