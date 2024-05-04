class Account {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  Account({required this.email, required this.password, required this.firstName, required this.lastName});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      email: json['email'], 
      password: json['password'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      );
  }
}