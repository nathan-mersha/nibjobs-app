import 'package:nibjobs/model/profile/company.dart';

/// Defines coupon model [Coupon]

class Coupon {
  static const String COLLECTION_NAME = "coupon";

  /// Defines key values to extract from a map
  static const String COUPON_ID = "couponId";
  static const String NAME = "name";
  static const String QUANTITY = "quantity";
  static const String EXPIRATION_DATE = "expirationDate";
  static const String CODE = "code";
  static const String DESCRIPTION = "description";
  static const String SHOP = "company"; // Coupon issuer company
  static const String REVOKED = "revoked"; // Coupon issuer company
  static const String DISCOUNT_TYPE = "discountType";
  static const String DISCOUNT_VALUE = "discountValue";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String? couponId;
  String? name;
  num? quantity;
  DateTime? expirationDate;
  String? code;
  String? description;
  Company? company;
  bool? revoked;
  String? discountType; // todo : make enum
  num? discountValue;
  DateTime? firstModified;
  DateTime? lastModified;

  Coupon(
      {this.couponId,
      this.name,
      this.quantity,
      this.expirationDate,
      this.code,
      this.description,
      this.company,
      this.revoked,
      this.discountType,
      this.discountValue,
      this.firstModified,
      this.lastModified});

  /// Converts Model to Map
  static Map<String, dynamic> toMap(Coupon coupon) {
    return {
      COUPON_ID: coupon.couponId,
      NAME: coupon.name,
      QUANTITY: coupon.quantity,
      EXPIRATION_DATE: coupon.expirationDate,
      CODE: coupon.code,
      DESCRIPTION: coupon.description,
      SHOP: coupon.company == null ? null : Company.toMap(coupon.company!),
      REVOKED: coupon.revoked,
      DISCOUNT_TYPE: coupon.discountType,
      DISCOUNT_VALUE: coupon.discountValue,
      FIRST_MODIFIED: coupon.firstModified,
      LAST_MODIFIED: coupon.lastModified
    };
  }

  /// Converts Map to Model
  static Coupon toModel(dynamic map) {
    return Coupon(
        couponId: map[COUPON_ID],
        name: map[NAME],
        quantity: map[QUANTITY],
        expirationDate: map[EXPIRATION_DATE],
        code: map[CODE],
        description: map[DESCRIPTION],
        company: map[SHOP] == null ? Company() : Company.toModel(map[SHOP]),
        revoked: map[REVOKED],
        discountType: map[DISCOUNT_TYPE],
        discountValue: map[DISCOUNT_VALUE],
        firstModified: map[FIRST_MODIFIED],
        lastModified: map[LAST_MODIFIED]);
  }

  /// Changes List of Map to List of Model
  static List<Coupon> toModelList(List<dynamic> maps) {
    List<Coupon> modelList = [];
    maps.forEach((dynamic map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<Coupon> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((Coupon model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}
