import 'package:flutter/material.dart';
import 'package:graphics/graphics_consts/graphics_string_consts.dart';
import 'package:reactiv/reactiv.dart';
import 'package:user_data_assignment/presentation/user_details/controllers/user_details.controller.dart';
import 'package:user_data_assignment/presentation/user_details/views/details_tuple.dart';

class UserDetailsScreen extends ReactiveStateWidget<UserDetailsController> {
  const UserDetailsScreen(this.id, this.uuid, this.firstName, this.lastName, this.userName, this.passWord, this.email,
      this.ip, this.macAdd, this.website, this.image,
      {super.key});

  final String id;
  final String uuid;
  final String firstName;
  final String lastName;
  final String userName;
  final String passWord;
  final String email;
  final String ip;
  final String macAdd;
  final String website;
  final String image;

  @override
  BindController<UserDetailsController>? bindController() {
    return BindController(controller: () => UserDetailsController(), autoDispose: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(GraphicsStringConsts.userDetails),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (id.isNotEmpty) DetailsTuple(title: 'Id', value: id),
                    if (uuid.isNotEmpty) DetailsTuple(title: 'UUID', value: uuid),
                    if (firstName.isNotEmpty) DetailsTuple(title: 'First Name', value: firstName),
                    if (lastName.isNotEmpty) DetailsTuple(title: 'Last Name', value: lastName),
                    if (userName.isNotEmpty) DetailsTuple(title: 'Username', value: userName),
                    if (passWord.isNotEmpty) DetailsTuple(title: 'Password', value: passWord),
                    if (email.isNotEmpty) DetailsTuple(title: 'Email', value: email),
                    if (ip.isNotEmpty) DetailsTuple(title: 'IP', value: ip),
                    if (macAdd.isNotEmpty) DetailsTuple(title: 'Mac Address', value: macAdd),
                    if (website.isNotEmpty) DetailsTuple(title: 'Website', value: website),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
