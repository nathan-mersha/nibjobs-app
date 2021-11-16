/// Defines company model
class Ad {
  static const String COLLECTION_NAME = "company";

  /// Defines key values to extract from a map
  static const String IMAGE = "image";
  static const String SHOP = "company";
  static const String JOB = "job";
  static const String lINK = "link";
  static const String CONTACTUS = "contactUs";

  String? image;
  String? company;
  String? job;
  String? link;
  bool? contactUs;

  Ad({
    this.image,
    this.company = "",
    this.job = "",
    this.link = "",
    this.contactUs = false,
  });

  /// Converts Model to Map
  static Map<String, dynamic> toMap(Ad company) {
    return {
      IMAGE: company.image,
      SHOP: company.company ?? "",
      JOB: company.job ?? "",
      lINK: company.link ?? "",
      CONTACTUS: company.contactUs ?? false,
    };
  }

  /// Converts Map to Model
  static Ad toModel(Map<String, dynamic> map) {

      return Ad(
        image: map[IMAGE],
        company: map[SHOP] ?? "",
        job: map[JOB] ?? "",
        link: map[lINK] ?? "",
        contactUs: map[CONTACTUS] ?? false,
      );

  }

  /// Changes List of Map to List of Model
  static List<Ad> toModelList(List<dynamic> maps) {
    List<Ad> modelList = [];
    for (var map in maps) {
      modelList.add(toModel(map));
    }
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<Ad> models) {
    List<Map<String, dynamic>> mapList = [];
    for (var model in models) {
      mapList.add(toMap(model));
    }
    return mapList;
  }
}
