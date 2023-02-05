class UserAddressModel {
  String? addressDocId;
  String? fullName;
  String? mobileNo;
  String? phoneNo;
  String? landline;
  String? city;
  String? streetName;
  String? buildingNumber;
  String? specialPlace;
  String? mapAddress;
  bool? isMainAddress;

  UserAddressModel({
    required this.addressDocId,
    required this.fullName,
    required this.mobileNo,
    required this.phoneNo,
    required this.landline,
    required this.city,
    required this.streetName,
    required this.buildingNumber,
    required this.specialPlace,
    required this.mapAddress,
    this.isMainAddress = false,
  });

  UserAddressModel.fromJson(Map<String, dynamic> json)
      : fullName = json['fullName'],
        addressDocId = json['addressDocId'],
        mobileNo = json['mobileNo'],
        phoneNo = json['phoneNo'],
        landline = json['landline'],
        city = json['city'],
        streetName = json['streetName'],
        buildingNumber = json['buildingNumber'].toString(),
        specialPlace = json['specialPlace'].toString(),
        mapAddress = json['mapAddress'].toString(),
        isMainAddress = json['isMainAddress'];

  Map<String, dynamic> toMap() => {
        'addressDocId': addressDocId,
        'fullName': fullName,
        'mobileNo': mobileNo,
        'phoneNo': phoneNo,
        'landline': landline,
        'city': city,
        'streetName': streetName,
        'buildingNumber': buildingNumber,
        'specialPlace': specialPlace,
        'isMainAddress': isMainAddress,
      };
  Map<String, dynamic> toUpdate() => {
        'fullName': fullName,
        'mobileNo': mobileNo,
        'phoneNo': phoneNo,
        'landline': landline,
        'city': city,
        'streetName': streetName,
        'buildingNumber': buildingNumber,
        'specialPlace': specialPlace,
        'isMainAddress': isMainAddress,
      };
}
