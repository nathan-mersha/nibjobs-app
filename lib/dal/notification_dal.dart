import 'package:nibjobs/model/notification_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotificationDAL {
  static const String TABLE_NAME = "notifications";
  static const String DB_NAME = "hisab_database.db";
  static const String ID = "id";
  static const String NOTIFICATION_SERVICE_NAME = "notification_service_name";
  static const String NOTIFICATION_SERVICE_MESSAGE =
      "notification_service_message";
  static const String NOTIFICATION_SERVICE_AMOUNT =
      "notification_service_amount";
  static const String NOTIFICATION_TYPE = "notification_type";
  static const String NOTIFICATION_SERVICE_DATE = "notification_service_date";
  static const String NOTIFICATION_SERVICE_PAYMENT_METHOD_NAME =
      "notification_service_payment_method_name";
  static String createTable =
      "CREATE TABLE $TABLE_NAME($ID TEXT PRIMARY KEY, $NOTIFICATION_SERVICE_NAME TEXT, $NOTIFICATION_SERVICE_MESSAGE TEXT, $NOTIFICATION_SERVICE_AMOUNT TEXT, $NOTIFICATION_TYPE TEXT, $NOTIFICATION_SERVICE_DATE TEXT, $NOTIFICATION_SERVICE_PAYMENT_METHOD_NAME TEXT)";

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

  static Future<void> create(NotificationModel notification) async {
    // Get a reference to the database.
    final Database db = await createDatabase();

    List<NotificationModel> list = await NotificationDAL.find();
    if (list.length >= 10) {
      NotificationModel notificationModel = list.last;
      await NotificationDAL.delete(ID, notificationModel.id);
    }

    await db.insert(
      TABLE_NAME,
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// where : "id = ?"
  /// whereArgs : [2]
  static Future<List<NotificationModel>> find(
      {String? where, dynamic whereArgs}) async {
    final Database db = await createDatabase();

    final List<Map<String, dynamic>> maps = where == null
        ? await db.query(
            TABLE_NAME,
            orderBy: "$ID DESC",
          )
        : await db.query(TABLE_NAME, where: where, whereArgs: whereArgs);
    if (maps.isEmpty) {
      return [];
    }
    return List.generate(maps.length, (i) {
      return NotificationModel(
          id: maps[i][ID],
          notificationServiceName: maps[i][NOTIFICATION_SERVICE_NAME],
          notificationServiceMessage: maps[i][NOTIFICATION_SERVICE_MESSAGE],
          notificationServiceAmount: maps[i][NOTIFICATION_SERVICE_AMOUNT],
          notificationServiceDate: maps[i][NOTIFICATION_SERVICE_DATE],
          notificationType: maps[i][NOTIFICATION_TYPE],
          notificationServicePaymentMethodName: maps[i]
              [NOTIFICATION_SERVICE_PAYMENT_METHOD_NAME]);
    });
  }

  /// where : "id = ?"
  /// whereArgs : [2]
  static Future<void> update(
      {String? where, dynamic whereArgs, NotificationModel? updateData}) async {
    final Database db = await createDatabase();

    await db.update(TABLE_NAME, updateData!.toMap(),
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
