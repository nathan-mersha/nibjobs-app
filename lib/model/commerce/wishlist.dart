import 'package:nibjobs/model/profile/user.dart';

/// Defines wishList model
class WishList {
  static const String COLLECTION_NAME = "wishList";

  /// Defines key values to extract from a map
  static const String WISH_LIST_ID = "wishListId";
  static const String USER = "user";
  static const String WISHES = "wishes";
  static const String VISIBILITY = "visibility";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String? wishListId;
  UserModel? user;
  List<Wish>? wishes;
  bool? visibility;
  DateTime? firstModified;
  DateTime? lastModified;

  WishList(
      {this.wishListId,
      this.user,
      this.wishes,
      this.visibility,
      this.firstModified,
      this.lastModified});

  /// Converts Model to Map
  static Map<String, dynamic> toMap(WishList wishList) {
    return {
      WISH_LIST_ID: wishList.wishListId,
      USER: wishList.user == null ? null : UserModel.toMap(wishList.user!),
      WISHES: wishList.wishes == null ? null : Wish.toMapList(wishList.wishes!),
      VISIBILITY: wishList.visibility,
      FIRST_MODIFIED: wishList.firstModified,
      LAST_MODIFIED: wishList.lastModified
    };
  }

  /// Converts Map to Model
  static WishList toModel(dynamic map) {
    return WishList(
        wishListId: map[WISH_LIST_ID],
        user: map[USER] == null ? UserModel() : UserModel.toModel(map[USER]),
        wishes: map[WISHES] == null ? [] : Wish.toModelList(map[WISHES]),
        visibility: map[VISIBILITY],
        firstModified: map[FIRST_MODIFIED],
        lastModified: map[LAST_MODIFIED]);
  }

  /// Changes List of Map to List of Model
  static List<WishList> toModelList(List<dynamic> maps) {
    List<WishList> modelList = [];
    maps.forEach((dynamic map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<WishList> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((WishList model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}

/// Defines wish model
class Wish {
  static const String WISH_ID = "wishId";
  static const String JOB_ID = "jobId";
  static const String STATUS = "status";
  static const String FULFILLED_BY = "fulfilledBy";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String? wishId;
  String? jobId;
  String? status;
  String? fulfilledBy;
  DateTime? firstModified;
  DateTime? lastModified;

  Wish(
      {this.wishId,
      this.jobId,
      this.status,
      this.fulfilledBy,
      this.firstModified,
      this.lastModified});

  /// Converts Model to Map
  static Map<String, dynamic> toMap(Wish wishList) {
    return {
      WISH_ID: wishList.wishId,
      JOB_ID: wishList.jobId,
      STATUS: wishList.status,
      FULFILLED_BY: wishList.fulfilledBy,
      FIRST_MODIFIED: wishList.firstModified,
      LAST_MODIFIED: wishList.lastModified
    };
  }

  /// Converts Map to Model
  static Wish toModel(dynamic map) {
    return Wish(
        wishId: map[WISH_ID],
        jobId: map[JOB_ID],
        status: map[STATUS],
        fulfilledBy: map[FULFILLED_BY],
        firstModified: map[FIRST_MODIFIED],
        lastModified: map[LAST_MODIFIED]);
  }

  /// Changes List of Map to List of Model
  static List<Wish> toModelList(List<dynamic> maps) {
    List<Wish> modelList = [];
    maps.forEach((dynamic map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<Wish> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((Wish model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}
