class Account {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String token;

  Account({required this.email, required this.password, required this.firstName, required this.lastName, required this.token});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      email: json['email'], 
      password: json['password'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      token: json['token'],
      );
  }
}