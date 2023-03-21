
import 'BorrowBookResponse.dart';
import 'DashboardResponse.dart';



class Extensions {
   int? id;
   String? createdAt;
   BorrowRequestData? request;
   Extensions ({
    this.id,
    this.createdAt,
    this.request,
   });
    Extensions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    request =  json['bookBorrow'] != null ? new BorrowRequestData.fromJson(json['bookBorrow']) : null;

  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    if(this.request != null) {
      data['bookBorrow'] = this.request!.toJson();
    }
    return data;
  }
}
class ExtensionsResponse {
  List<Extensions>? data;
   ExtensionsResponse ({this.data});

  ExtensionsResponse.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      data = <Extensions>[];
      json['result'].forEach((v) {
        data!.add(new Extensions.fromJson(v));
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

class BorrowRequestResponse {

    List<BorrowRequestData>? data;

  BorrowRequestResponse({this.data});

  BorrowRequestResponse.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      data = <BorrowRequestData>[];
      json['result'].forEach((v) {
        data!.add(new BorrowRequestData.fromJson(v));
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

class BorrowRequestData{
    int? id;
    DashboardBookInfo? bookInfo;
    List<Comments>? comments;
    int? bookID;
    String? status;
    String? borrowType;
    Account? requester;
    String? requesterID;
    Account? approver;
    String? approverID;
    String? createdAt;
    List<Notes>? notes;

  BorrowRequestData({
    this.id,
    this.bookInfo,
    this.comments,
    this.bookID,
    this.status,
    this.borrowType,
    this.requester,
    this.requesterID,
    this.approver,
    this.approverID,
    this.createdAt,
    this.notes
  });


  BorrowRequestData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookInfo = json['book'] != null ? new DashboardBookInfo.fromJson(json['book']) : null;
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
    bookID = json['bookID'];
    status = json['status'];
    borrowType = json['borrowType'];
    requester = json['requester'] != null ? new Account.fromJson(json['requester']) : null;
    requesterID = json['requesterID'];
    approver = json['approver'] != null ? new Account.fromJson(json['approver']) : null;
    approverID = json['approverID'];
    createdAt = json['createdAt'];
    if (json['notes'] != null) {
      notes = <Notes>[];
    json['notes'].forEach((v) {
        notes!.add(new Notes.fromJson(v));
      });
    }
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if(this.bookInfo != null) {
      data['book'] = this.bookInfo!.toJson();
    }
    data['bookID'] = this.bookID;
    data['status'] = this.status;
    data['borrowType'] = this.borrowType;
    if(this.requester != null) {
      data['requester'] = this.requester!.toJson();
    }
    data['requesterID'] = this.requesterID;
    if(this.approver != null) {
      data['approver'] = this.approver!.toJson();
    }
    data['approverID'] = this.approverID;
    data['createdAt'] = this.createdAt;
    if (this.notes != null) {
      data['notes'] = this.notes!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}
  