import 'DashboardResponse.dart';







class BorrowBookResponse {
  // Pagination? pagination;
  List<BorrowBookData>? data;

  BorrowBookResponse({this.data});

  BorrowBookResponse.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      data = <BorrowBookData>[];
      json['result'].forEach((v) {
        data!.add(new BorrowBookData.fromJson(v));
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

class BorrowBookData {
  int? id;
  int? digitalBookID;
  String? borrowType;
  PhysicalBook? physicalBook;
  int? physicalBookID;
  String? isbn;
  DashboardBookInfo? bookInfo;
  int? bookID;
  String? borrowDate;
  String? returnDate;
  String? extendedReturnDate;
  Account? borrower;
  String? borrowerID;
  Account? creator;
  String? creatorID;
  Account? pickUpConfirmedBy;
  String? pickUpConfirmedByID;
  Account? returnConfirmedBy;
  String? returnConfirmedByID;
  int? requestID;
  String? bookReceivedDate;
  String? bookReturnedDate;
  String? status;
  List<Notes>? notes;
  bool? isdownloaded = false;
  BorrowBookData({
    this.id,
    this.digitalBookID,
    this.borrowType,
    this.physicalBook,
    this.physicalBookID,
    this.isbn,
    this.bookInfo,
    this.bookID,
    this.borrowDate,
    this.returnDate,
    this.extendedReturnDate,
    this.borrower,
    this.borrowerID,
    this.creator,
    this.creatorID,
    this.pickUpConfirmedBy,
    this.pickUpConfirmedByID,
    this.returnConfirmedBy,
    this.returnConfirmedByID,
    this.requestID,
    this.bookReceivedDate,
    this.bookReturnedDate,
    this.status,
    this.notes,
    this.isdownloaded,
  });

  BorrowBookData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    digitalBookID = json['digitalBookID'];
    borrowType = json['borrowType'];
    physicalBook = json['physicalBook'] != null ? new PhysicalBook.fromJson(json['physicalBook']) : null;
    physicalBookID = json['physicalBookID'];
    isbn = json['isbn'];
    bookInfo = json['book'] != null ? new DashboardBookInfo.fromJson(json['book']) : null;
    bookID = json['bookID'];
    borrowDate = json['borrowDate'];
    returnDate = json['returnDate'];
    extendedReturnDate = json['extendedReturnDate'];
    borrower = json['borrower'] != null ? new Account.fromJson(json['borrower']) : null;
    borrowerID = json['borrowerID'];
    creator = json['creator'] != null ? new Account.fromJson(json['creator']) : null;
    creatorID = json['creatorID'];
    pickUpConfirmedBy = json['pickUpConfirmedBy'] != null ? new Account.fromJson(json['pickUpConfirmedBy']) : null;
    pickUpConfirmedByID = json['pickUpConfirmedByID'];
    returnConfirmedBy = json['returnConfirmedBy'] != null ? new Account.fromJson(json['returnConfirmedBy']) : null;
    returnConfirmedByID = json['returnConfirmedByID'];
    requestID = json['requestID'];
    bookReceivedDate = json['bookReceivedDate'];
    bookReturnedDate = json['bookReturnedDate'];
    status = json['status'];
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
    data['digitalBookID'] = this.digitalBookID;
    data['borrowType'] = this.borrowType;
    if(this.physicalBook != null) {
      data['physicalBook'] = this.physicalBook!.toJson();
    }
    data['physicalBookID'] = this.physicalBookID;
    data['isbn'] = this.isbn;
    if(this.bookInfo != null) {
      data['book'] = this.bookInfo!.toJson();
    }
    data['bookID'] = this.bookID;
    data['borrowDate'] = this.borrowDate;
    data['returnDate'] = this.returnDate;
    data['extendedReturnDate'] = this.extendedReturnDate;
    if(this.borrower != null) {
      data['borrower'] = this.borrower!.toJson();
    }
    data['borrowerID'] = this.borrowerID;
    if(this.creator != null) {
      data['creator'] = this.creator!.toJson();
    }
    data['creatorID'] = this.creatorID;
    if(this.pickUpConfirmedBy != null) {
      data['pickUpConfirmedBy'] = this.pickUpConfirmedBy!.toJson();
    }
    data['pickUpConfirmedByID'] = this.pickUpConfirmedByID;
    if(this.returnConfirmedBy != null) {
      data['returnConfirmedBy'] = this.returnConfirmedBy!.toJson();
    }
    data['returnConfirmedByID'] = this.returnConfirmedByID;
    data['requestID'] = this.requestID;
    data['bookReceivedDate'] = this.bookReceivedDate;
    data['bookReturnedDate'] = this.bookReturnedDate;
    if (this.notes != null) {
      data['notes'] = this.notes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class PhysicalBook {
  int? id;
  int? bookID;
  String? isbn;
  String? status;
  String? importDate;
  ShelfArea? shelfArea;
  int? shelfAreaID;
  bool? isAvailable;
  bool? isActive;


  PhysicalBook (
    {
      this.id,
      this.bookID,
      this.isbn,
      this.status,
      this.importDate,
      this.shelfArea,
      this.shelfAreaID,
      this.isAvailable,
      this.isActive
  }
  );
  PhysicalBook.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookID = json['bookID'];
    isbn = json['isbn'];
    status = json['status'];
    importDate = json['importDate'];
    shelfArea = json['shelfArea'] != null ? new ShelfArea.fromJson(json['shelfArea']) : null;
    shelfAreaID = json['shelfAreaID'];
    isAvailable = json['isAvailable'];
    isActive = json['isActive'];
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = this.id;
      data['bookID'] = this.bookID;
      data['isbn'] = this.isbn;
      data['status'] = this.status;
      data['importDate'] = this.importDate;
      data['shelfAreaID'] = this.shelfAreaID;
    if(this.shelfArea != null) {
      data['shelfArea'] = this.shelfArea!.toJson();
    }
      data['isAvailable'] = this.isAvailable;
      data['isActive'] = this.isActive;
    return data;
  }
}
class ShelfArea {
  int? id;
  String? name;
  Bookshelf? bookshelf;
  int? bookshelfID;
  ShelfArea (
    {
      this.id,
      this.name,
      this.bookshelf,
      this.bookshelfID
    }
  );
  ShelfArea.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    bookshelf = json['bookshelf'] != null ? new Bookshelf.fromJson(json['bookshelf']) : null;
    bookshelfID = json['bookshelfID'];
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
      data['id'] = this.id;
      data['name'] = this.name;
    if(this.bookshelf != null) {
      data['bookshelf'] = this.bookshelf!.toJson();
    }
      data['bookshelfID'] = this.bookshelfID;
    return data;
  }
}
class Bookshelf {
  int? id;
  String? name;
  Bookshelf (
    {
      this.id,
      this.name
    }
  );
  Bookshelf.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      name = json['name'];
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
// class Account {
//   String? id;
//   String? username;
//   String? email;
//   String? phone;
//   String? fullName;
//   bool? isActive;
//   List<Roles>? roles;
//   Account ({
//     this.id,
//     this.username,
//     this.email,
//     this.phone,
//     this.fullName,
//     this.isActive,
//     this.roles

//   });
//       Account.fromJson(Map<String, dynamic> json) {
//         id = json['id'];
//         username = json['username'];
//         email = json['email'];
//         phone = json['phone'];
//         fullName = json['fullName'];
//         isActive = json['isActive'];
//       if (json['roles'] != null) {
//         roles = <Roles>[];
//       json['roles'].forEach((v) {
//         roles!.add(new Roles.fromJson(v));
//       });
//     }
//   }

//     Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['username'] = this.username;
//     data['email'] = this.email;
//     data['phone'] = this.phone;
//     data['fullName'] = this.fullName;
//     data['isActive'] = this.isActive;
//         if (this.roles != null) {
//       data['roles'] = this.roles!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
class Roles {
  int? id;
  String? name;
  List<Permissions>? permissions;

  Roles({
    this.id,
    this.name,
    this.permissions
  });

      Roles.fromJson(Map<String, dynamic> json) {
        id = json['id'];
        name = json['name'];
      if (json['permissions'] != null) {
        permissions = <Permissions>[];
      json['permissions'].forEach((v) {
        permissions!.add(new Permissions.fromJson(v));
      });
    }
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
        if (this.permissions != null) {
      data['permissions'] = this.permissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}
class Permissions {
  int? id;
  String? name;
  String? description;
  Permissions (
    {
      this.id,
      this.name,
      this.description
    }
  );
    Permissions.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      name = json['name'];
      description = json['description'];
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}
class Notes {
  String? type;
  String? content;
  Notes({
    this.type,
    this.content
  });

    Notes.fromJson(Map<String, dynamic> json) {
      type = json['type'];
      content = json['content'];
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['content'] = this.content;
    return data;
  }
}
