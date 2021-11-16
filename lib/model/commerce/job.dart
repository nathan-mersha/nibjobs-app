import 'package:nibjobs/model/profile/company.dart';
import 'package:nibjobs/model/profile/user.dart';

/// Defines job model
class Job {
  /// Defines key values to extract from a map

  static const String COLLECTION_NAME = "job";

  static const String JOB_ID = "jobId";
  static const String NAME = "name";
  static const String CATEGORY = "category";
  static const String SUB_CATEGORY = "subCategory";
  static const String AUTHOR_OR_MANUFACTURER = "authorOrManufacturer";
  static const String PRICE = "price";
  static const String REGULAR_PRICE = "regularPrice";
  static const String TAG = "tag";
  static const String RANK = "rank";
  static const String APPROVED = "approved";
  static const String QUANTITY = "quantity";
  static const String DESCRIPTION = "description";
  static const String RATING = "rating";
  static const String REFERENCE = "reference";
  static const String AVAILABLE_STOCK = "availableStock";
  static const String IMAGE = "image";
  static const String DELIVERABLE = "deliverable";
  static const String META_DATA = "metaData";
  static const String PUBLISHED_STATUS = "publishedStatus";
  static const String SHOP = "company";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String? jobId;
  String? name;
  String? category;
  bool? approved;
  String? subCategory;
  num? rank;
  String? authorOrManufacturer;
  num? price;
  num? regularPrice;
  List<dynamic>? tag;
  String? description;
  String? quantity;
  num? rating;
  String? reference;
  num? availableStock;
  List? image;
  bool? deliverable;
  dynamic? metaData;
  String? publishedStatus;
  Company? company;
  DateTime? firstModified;
  DateTime? lastModified;

  Job(
      {this.jobId,
      this.name,
      this.category,
      this.subCategory,
      this.authorOrManufacturer,
      this.price,
      this.rank = 1,
      this.regularPrice,
      this.tag,
      this.approved = false,
      this.quantity = "1",
      this.description,
      this.rating,
      this.reference,
      this.availableStock,
      this.image,
      this.deliverable,
      this.metaData,
      this.publishedStatus,
      this.company,
      this.firstModified,
      this.lastModified});

  /// Converts Model to Map
  static Map<String, dynamic> toMap(Job job) {
    return {
      JOB_ID: job.jobId,
      NAME: job.name,
      CATEGORY: job.category,
      RANK: job.rank,
      SUB_CATEGORY: job.subCategory,
      AUTHOR_OR_MANUFACTURER: job.authorOrManufacturer,
      PRICE: job.price,
      REGULAR_PRICE: job.regularPrice,
      TAG: job.tag,
      APPROVED: job.approved,
      DESCRIPTION: job.description,
      RATING: job.rating,
      REFERENCE: job.reference,
      AVAILABLE_STOCK: job.availableStock,
      IMAGE: job.image,
      DELIVERABLE: job.deliverable,
      META_DATA: job.metaData,
      PUBLISHED_STATUS: job.publishedStatus,
      SHOP: job.company == null ? null : Company.toMap(job.company!),
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
        jobId: map[JOB_ID],
        name: map[NAME],
        rank: map[RANK],
        category: map[CATEGORY],
        subCategory: map[SUB_CATEGORY],
        authorOrManufacturer: map[AUTHOR_OR_MANUFACTURER],
        price: map[PRICE],
        regularPrice: map[REGULAR_PRICE],
        tag: map[TAG],
        approved: map[APPROVED],
        description: map[DESCRIPTION],
        rating: map[RATING] ?? 0.0,
        reference: map[REFERENCE].toString(),
        availableStock: map[AVAILABLE_STOCK],
        image: map[IMAGE] ?? [],
        deliverable: map[DELIVERABLE],
        metaData: map[META_DATA],
        publishedStatus: map[PUBLISHED_STATUS],
        company: map[SHOP] == null ? Company() : Company.toModel(map[SHOP]),
        firstModified: DateTime.parse(
            map[FIRST_MODIFIED] ?? DateTime.now().toIso8601String()),
        lastModified: DateTime.parse(
            map[LAST_MODIFIED] ?? DateTime.now().toIso8601String()));
  }

  /// Changes List of Map to List of Model
  static List<Job> toModelList(List<dynamic> maps) {
    List<Job> modelList = [];
    maps.forEach((dynamic map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<Job> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((Job model) {
      mapList.add(toMap(model));
    });
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
    maps.forEach((dynamic map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<CalledJob> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((CalledJob model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}
