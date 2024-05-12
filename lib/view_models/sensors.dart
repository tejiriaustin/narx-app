class Sensor {
  final String id;
  final AccountInfo accountInfo;
  final String? deletedAt;
  final String ipAddress;
  final String name;
  final String status;
  final String image;

  Sensor({
    required this.id,
    required this.accountInfo,
    this.deletedAt,
    required this.ipAddress,
    required this.name,
    required this.status,
    required this.image,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) => Sensor(
        id: json['_id'] as String,
        accountInfo: AccountInfo.fromJson(json['account_info']),
        ipAddress: json['ipAddress'] as String,
        name: json['name'] as String,
        status: json['status'] as String,
        image: "",
      );

  Map<String, dynamic> toJson() => {
        '_id': {'\$oid': id},
        'account_info': accountInfo.toJson(),
        'ip_address': ipAddress,
        'name': name,
        'status': status,
        'image':'',
      };

  static List<Sensor> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => Sensor.fromJson(json)).toList();
  }
}

class AccountInfo {
  final String id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;

  AccountInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) => AccountInfo(
        id: json['id'] as String,
        firstName: json['first_name'] as String,
        lastName: json['last_name'] as String,
        fullName: json['full_name'] as String,
        email: json['email'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'fullname': fullName,
        'email': email,
      };
}
