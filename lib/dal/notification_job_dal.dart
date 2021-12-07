import 'package:nibjobs/model/commerce/job.dart';
import 'package:nibjobs/model/notification_job_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotificationJobDAL {
  static const String TABLE_NAME = "notificationsJob";
  static const String DB_NAME = "hisab_database.db";

  static const String COLLECTION_NAME = "job";
  static const String ID = "id";

  static const String TITLE = "title";
  static const String CATEGORY = "category";
  static const String STATUS = "status";
  static const String CONTRACT_TYPE = "contractType";
  static const String SALARY = "salary";
  static const String AVAILABLE_POSITIONS = "availablePositions";
  static const String TAGS = "tags";
  static const String DESCRIPTION = "description";
  static const String APPLY_VIA = "applyVia";
  static const String APPLY_LINK = "applyLink";
  static const String COMPANY = "company";
  static const String JOB_CHANNEL = "jobChannel";
  static const String APPROVED = "approved";
  static const String DELETED = "deleted";
  static const String RAW_POST = "rawPost";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  static String createTable =
      "CREATE TABLE $TABLE_NAME($ID TEXT PRIMARY KEY, $TITLE TEXT, $CATEGORY TEXT, $STATUS TEXT, $CONTRACT_TYPE TEXT,$SALARY TEXT, $AVAILABLE_POSITIONS TEXT,$TAGS TEXT,$DESCRIPTION TEXT,$APPLY_VIA TEXT,$APPLY_LINK TEXT,$COMPANY TEXT,$JOB_CHANNEL TEXT,$APPROVED TEXT,$DELETED TEXT,$RAW_POST TEXT,$FIRST_MODIFIED TEXT,$LAST_MODIFIED TEXT)";

  static Future<Database> createDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), DB_NAME),
      onCreate: (db, version) {
        return db.execute(createTable);
      },
      version: 1,
    );
    return database;
  }

  static Future<void> create(NotificationJobModel notification) async {
    // Get a reference to the database.
    final Database db = await createDatabase();

    // List<Job> list = await NotificationJobDAL.find();
    //if (list.length >= 10) {
    //   Job notificationModel = list.last;
    // await NotificationJobDAL.delete(ID, notificationModel.id);
    // }

    await db.insert(
      TABLE_NAME,
      NotificationJobModel.toMapDb(notification),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// where : "id = ?"
  /// whereArgs : [2]
  static Future<List<Job>> find({String? where, dynamic whereArgs}) async {
    final Database db = await createDatabase();

    final List<Map<String, dynamic>> maps = where == null
        ? await db.query(
            TABLE_NAME,
            orderBy: "$ID DESC",
          )
        : await db.query(TABLE_NAME, where: where, whereArgs: whereArgs);

    return List.generate(maps.length, (i) {
      return Job.toModelDB(maps[i]);
    });
  }

  /// where : "id = ?"
  /// whereArgs : [2]
  static Future<void> update(
      {String? where,
      dynamic whereArgs,
      NotificationJobModel? updateData}) async {
    final Database db = await createDatabase();

    await db.update(TABLE_NAME, NotificationJobModel.toMapDb(updateData!),
        where: where, whereArgs: whereArgs);
  }

  /// where : "id = ?"
  /// whereArgs : [2]
  static Future<void> delete(String where, dynamic whereArgs) async {
    final Database db = await createDatabase();

    await db.delete(
      TABLE_NAME,
      where: where,
      whereArgs: whereArgs,
    );
  }
}
