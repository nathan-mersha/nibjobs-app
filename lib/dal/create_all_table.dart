import 'package:nibjobs/dal/notification_dal.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'notification_job_dal.dart';

class CreateAllDAL {
  static const String DB_NAME = "hisab_database.db";

  static Future<Database> createDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), DB_NAME),
      onCreate: (db, version) async {
        await db.execute(NotificationJobDAL.createTable);
        return db.execute(NotificationDAL.createTable);
      },
      version: 1,
    );

    return database;
  }
}
