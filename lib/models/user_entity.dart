class UserEntity {
  String id;
  String email;
  String password;
  String image;
  String address;

  UserEntity(
      {required this.id,
      required this.email,
      required this.password,
      required this.image,
      required this.address});

  factory UserEntity.fromMap(Map<String, dynamic> json) => UserEntity(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      image: json['image'],
      address: json['address']);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> user = {};
    user['id'] = id;
    user['email'] = email;
    user['password'] = password;
    user['image'] = image;
    user['address'] = address;

    return user;
  }
}
