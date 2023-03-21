import 'DashboardResponse.dart';

class AllBookListResponse {
  Pagination? pagination;
  List<DashboardBookInfo>? data;
  AllBookListResponse({this.pagination, this.data});
  AllBookListResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['result'] != null) {
      data = <DashboardBookInfo>[];
      json['result'].forEach((v) {
        data!.add(new DashboardBookInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
        if(this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.data != null) {
      data['result'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
