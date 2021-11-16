/// Defines versionAndUpdate model [VersionAndUpdate]
class VersionAndUpdate {
  static const String COLLECTION_NAME = "versionAndUpdate";

  /// Defines key values to extract from a map
  static const String VERSION_AND_UPDATE_ID = "versionAndUpdateId";
  static const String VALUES = "values";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String? versionAndUpdateId;
  List<VersionAndUpdateValue>? values;
  DateTime? firstModified;
  DateTime? lastModified;

  VersionAndUpdate({this.versionAndUpdateId, this.values, this.firstModified, this.lastModified});

  /// Converts Model to Map
  static Map<String, dynamic> toMap(VersionAndUpdate versionAndUpdate) {
    return {
      VERSION_AND_UPDATE_ID: versionAndUpdate.versionAndUpdateId,
      VALUES: versionAndUpdate.values == null ? [] : VersionAndUpdateValue.toMapList(versionAndUpdate.values!),
      FIRST_MODIFIED: versionAndUpdate.firstModified,
      LAST_MODIFIED: versionAndUpdate.lastModified
    };
  }

  /// Converts Map to Model
  static VersionAndUpdate toModel(dynamic map) {
    return VersionAndUpdate(
        versionAndUpdateId: map[VERSION_AND_UPDATE_ID],
        values: map[VALUES] == null ? [] : VersionAndUpdateValue.toModelList(map[VALUES]),
        firstModified: map[FIRST_MODIFIED],
        lastModified: map[LAST_MODIFIED]);
  }

  /// Changes List of Map to List of Model
  static List<VersionAndUpdate> toModelList(List<dynamic> maps) {
    List<VersionAndUpdate> modelList = [];
    maps.forEach((dynamic map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<VersionAndUpdate> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((VersionAndUpdate model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}

/// Defines versionAndUpdateValues model [VersionAndUpdateValue]
class VersionAndUpdateValue {
  /// Defines key values to extract from a map
  static const String VERSION_AND_UPDATE_VALUE_ID = "versionAndUpdateValueId";
  static const String LOCALE = "locale";
  static const String DESCRIPTION = "description";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String? versionAndUpdateValueId;
  String? locale; // todo : make enum
  String ?description;
  DateTime? firstModified;
  DateTime? lastModified;

  VersionAndUpdateValue({this.versionAndUpdateValueId, this.locale, this.description, this.firstModified, this.lastModified});

  /// Converts Model to Map
  static Map<String, dynamic> toMap(VersionAndUpdateValue versionAndUpdateValues) {
    return {
      VERSION_AND_UPDATE_VALUE_ID: versionAndUpdateValues.versionAndUpdateValueId,
      LOCALE: versionAndUpdateValues.locale,
      DESCRIPTION: versionAndUpdateValues.description,
      FIRST_MODIFIED: versionAndUpdateValues.firstModified,
      LAST_MODIFIED: versionAndUpdateValues.lastModified
    };
  }

  /// Converts Map to Model
  static VersionAndUpdateValue toModel(dynamic map) {
    return VersionAndUpdateValue(
        versionAndUpdateValueId: map[VERSION_AND_UPDATE_VALUE_ID],
        locale: map[LOCALE],
        description: map[DESCRIPTION],
        firstModified: map[FIRST_MODIFIED],
        lastModified: map[LAST_MODIFIED]);
  }

  /// Changes List of Map to List of Model
  static List<VersionAndUpdateValue> toModelList(List<dynamic> maps) {
    List<VersionAndUpdateValue> modelList = [];
    maps.forEach((dynamic map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<VersionAndUpdateValue> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((VersionAndUpdateValue model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}
