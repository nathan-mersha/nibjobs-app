class JobChannel {
  /// Defines key values to extract from a map

  static const String COLLECTION_NAME = "jobChannel";
  static const String ID = "id";
  static const String CHANNEL_ID = "channel_id";
  static const String NAME = "name";
  static const String RANK = "rank";
  static const String DESCRIPTION = "description";
  static const String LOGO = "logo";
  static const String LINK = "link";
  static const String FIRST_MODIFIED = "first_modified";
  static const String LAST_MODIFIED = "last_modified";

  String? id;
  String? channelId;
  String? name;
  num? rank;
  String? description;
  String? logo;
  DateTime? firstModified;
  DateTime? lastModified;

  JobChannel(
      {this.id,
      this.channelId,
      this.name,
      this.rank,
      this.description,
      this.logo,
      this.firstModified,
      this.lastModified});

  /// Converts Model to Map
  static Map<String, dynamic> toMap(JobChannel jobChannel) {
    return {
      ID: jobChannel.id,
      CHANNEL_ID: jobChannel.channelId,
      NAME: jobChannel.name,
      RANK: jobChannel.rank,
      DESCRIPTION: jobChannel.description,
      LOGO: jobChannel.logo,
      FIRST_MODIFIED: jobChannel.firstModified == null
          ? null
          : jobChannel.firstModified!.toIso8601String(),
      LAST_MODIFIED: jobChannel.lastModified == null
          ? null
          : jobChannel.lastModified!.toIso8601String()
    };
  }

  /// Converts Map to Model
  static JobChannel toModel(dynamic map) {
    return JobChannel(
        id: map[ID],
        channelId: map[CHANNEL_ID],
        name: map[NAME],
        rank: map[RANK],
        description: map[DESCRIPTION],
        logo: map[LOGO],
        firstModified: DateTime.parse(
            map[FIRST_MODIFIED] ?? DateTime.now().toIso8601String()),
        lastModified: DateTime.parse(
            map[LAST_MODIFIED] ?? DateTime.now().toIso8601String()));
  }

  /// Changes List of Map to List of Model
  static List<JobChannel> toModelList(List<dynamic> maps) {
    List<JobChannel> modelList = [];
    for (var map in maps) {
      modelList.add(toModel(map));
    }
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<JobChannel> models) {
    List<Map<String, dynamic>> mapList = [];
    for (var model in models) {
      mapList.add(toMap(model));
    }
    return mapList;
  }
}
