/// Defines feedback model
class Feedback {
  static const String COLLECTION_NAME = "feedBack";

  /// Defines key values to extract from a map
  static const String FEEDBACK_ID = "feedbackId";
  static const String USER_ID = "userId";
  static const String TITLE = "title";
  static const String MESSAGE = "message";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String? feedbackId;
  String? userId;
  String? title;
  String? message;
  DateTime? firstModified;
  DateTime? lastModified;

  Feedback({this.feedbackId, this.userId, this.title, this.message, this.firstModified, this.lastModified});

  /// Converts Model to Map
  static Map<String, dynamic> toMap(Feedback feedback) {
    return {
      FEEDBACK_ID: feedback.feedbackId,
      USER_ID: feedback.userId,
      TITLE: feedback.title,
      MESSAGE: feedback.message,
      FIRST_MODIFIED: feedback.firstModified,
      LAST_MODIFIED: feedback.lastModified
    };
  }

  /// Converts Map to Model
  static Feedback toModel(dynamic map) {
    return Feedback(
        feedbackId: map[FEEDBACK_ID],
        userId: map[USER_ID],
        title: map[TITLE],
        message: map[MESSAGE],
        firstModified: map[FIRST_MODIFIED],
        lastModified: map[LAST_MODIFIED]);
  }

  /// Changes List of Map to List of Model
  static List<Feedback> toModelList(List<dynamic> maps) {
    List<Feedback> modelList = [];
    maps.forEach((dynamic map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<Feedback> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((Feedback model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}
