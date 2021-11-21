import 'package:nibjobs/model/profile/company.dart';
import 'package:nibjobs/model/profile/user.dart';

import 'job_channel.dart';

/// Defines job model
class Job {
  /// Defines key values to extract from a map

  static const String COLLECTION_NAME = "job";
  static const String ID = "id";

  static const String TITLE = "title";
  static const String CATEGORY = "category";
  static const String STATUS = "status";
  static const String CONTRACT_TYPE = "contract_type";
  static const String SALARY = "salary";
  static const String AVAILABLE_POSITIONS = "available_positions";
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

  String? id;
  String? title;
  String? status;
  String? category;
  String? contractType;
  String? salary;
  num? availablePositions;
  List<dynamic>? tags;
  String? description;
  String? applyVia;
  String? applyLink;
  Company? company;
  JobChannel? jobChannel;
  bool? approved;
  bool? deleted;
  String? rawPost;
  DateTime? firstModified;
  DateTime? lastModified;

  Job(
      {this.id,
      this.title,
      this.status = "opened",
      this.category,
      this.contractType = "",
      this.salary,
      this.availablePositions = 1,
      this.tags,
      this.description,
      this.applyVia,
      this.applyLink,
      this.company,
      this.jobChannel,
      this.approved,
      this.deleted,
      this.rawPost,
      this.firstModified,
      this.lastModified});

  /// Converts Model to Map
  static Map<String, dynamic> toMap(Job job) {
    return {
      ID: job.id,
      TITLE: job.title,
      STATUS: job.status,
      CATEGORY: job.category,
      CONTRACT_TYPE: job.contractType,
      SALARY: job.salary,
      AVAILABLE_POSITIONS: job.availablePositions ?? 1,
      TAGS: job.tags,
      DESCRIPTION: job.description,
      APPLY_VIA: job.applyVia,
      APPLY_LINK: job.applyLink,
      COMPANY: job.company,
      JOB_CHANNEL: job.jobChannel,
      APPROVED: job.approved,
      DELETED: job.deleted,
      RAW_POST: job.rawPost,
      FIRST_MODIFIED: job.firstModified == null
          ? null
          : job.firstModified!.toIso8601String(),
      LAST_MODIFIED:
          job.lastModified == null ? null : job.lastModified!.toIso8601String()
    };
  }

  /// Converts Map to Model
  static Job toModel(dynamic map) {
    return Job(
        id: map[ID],
        title: map[TITLE],
        status: map[STATUS] ?? "opened",
        category: map[CATEGORY],
        contractType: map[CONTRACT_TYPE] ?? "unavailable",
        salary: map[SALARY],
        availablePositions: map[AVAILABLE_POSITIONS],
        tags: map[TAGS],
        description: map[DESCRIPTION],
        applyVia: map[APPLY_VIA],
        applyLink: map[APPLY_LINK],
        jobChannel: map[JOB_CHANNEL] == null
            ? JobChannel()
            : JobChannel.toModel(map[JOB_CHANNEL]),
        approved: map[APPROVED],
        deleted: map[DELETED],
        rawPost: map[RAW_POST],
        company:
            map[COMPANY] == null ? Company() : Company.toModel(map[COMPANY]),
        firstModified: DateTime.parse(
            map[FIRST_MODIFIED] ?? DateTime.now().toIso8601String()),
        lastModified: DateTime.parse(
            map[LAST_MODIFIED] ?? DateTime.now().toIso8601String()));
  }

  /// Changes List of Map to List of Model
  static List<Job> toModelList(List<dynamic> maps) {
    List<Job> modelList = [];
    for (var map in maps) {
      modelList.add(toModel(map));
    }
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<Job> models) {
    List<Map<String, dynamic>> mapList = [];
    for (var model in models) {
      mapList.add(toMap(model));
    }
    return mapList;
  }
}

class CalledJob {
  static const String COLLECTION_NAME = "job";

  static const String JOB = "job";
  static const String USER = "user";
  static const String LAST_MODIFIED = "lastModified";
  Job? job;
  UserModel? user;
  DateTime? lastModified;
  CalledJob({this.job, this.user, this.lastModified});

  /// Converts Model to Map
  static Map<String, dynamic> toMap(CalledJob calledJob) {
    return {
      JOB: Job.toMap(calledJob.job!),
      USER: UserModel.toMap(calledJob.user!),
      LAST_MODIFIED: DateTime.now().toIso8601String(),
    };
  }

  /// Converts Map to Model
  static CalledJob toModel(dynamic map) {
    return CalledJob(
        job: Job.toModel(map[JOB]),
        user: UserModel.toModel(map[USER]),
        lastModified: DateTime.parse(
            map[LAST_MODIFIED] ?? DateTime.now().toIso8601String()));
  }

  /// Changes List of Map to List of Model
  static List<CalledJob> toModelList(List<dynamic> maps) {
    List<CalledJob> modelList = [];
    for (var map in maps) {
      modelList.add(toModel(map));
    }
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<CalledJob> models) {
    List<Map<String, dynamic>> mapList = [];
    for (var model in models) {
      mapList.add(toMap(model));
    }
    return mapList;
  }
}
