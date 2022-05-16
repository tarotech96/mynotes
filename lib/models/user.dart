class User {
  // Reason why id is optional field, because of  identification of the object in firebase will be generated automatically -> docId
  // we'll use that docId for userId in the future
  String? id;
  String email;
  String password;
  String image;
  String address;

  User(
      {required this.email,
      required this.password,
      required this.image,
      required this.address});

  factory User.fromMap(Map<String, dynamic> json) => User(
      email: json['email'],
      password: json['password'],
      image: json['image'],
      address: json['address']);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> user = {};
    user['email'] = email;
    user['password'] = password;
    user['image'] = image;
    user['address'] = address;

    return user;
  }
}
