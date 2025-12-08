import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable(createToJson: false)
class UserModel {
  final int? id;
  final String? email;
  final String? username;
  final String? password;
  @JsonKey(name: 'name', fromJson: _firstnameFromJson)
  final String? firstname;
  @JsonKey(name: 'name', fromJson: _lastnameFromJson)
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
    return _$UserModelFromJson(json);
  }

  static List<UserModel> fromList(List<dynamic> data) =>
      data.map((e) => UserModel.fromJson(e)).toList();

  static String? _firstnameFromJson(Map<String, dynamic>? name) {
    return name?['firstname'];
  }

  static String? _lastnameFromJson(Map<String, dynamic>? name) {
    return name?['lastname'];
  }
}