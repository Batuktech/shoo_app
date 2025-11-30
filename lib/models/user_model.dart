class UserModel {
  final int? id;
  final String? email;
  final String? username;
  final String? password;
  final String? firstname;
  final String? lastname;
  final String? phone;

  UserModel({
    this.id,
    this.email,
    this.username,
    this.password,
    this.firstname,
    this.lastname,
    this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      firstname: json['name'] != null ? json['name']['firstname'] : null,
      lastname: json['name'] != null ? json['name']['lastname'] : null,
      phone: json['phone'] as String?,
    );
  }

  static List<UserModel> fromList(List<dynamic> data) =>
      data.map((e) => UserModel.fromJson(e)).toList();
}