class Account {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String token;

  Account({required this.email, required this.password, required this.firstName, required this.lastName, required this.token});

  factory Account.fromJson(Map<String, dynamic> jsonMap) {
    Map<String, dynamic> body = jsonMap['body'];

    return Account(
      email: body['email'], 
      password: body['password'],
      firstName: body['firstName'],
      lastName: body['lastName'],
      token: body['token'],
      );
  }
}