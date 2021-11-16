//import 'package:nibjobs/model/commerce/job.dart';
import 'package:nibjobs/model/profile/user.dart';

// /// Defines order model
// class Order {
//   static const String COLLECTION_NAME = "order";
//
//   /// Defines key values to extract from a map
//   static const String ORDER_ID = "orderId";
//   static const String JOBS_DELIVERY_STATUS = "jobsDeliveryStatus";
//   static const String STATUS = "status"; // todo : make enum value
//   static const String AMOUNT = "amount";
//   static const String NOTE = "note";
//   static const String REFUNDED = "refunded"; // When order fails to be delivered
//   static const String PAYMENT_AND_DELIVERY_PREFERENCE =
//       "paymentAndDeliveryPreference";
//   static const String PRE_PAID = "prePaid";
//   static const String USER = "user";
//   static const String FIRST_MODIFIED = "firstModified";
//   static const String LAST_MODIFIED = "lastModified";
//
//   String orderId;
//   List<JobDeliveryStatus> jobsDeliveryStatus;
//   String status;
//   Amount amount;
//   String note;
//   bool refunded;
//   PaymentAndDeliveryPreference paymentAndDeliveryPreference;
//   bool prePaid;
//   UserModel user;
//   DateTime firstModified;
//   DateTime lastModified;
//
//   Order(
//       {this.orderId,
//       this.jobsDeliveryStatus,
//       this.status,
//       this.amount,
//       this.note,
//       this.refunded,
//       this.paymentAndDeliveryPreference,
//       this.prePaid,
//       this.user,
//       this.firstModified,
//       this.lastModified});
//
//   /// Converts Model to Map
//   static Map<String, dynamic> toMap(Order order) {
//     return {
//       ORDER_ID: order.orderId,
//       JOBS_DELIVERY_STATUS: order.jobsDeliveryStatus == null
//           ? null
//           : JobDeliveryStatus.toMapList(order.jobsDeliveryStatus),
//       STATUS: order.status,
//       AMOUNT: order.amount == null ? null : Amount.toMap(order.amount),
//       NOTE: order.note,
//       REFUNDED: order.refunded,
//       PAYMENT_AND_DELIVERY_PREFERENCE:
//           order.paymentAndDeliveryPreference == null
//               ? null
//               : PaymentAndDeliveryPreference.toMap(
//                   order.paymentAndDeliveryPreference),
//       PRE_PAID: order.prePaid,
//       USER: order.user,
//       FIRST_MODIFIED: order.firstModified,
//       LAST_MODIFIED: order.lastModified
//     };
//   }
//
//   /// Converts Map to Model
//   static Order toModel(dynamic map) {
//     return Order(
//         orderId: map[ORDER_ID],
//         jobsDeliveryStatus: map[JOBS_DELIVERY_STATUS] == null
//             ? JobDeliveryStatus()
//             : JobDeliveryStatus.toModelList(map[JOBS_DELIVERY_STATUS]),
//         status: map[STATUS],
//         amount: map[AMOUNT] == null ? Amount() : Amount.toModel(map[AMOUNT]),
//         note: map[NOTE],
//         refunded: map[REFUNDED],
//         paymentAndDeliveryPreference:
//             map[PAYMENT_AND_DELIVERY_PREFERENCE] == null
//                 ? PaymentAndDeliveryPreference()
//                 : PaymentAndDeliveryPreference.toModel(
//                     map[PAYMENT_AND_DELIVERY_PREFERENCE]),
//         prePaid: map[PRE_PAID],
//         user: map[USER],
//         firstModified: map[FIRST_MODIFIED],
//         lastModified: map[LAST_MODIFIED]);
//   }
//
//   /// Changes List of Map to List of Model
//   static List<Order> toModelList(List<dynamic> maps) {
//     List<Order> modelList = [];
//     maps.forEach((dynamic map) {
//       modelList.add(toModel(map));
//     });
//     return modelList;
//   }
//
//   /// Changes List of Model to List of Map
//   static List<Map<String, dynamic>> toMapList(List<Order> models) {
//     List<Map<String, dynamic>> mapList = [];
//     models.forEach((Order model) {
//       mapList.add(toMap(model));
//     });
//     return mapList;
//   }
// }
//
// /// Defines jobDeliveryStatus model
// class JobDeliveryStatus {
//   /// Defines key values to extract from a map
//   static const String JOB_DELIVERY_STATUS_ID = "jobDeliveryStatusId";
//   static const String JOB = "job";
//   static const String QUANTITY = "quantity";
//   static const String STATUS = "status";
//   static const String FIRST_MODIFIED = "firstModified";
//   static const String LAST_MODIFIED = "lastModified";
//
//   String jobDeliveryStatusId;
//   Job job;
//   num quantity;
//   String status;
//   DateTime firstModified;
//   DateTime lastModified;
//
//   JobDeliveryStatus(
//       {this.jobDeliveryStatusId,
//       this.job,
//       this.quantity,
//       this.status,
//       this.firstModified,
//       this.lastModified});
//
//   /// Converts Model to Map
//   static Map<String, dynamic> toMap(
//       JobDeliveryStatus jobDeliveryStatus) {
//     return {
//       JOB_DELIVERY_STATUS_ID: jobDeliveryStatus.jobDeliveryStatusId,
//       JOB: jobDeliveryStatus.job == null
//           ? null
//           : Job.toMap(jobDeliveryStatus.job),
//       QUANTITY: jobDeliveryStatus.quantity,
//       STATUS: jobDeliveryStatus.status,
//       FIRST_MODIFIED: jobDeliveryStatus.firstModified,
//       LAST_MODIFIED: jobDeliveryStatus.lastModified
//     };
//   }
//
//   /// Converts Map to Model
//   static JobDeliveryStatus toModel(dynamic map) {
//     return JobDeliveryStatus(
//         jobDeliveryStatusId: map[JOB_DELIVERY_STATUS_ID],
//         job:
//             map[JOB] == null ? Job() : Job.toModel(map[JOB]),
//         quantity: map[QUANTITY],
//         status: map[STATUS],
//         firstModified: map[FIRST_MODIFIED],
//         lastModified: map[LAST_MODIFIED]);
//   }
//
//   /// Changes List of Map to List of Model
//   static List<JobDeliveryStatus> toModelList(List<dynamic> maps) {
//     List<JobDeliveryStatus> modelList = [];
//     maps.forEach((dynamic map) {
//       modelList.add(toModel(map));
//     });
//     return modelList;
//   }
//
//   /// Changes List of Model to List of Map
//   static List<Map<String, dynamic>> toMapList(
//       List<JobDeliveryStatus> models) {
//     List<Map<String, dynamic>> mapList = [];
//     models.forEach((JobDeliveryStatus model) {
//       mapList.add(toMap(model));
//     });
//     return mapList;
//   }
// }
//
// /// Defines amount model
// class Amount {
//   /// Defines key values to extract from a map
//   static const String AMOUNT_ID = "amountId";
//   static const String SUB_TOTAL = "subTotal";
//   static const String COUPON_DISCOUNT = "couponDiscount";
//   static const String HANDLING_FEE = "handlingFee";
//   static const String TRANSACTION_FEE = "transactionFee";
//   static const String TAX = "tax";
//   static const String TOTAL = "total";
//   static const String FIRST_MODIFIED = "firstModified";
//   static const String LAST_MODIFIED = "lastModified";
//
//   String amountId;
//   num subTotal;
//   num couponDiscount;
//   num handlingFee;
//   num transactionFee;
//   num tax;
//   num total;
//   DateTime firstModified;
//   DateTime lastModified;
//
//   Amount(
//       {this.amountId,
//       this.subTotal,
//       this.couponDiscount,
//       this.handlingFee,
//       this.transactionFee,
//       this.tax,
//       this.total,
//       this.firstModified,
//       this.lastModified});
//
//   /// Converts Model to Map
//   static Map<String, dynamic> toMap(Amount amount) {
//     return {
//       AMOUNT_ID: amount.amountId,
//       SUB_TOTAL: amount.subTotal,
//       COUPON_DISCOUNT: amount.couponDiscount,
//       HANDLING_FEE: amount.handlingFee,
//       TRANSACTION_FEE: amount.transactionFee,
//       TAX: amount.tax,
//       TOTAL: amount.total,
//       FIRST_MODIFIED: amount.firstModified,
//       LAST_MODIFIED: amount.lastModified
//     };
//   }
//
//   /// Converts Map to Model
//   static Amount toModel(dynamic map) {
//     return Amount(
//       amountId: map[AMOUNT_ID],
//       subTotal: map[SUB_TOTAL],
//       couponDiscount: map[COUPON_DISCOUNT],
//       handlingFee: map[HANDLING_FEE],
//       transactionFee: map[TRANSACTION_FEE],
//       tax: map[TAX],
//       total: map[TOTAL],
//       firstModified: map[FIRST_MODIFIED],
//       lastModified: map[LAST_MODIFIED],
//     );
//   }
//
//   /// Changes List of Map to List of Model
//   static List<Amount> toModelList(List<dynamic> maps) {
//     List<Amount> modelList = [];
//     maps.forEach((dynamic map) {
//       modelList.add(toModel(map));
//     });
//     return modelList;
//   }
//
//   /// Changes List of Model to List of Map
//   static List<Map<String, dynamic>> toMapList(List<Amount> models) {
//     List<Map<String, dynamic>> mapList = [];
//     models.forEach((Amount model) {
//       mapList.add(toMap(model));
//     });
//     return mapList;
//   }
// }
