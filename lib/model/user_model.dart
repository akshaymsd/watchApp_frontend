class UserModel {
  String? username;
  String? password;
  String? name;
  String? email;
  String? phone;
  String? sId;
  int? iV;

  UserModel({
    this.username,
    this.password,
    this.name,
    this.email,
    this.phone,
    this.sId,
    this.iV,
  });

  // Factory constructor for creating a UserModel instance from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      password: json['password'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      sId: json['_id'], // Ensure this matches your API response
      iV: json['__v'],
    );
  }

  // Method for converting a UserModel instance to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password; // Consider omitting this for security reasons
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}
