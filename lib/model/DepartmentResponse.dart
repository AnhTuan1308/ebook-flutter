class DepartmentResponse {

  List<DepartmentData>? data;

  DepartmentResponse({this.data});

   DepartmentResponse.fromJson(Map<String, dynamic> json) {
        if (json['result'] != null) {
        data = <DepartmentData>[];
        json['result'].forEach((v) {
        data!.add(new DepartmentData.fromJson(v));
      });
    }
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['result'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}




class DepartmentData {
  int? id;
  String? name;
  String? code;
  bool? isActive;
  bool? isDeleted;
  // List<ChildDepartments>? childDepartments;
  DepartmentData({this.id,this.name,this.code,this.isActive,this.isDeleted});

   DepartmentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['isActive'] = this.isActive;
    data['isDeleted'] = this.isDeleted;
    return data;
  }
}


