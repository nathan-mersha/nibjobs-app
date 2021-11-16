import 'package:nibjobs/model/profile/company.dart';

/// Defines ratingCompany model [RatingCompany]

class RatingCompany {
  static const String COLLECTION_NAME = "companyRating";

  /// Defines key values to extract from a map
  static const String RATING_SHOP_ID = "ratingCompanyId";
  static const String SHOP = "company";
  static const String CUMULATIVE = "cumulative";
  static const String RELIABILITY_RATE = "reliabilityRate";
  static const String DELIVERABLE_RATE = "deliverableRate";
  static const String SUPPORT_RATE = "supportRate";
  static const String RICHNESS_RATE = "richnessRate";
  static const String PRICING_RATE = "pricingRate";
  static const String ACTIVITY_RATE = "activityRate";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String? ratingCompanyId;
  Company? company;
  num? cumulative;
  num? reliabilityRate;
  num? deliverableRate;
  num? supportRate;
  num? richnessRate;
  num? pricingRate;
  num? activityRate;
  DateTime? firstModified;
  DateTime? lastModified;

  RatingCompany(
      {this.ratingCompanyId,
      this.company,
      this.cumulative,
      this.reliabilityRate,
      this.deliverableRate,
      this.supportRate,
      this.richnessRate,
      this.pricingRate,
      this.activityRate,
      this.firstModified,
      this.lastModified});

  /// Converts Model to Map
  static Map<String, dynamic> toMap(RatingCompany ratingCompany) {
    return {
      RATING_SHOP_ID: ratingCompany.ratingCompanyId,
      SHOP: ratingCompany.company == null
          ? null
          : Company.toMap(ratingCompany.company!),
      CUMULATIVE: ratingCompany.cumulative,
      RELIABILITY_RATE: ratingCompany.reliabilityRate,
      DELIVERABLE_RATE: ratingCompany.deliverableRate,
      SUPPORT_RATE: ratingCompany.supportRate,
      RICHNESS_RATE: ratingCompany.richnessRate,
      PRICING_RATE: ratingCompany.pricingRate,
      ACTIVITY_RATE: ratingCompany.activityRate,
      FIRST_MODIFIED: ratingCompany.firstModified,
      LAST_MODIFIED: ratingCompany.lastModified
    };
  }

  /// Converts Map to Model
  static RatingCompany toModel(dynamic map) {
    return RatingCompany(
        ratingCompanyId: map[RATING_SHOP_ID],
        company: map[SHOP] == null ? Company() : Company.toModel(map[SHOP]),
        cumulative: map[CUMULATIVE],
        reliabilityRate: map[RELIABILITY_RATE],
        deliverableRate: map[DELIVERABLE_RATE],
        supportRate: map[SUPPORT_RATE],
        richnessRate: map[RICHNESS_RATE],
        pricingRate: map[PRICING_RATE],
        activityRate: map[ACTIVITY_RATE],
        firstModified: map[FIRST_MODIFIED],
        lastModified: map[LAST_MODIFIED]);
  }

  /// Changes List of Map to List of Model
  static List<RatingCompany> toModelList(List<dynamic> maps) {
    List<RatingCompany> modelList = [];
    maps.forEach((dynamic map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<RatingCompany> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((RatingCompany model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}
