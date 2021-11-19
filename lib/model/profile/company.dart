/// Defines company model
class Company {
  static const String COLLECTION_NAME = "company";
  static const String ID = "id";
  static const String USER_ID = "userId";
  static const String NAME = "name";
  static const String RANK = "rank";
  static const String CATEGORY = "category";
  static const String PRIMARY_PHONE = "primaryPhone";
  static const String SECONDARY_PHONE = "secondaryPhone";
  static const String EMAIL = "email";
  static const String VERIFIED = "verified";
  static const String WEBSITE = "website";
  static const String PHYSICAL_ADDRESS = "physicalAddress";
  static const String NO_OF_EMPLOYEES = "noOfEmployees";
  static const String DESCRIPRTION = "description";
  static const String LOGO = "logo";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String? id;
  String? userId;
  String? name;
  num? rank;
  String? category;

  String? primaryPhone;
  String? secondaryPhone;
  String? email;
  bool? verified;
  String? website;
  String? physicalAddress;
  String? noOfEmployees;
  String? description;
  String? logo;
  DateTime? firstModified;
  DateTime? lastModified;

  Company(
      {this.id,
      this.userId,
      this.name,
      this.rank,
      this.category,
      this.primaryPhone,
      this.secondaryPhone,
      this.email,
      this.verified,
      this.website,
      this.physicalAddress,
      this.noOfEmployees,
      this.description,
      this.logo,
      this.firstModified,
      this.lastModified});

  /// Converts Model to Map
  static Map<String, dynamic> toMap(Company company) {
    return {
      ID: company.id,
      USER_ID: company.userId,
      NAME: company.name,
      RANK: company.rank,
      CATEGORY: company.category,
      PRIMARY_PHONE: company.primaryPhone,
      SECONDARY_PHONE: company.secondaryPhone,
      EMAIL: company.email,
      VERIFIED: company.verified,
      WEBSITE: company.website,
      PHYSICAL_ADDRESS: company.physicalAddress,
      NO_OF_EMPLOYEES: company.noOfEmployees,
      DESCRIPRTION: company.description,
      LOGO: company.logo,
      FIRST_MODIFIED: company.firstModified == null
          ? null
          : company.lastModified!.toIso8601String(),
      LAST_MODIFIED: company.lastModified == null
          ? null
          : company.lastModified!.toIso8601String()
    };
  }

  /// Converts Map to Model
  static Company toModel(Map<String, dynamic> map) {
    return Company(
        id: map[ID],
        userId: map[USER_ID],
        name: map[NAME],
        rank: map[RANK],
        category: map[CATEGORY],
        primaryPhone: map[PRIMARY_PHONE],
        secondaryPhone: map[SECONDARY_PHONE],
        email: map[EMAIL],
        verified: map[VERIFIED],
        website: map[WEBSITE],
        physicalAddress: map[PHYSICAL_ADDRESS],
        noOfEmployees: map[NO_OF_EMPLOYEES],
        description: map[DESCRIPRTION],
        logo: map[LOGO],
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
    for (var map in maps) {
      modelList.add(toModel(map));
    }
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<Company> models) {
    List<Map<String, dynamic>> mapList = [];
    for (var model in models) {
      mapList.add(toMap(model));
    }
    return mapList;
  }
}
