import 'package:flutter/cupertino.dart';

class UserData extends ChangeNotifier {
  //personal details
  String name = '';
  String email = '';
  String nic = '';
  String address = '';
  String birthday = '';

  //family details
  String secondPersonName = '';
  String secondPersonBirthday = '';
  String phone = '';
  String familyCount = '';

  void updateData({
    required String name,
    required String email,
    required String nic,
    required String address,
    required String birthday,

    // Optional family detail parameters (Set to null for optionality. Used in register_2_family.dart)
    String? secondPersonName,
    String? secondPersonBirthday,
    String? phone,
    String? familyCount,
  }) {
    this.name = name;
    this.email = email;
    this.nic = nic;
    this.address = address;
    this.birthday = birthday;

    // Assigns values only if provided (null check)
    this.secondPersonName = secondPersonName ?? '';
    this.secondPersonBirthday = secondPersonBirthday ?? '';
    this.phone = phone ?? '';
    this.familyCount = familyCount ?? '';
    notifyListeners();
  }
}