class UserModel {
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? image;
  String? password;

  UserModel({
    this.email,
    this.name,
    this.phone,
    this.uId,
    this.image,
    this.password,
  });

  UserModel.fromJson(Map<Object?, Object?>? json) {
    email = json!['email'] as String?;
    name = json['name'] as String?;
    phone = json['phone'] as String?;
    uId = json['uId'] as String?;
    image = json['image'] as String?;
    password = json['password'] as String?;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'image': image,
      'password': password,
    };
  }
}
