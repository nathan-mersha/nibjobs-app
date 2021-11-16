import 'package:nibjobs/model/commerce/job.dart';
import 'package:nibjobs/model/commerce/order.dart';
//import 'package:nibjobs/model/commerce/job.dart';

// class Cart {
//   static const String COLLECTION_NAME = "cart";
//
//   /// Defines key values to extract from a map
//   static const String CART_ID = "cartId";
//   static const String JOBS = "jobs";
//   static const String AMOUNT = "amount";
//   static const String FIRST_MODIFIED = "firstModified";
//   static const String LAST_MODIFIED = "lastModified";
//
//   String? cartId;
//   List<Job>? jobs;
//   Amount? amount;
//   DateTime? firstModified;
//   DateTime? lastModified;
//
//   Cart(
//       {this.cartId,
//       this.jobs,
//       this.amount,
//       this.firstModified,
//       this.lastModified});
//
//   /// Converts Model to Map
//   static Map<String, dynamic> toMap(Cart cart) {
//     return {
//       CART_ID: cart.cartId,
//       JOBS: cart.jobs == null ? null : Job.toMapList(cart.jobs!),
//       // AMOUNT: cart.amount == null ? null : Amount.toMap(cart.amount!),
//       FIRST_MODIFIED: cart.firstModified,
//       LAST_MODIFIED: cart.lastModified
//     };
//   }
//
//   /// Converts Map to Model
//   static Cart toModel(dynamic map) {
//     return Cart(
//         cartId: map[CART_ID],
//         jobs: map[JOBS] == null
//             ? []
//             : Job.toModelList(map[JOBS]),
//         amount: map[AMOUNT] == null ? Amount() : Amount.toModel(map[AMOUNT]),
//         firstModified: map[FIRST_MODIFIED],
//         lastModified: map[LAST_MODIFIED]);
//   }
//
//   /// Changes List of Map to List of Model
//   static List<Cart> toModelList(List<dynamic> maps) {
//     List<Cart> modelList = [];
//     maps.forEach((dynamic map) {
//       modelList.add(toModel(map));
//     });
//     return modelList;
//   }
//
//   /// Changes List of Model to List of Map
//   static List<Map<String, dynamic>> toMapList(List<Cart> models) {
//     List<Map<String, dynamic>> mapList = [];
//     models.forEach((Cart model) {
//       mapList.add(toMap(model));
//     });
//     return mapList;
//   }
// }
