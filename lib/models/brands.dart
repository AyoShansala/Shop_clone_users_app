import 'package:cloud_firestore/cloud_firestore.dart';

class Brands {
  String? brandID;
  String? brandInfo;
  String? BrandTitle;
  Timestamp? publishedDate;
  String? sellerUID;
  String? status;
  String? thumbnailUrl;

  Brands({
    this.brandID,
    this.brandInfo,
    this.BrandTitle,
    this.publishedDate,
    this.sellerUID,
    this.status,
    this.thumbnailUrl,
  });
  Brands.fromJson(Map<String, dynamic> json) {
    brandID = json["brandID"];
    brandInfo = json["brandInfo"];
    BrandTitle = json["BrandTitle"];
    publishedDate = json["publishedDate"];
    sellerUID = json["sellerUID"];
    status = json["status"];
    thumbnailUrl = json["thumbnailUrl"];
  }
}
