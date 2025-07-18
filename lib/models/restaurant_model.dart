import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {
  final String id; // This will be the owner's UID
  final String name;
  final String address;
  final String phone;
  final String? logoUrl;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    this.logoUrl,
  });

  // Factory constructor to create a RestaurantModel from a Firestore document
  factory RestaurantModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return RestaurantModel(
      id: doc.id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
      logoUrl: data['logoUrl'],
    );
  }

  // Method to convert a RestaurantModel instance to a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'logoUrl': logoUrl,
    };
  }
}
