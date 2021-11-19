import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nibjobs/global.dart' as global;
import 'package:nibjobs/model/ad_model.dart';
import 'package:nibjobs/model/config/global.dart';

class ApiGlobalConfig {
  static const String GLOBAL_KEY_ID = "VM4rSfVp138U9YPvc69g";
  static get() {
    FirebaseFirestore.instance
        .collection(GlobalConfig.COLLECTION_NAME)
        .doc(GLOBAL_KEY_ID)
        .snapshots()
        .listen((DocumentSnapshot globalConfigSnapShot) {
      Map? globalConfigCloud = globalConfigSnapShot.data() as Map;

      /// Extracting global config id
      String globalConfigId = globalConfigCloud[GlobalConfig.GLOBAL_CONFIG_ID];

      /// Extracting additional fees
      AdditionalFee additionalFee =
          AdditionalFee.toModel(globalConfigCloud[GlobalConfig.ADDITIONAL_FEE]);

      /// Extracting Ad
      List<Ad> ads = Ad.toModelList(globalConfigCloud[GlobalConfig.AD]);

      /// Extracting subscription packages
      List<SubscriptionPackage> subscriptionPackages =
          SubscriptionPackage.toModelList(
              globalConfigCloud[GlobalConfig.SUBSCRIPTION_PACKAGES]);

      /// Extracting categories
      List<Category> categories =
          Category.toModelList(globalConfigCloud[GlobalConfig.CATEGORIES]);

      /// Extracting features config
      FeaturesConfig featuresConfig = FeaturesConfig.toModel(
          globalConfigCloud[GlobalConfig.FEATURES_CONFIG]);

      /// Extracting bank config
      List<BankConfig> bankConfigs =
          BankConfig.toModelList(globalConfigCloud[GlobalConfig.BANK_CONFIG]);

      Map<String, dynamic> translation =
          globalConfigCloud[GlobalConfig.TRANSLATION];
      // setting new values and notifying listeners.
      global.globalConfig.setConfig(
        globalConfigId: globalConfigId,
        additionalFee: additionalFee,
        subscriptionPackages: subscriptionPackages,
        categories: categories,
        translation: translation,
        featuresConfig: featuresConfig,
        bankConfigs: bankConfigs,
        ad: ads,
      );

      categories.insert(
          0, Category(name: "all", tags: ["all"], icon: "some Icon"));
      global.localConfig.amCategory = translation;
      global.localConfig.categories = categories;
      global.localConfig.selectedCategory = categories[1];
    });
  }
}
