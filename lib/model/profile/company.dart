import 'package:flutter/cupertino.dart';

/// Defines company model
class Company {
  static const String COLLECTION_NAME = "company";

  /// Defines key values to extract from a map
  static const String SHOP_ID = "companyId";
  static const String USER_ID = "userId";
  static const String NAME = "name";
  static const String PRIMARY_PHONE = "primaryPhone";
  static const String SECONDARY_PHONE = "secondaryPhone";
  static const String EMAIL = "email";
  static const String RANK = "rank";
  static const String WEBSITE = "website";
  static const String PHYSICAL_ADDRESS = "physicalAddress";
  static const String CO_ORDINATES = "coOrdinates";
  static const String IS_VIRTUAL = "isVirtual";
  static const String IS_VERIFIED = "isVerified";
  static const String SUBSCRIPTION_PACKAGE = "subscriptionPackage";
  static const String DESCRIPTION = "description";
  static const String TOTAL_APPROVED_JOBS = "totalApprovedJobs";
  static const String TOTAL_DELETIONS = "totalDeletions";
  static const String TOTAL_NONE_JOB_POSTS = "totalNoneJobPosts";
  static const String TOTAL_JOBS = "totalJobs";
  static const String TOTAL_UPDATES = "totalUpdates";
  static const String TOTAL_POSTS = "totalPosts";
  static const String CATEGORY = "category";
  static const String LOGO = "logo";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String? companyId;
  String? userId;
  String? name;
  num? rank;

  String? primaryPhone;
  String? description;
  String? secondaryPhone;
  String? email;
  String? website;
  String? physicalAddress;
  List<dynamic>? coOrdinates;
  bool? isVirtual;
  bool? isVerified;
  String? subscriptionPackage;
  String? category;
  dynamic? logo;
  num? totalApprovedJobs;
  num? totalDeletions;
  num? totalNoneJobs;
  num? totalJobs;
  num? totalUpdates;
  num? totalPosts;
  DateTime? firstModified;
  DateTime? lastModified;

  Company(
      {this.companyId,
      this.userId,
      this.name,
      this.rank = 1,
      this.primaryPhone,
      this.secondaryPhone,
      this.email,
      this.website,
      this.physicalAddress,
      this.coOrdinates,
      this.isVirtual,
      this.isVerified,
      this.subscriptionPackage,
      this.description,
      this.category,
      this.totalApprovedJobs = 0,
      this.totalDeletions = 0,
      this.totalNoneJobs = 0,
      this.totalJobs = 0,
      this.totalUpdates = 0,
      this.totalPosts = 0,
      this.logo,
      this.firstModified,
      this.lastModified});

  /// Converts Model to Map
  static Map<String, dynamic> toMap(Company company) {
    return {
      SHOP_ID: company.companyId,
      USER_ID: company.userId,
      NAME: company.name,
      RANK: company.rank,
      PRIMARY_PHONE: company.primaryPhone,
      SECONDARY_PHONE: company.secondaryPhone,
      EMAIL: company.email,
      WEBSITE: company.website,
      PHYSICAL_ADDRESS: company.physicalAddress,
      CO_ORDINATES: company.coOrdinates,
      IS_VIRTUAL: company.isVirtual,
      IS_VERIFIED: company.isVerified,
      SUBSCRIPTION_PACKAGE: company.subscriptionPackage,
      DESCRIPTION: company.description,
      CATEGORY: company.category,
      LOGO: company.logo,
      TOTAL_APPROVED_JOBS: company.totalApprovedJobs,
      TOTAL_DELETIONS: company.totalDeletions,
      TOTAL_NONE_JOB_POSTS: company.totalNoneJobs,
      TOTAL_JOBS: company.totalJobs,
      TOTAL_UPDATES: company.totalUpdates,
      TOTAL_POSTS: company.totalPosts,
      FIRST_MODIFIED: company.firstModified == null
          ? null
          : company.lastModified!.toIso8601String(),
      LAST_MODIFIED:
          company.lastModified == null ? null : company.lastModified!.toIso8601String()
    };
  }

  /// Converts Map to Model
  static Company toModel(Map<String, dynamic> map) {

      return Company(
          companyId: map[SHOP_ID],
          userId: map[USER_ID],
          name: map[NAME],
          rank: map[RANK],
          primaryPhone: map[PRIMARY_PHONE],
          secondaryPhone: map[SECONDARY_PHONE],
          email: map[EMAIL],
          website: map[WEBSITE],
          physicalAddress: map[PHYSICAL_ADDRESS],
          coOrdinates: map[CO_ORDINATES],
          isVirtual: map[IS_VIRTUAL],
          isVerified: map[IS_VERIFIED],
          subscriptionPackage: map[SUBSCRIPTION_PACKAGE],
          description: map[DESCRIPTION],
          category: map[CATEGORY],
          logo: map[LOGO],
          totalApprovedJobs: map[TOTAL_APPROVED_JOBS],
          totalDeletions: map[TOTAL_DELETIONS],
          totalNoneJobs: map[TOTAL_NONE_JOB_POSTS],
          totalJobs: map[TOTAL_JOBS],
          totalUpdates: map[TOTAL_UPDATES],
          totalPosts: map[TOTAL_POSTS],
          firstModified: map[FIRST_MODIFIED] != null
              ? DateTime.parse(map[FIRST_MODIFIED])
              : null,
          lastModified: map[LAST_MODIFIED] != null
              ? DateTime.parse(map[LAST_MODIFIED])
              : null);

  }

  /// Changes List of Map to List of Model
  static List<Company> toModelList(List<dynamic> maps) {
    List<Company> modelList = [];
    maps.forEach((dynamic map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<Company> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((Company model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}
