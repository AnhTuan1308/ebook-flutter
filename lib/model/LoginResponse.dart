class LoginResponse {
  String? token;
  String? userEmail;
  String? userNicename;
  String? userDisplayName;
  String? firstName;
  String? lastName;

  //List<String> userRole;
  int? userId;
  String? avatar;
  String? profileImage;

  LoginResponse(
      {this.token,
      this.userEmail,
      this.userNicename,
      this.userDisplayName,
      this.firstName,
      this.lastName,
      //  this.userRole,
      this.userId,
      this.avatar,
      this.profileImage});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    userEmail = json['user_email'];
    userNicename = json['user_nicename'];
    userDisplayName = json['user_display_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    userId = json['user_id'];
    avatar = json['avatar'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['user_email'] = this.userEmail;
    data['user_nicename'] = this.userNicename;
    data['user_display_name'] = this.userDisplayName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['user_id'] = this.userId;
    data['avatar'] = this.avatar;
    data['profile_image'] = this.profileImage;
    return data;
  }
}

class LoginResponseData {
  LoginData? data;

  LoginResponseData({this.data});

  LoginResponseData.fromJson(Map<String, dynamic> json) {
    data = json['result'] != null ? new LoginData.fromJson(json['result']) : null;

  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.data != null) {
      data['result'] = this.data!.toJson();
    }
    return data;
  }
}

class LoginData {
  String? userID;
  String? username;
  String? userfullName;
  String? sysToken;
  int? sysTokenExpires;
  String? volToken;
  int? volTokenExpires;
  String? refreshToken;
  int? refreshTokenExpires;
  List<String>? roles;
  List<String>? permisssions;

  LoginData(
      {
      this.userID,
      this.username,
      this.userfullName,
      this.sysToken,
      this.sysTokenExpires,
      this.volToken,
      this.volTokenExpires,
      this.refreshToken,
      this.refreshTokenExpires,
      this.roles,
      this.permisssions
      }
      );

  LoginData.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    username = json['username'];
    userfullName = json['fullName'];
    sysToken = json['sysToken'];
    sysTokenExpires = json['sysTokenExpires'];
    volToken = json['volToken'];
    volTokenExpires = json['volTokenExpires'];
    refreshToken = json['refreshToken'];
    refreshTokenExpires = json['refreshTokenExpires'];
    roles = json['roles'] != null ? new List<String>.from(json['roles']) : null;
    permisssions = json['permisssions'] != null ? new List<String>.from(json['permisssions']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['username'] = this.username;
    data['fullName'] = this.userfullName;
    data['sysToken'] = this.sysToken;
    data['volToken'] = this.volToken;
    data['volTokenExpires'] = this.volTokenExpires;
    data['refreshToken'] = this.refreshToken;
    data['refreshTokenExpires'] = this.refreshTokenExpires;
    data['roles'] = this.roles;
    data['permisssions'] = this.permisssions;
    return data;
  }
}


