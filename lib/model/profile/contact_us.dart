import 'package:nibjobs/model/commerce/transaction.dart';

/// Defines top level user model
class ContactUsModel {
  static const String COLLECTION_NAME = "contactUs";

  static const String ID = "id";
  static const String FROM = "from";
  static const String TITLE = "title";
  static const String BODY = "body";
  static const String RESOLVED = "resolved";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String? id;
  String? from;
  String? title;
  String? body;
  bool? resolved;
  DateTime? firstModified;
  DateTime? lastModified;

  ContactUsModel(
      {this.id,
      this.from,
      this.title,
      this.body,
      this.resolved,
      this.firstModified,
      this.lastModified});

  /// Converts ContactUsModel to Map
  static Map<String, dynamic> toMap(ContactUsModel user) {
    return {
      ID: user.id,
      FROM: user.from,
      TITLE: user.title,
      BODY: user.body,
      RESOLVED: user.resolved,
      FIRST_MODIFIED: user.firstModified!.toIso8601String(),
      LAST_MODIFIED: user.lastModified!.toIso8601String(),
    };
  }

  /// Converts Map to ContactUsModel
  static ContactUsModel toModel(dynamic map) {
    return ContactUsModel(
        id: map[ID],
        from: map[FROM],
        title: map[TITLE],
        body: map[BODY],
        resolved: map[RESOLVED],
        firstModified: map[FIRST_MODIFIED],
        lastModified: map[LAST_MODIFIED]);
  }

  /// Changes List of Map to List of Model
  static List<ContactUsModel> toModelList(List<dynamic> maps) {
    List<ContactUsModel> modelList = [];
    maps.forEach((dynamic map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<ContactUsModel> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((ContactUsModel model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}
