class UserDetails {
  String? status;
  int? code;
  int? total;
  List<Data>? data;

  UserDetails({this.status, this.code, this.total, this.data});

  UserDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    total = json['total'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['total'] = total;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? uuid;
  String? firstname;
  String? lastname;
  String? username;
  String? password;
  String? email;
  String? ip;
  String? macAddress;
  String? website;
  String? image;

  Data(
      {this.id,
        this.uuid,
        this.firstname,
        this.lastname,
        this.username,
        this.password,
        this.email,
        this.ip,
        this.macAddress,
        this.website,
        this.image});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    ip = json['ip'];
    macAddress = json['macAddress'];
    website = json['website'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['username'] = username;
    data['password'] = password;
    data['email'] = email;
    data['ip'] = ip;
    data['macAddress'] = macAddress;
    data['website'] = website;
    data['image'] = image;
    return data;
  }
}