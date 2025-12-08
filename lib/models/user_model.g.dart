// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as int?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      firstname: UserModel._firstnameFromJson(json['name'] as Map<String, dynamic>?),
      lastname: UserModel._lastnameFromJson(json['name'] as Map<String, dynamic>?),
      phone: json['phone'] as String?,
    );