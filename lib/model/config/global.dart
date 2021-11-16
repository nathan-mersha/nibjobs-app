import 'dart:core';

import 'package:flutter/material.dart';

import '../ad_model.dart';

/// Defines globalConfig model
class GlobalConfig with ChangeNotifier {
  static const String COLLECTION_NAME = "globalConfig";

  /// Defines key values to extract from a map
  static const String GLOBAL_CONFIG_ID = "globalConfigId";
  static const String TRANSLATION = "translation";
  static const String AD = "ad";
  static const String ADDITIONAL_FEE = "additionalFee";
  static const String SUBSCRIPTION_PACKAGES = "subscriptionPackages";
  static const String FEATURES_CONFIG = "featuresConfig";
  static const String BANK_CONFIG = "bankConfig";
  static const String CATEGORIES = "categories";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String? globalConfigId;
  AdditionalFee? additionalFee;
  List<SubscriptionPackage>? subscriptionPackages;
  FeaturesConfig? featuresConfig;
  Map<String, dynamic>? translation;
  List<BankConfig>? bankConfigs;
  List<Ad>? ad;
  List<Category>? categories;
  DateTime? firstModified;
  DateTime? lastModified;

  GlobalConfig({
    this.globalConfigId,
    this.additionalFee,
    this.subscriptionPackages,
    this.featuresConfig,
    this.translation,
    this.bankConfigs,
    this.categories,
    this.ad,
    this.firstModified,
    this.lastModified,
  }) {
    notifyListeners();
  }

  /// set's global config values.
  void setConfig(
      {String? globalConfigId,
      AdditionalFee? additionalFee,
      List<SubscriptionPackage>? subscriptionPackages,
      FeaturesConfig? featuresConfig,
      List<BankConfig>? bankConfigs,
      List<Category>? categories,
      List<Ad>? ad,
      Map<String, dynamic>? translation}) {
    this.globalConfigId = globalConfigId;
    this.additionalFee = additionalFee;
    this.subscriptionPackages = subscriptionPackages;
    this.featuresConfig = featuresConfig;
    this.translation = translation;
    this.bankConfigs = bankConfigs;
    this.categories = categories;
    this.ad = ad;
    notifyListeners();
  }

  /// Converts Model to Map
  static Map<String, dynamic> toMap(GlobalConfig globalConfig) {
    return {
      GLOBAL_CONFIG_ID: globalConfig.globalConfigId,
      TRANSLATION: globalConfig.translation,
      ADDITIONAL_FEE: globalConfig.additionalFee == null
          ? null
          : AdditionalFee.toMap(globalConfig.additionalFee!),
      SUBSCRIPTION_PACKAGES: globalConfig.subscriptionPackages == null
          ? null
          : SubscriptionPackage.toMapList(globalConfig.subscriptionPackages!),
      FEATURES_CONFIG: globalConfig.featuresConfig == null
          ? null
          : FeaturesConfig.toMap(globalConfig.featuresConfig!),
      AD: globalConfig.ad == null ? null : Ad.toMapList(globalConfig.ad!),
      BANK_CONFIG: globalConfig.bankConfigs == null
          ? null
          : BankConfig.toMapList(globalConfig.bankConfigs!),
      CATEGORIES: globalConfig.categories == null
          ? null
          : Category.toMapList(globalConfig.categories!),
      FIRST_MODIFIED: globalConfig.firstModified,
      LAST_MODIFIED: globalConfig.lastModified
    };
  }

  /// Converts Map to Model
  static GlobalConfig toModel(Map<String, dynamic> map) {
    return GlobalConfig(
        globalConfigId: map[GLOBAL_CONFIG_ID],
        translation: map[TRANSLATION],
        additionalFee: map[ADDITIONAL_FEE] == null
            ? AdditionalFee()
            : AdditionalFee.toModel(map[ADDITIONAL_FEE]),
        subscriptionPackages: map[SUBSCRIPTION_PACKAGES] == null
            ? []
            : SubscriptionPackage.toModelList(map[SUBSCRIPTION_PACKAGES]),
        featuresConfig: map[FEATURES_CONFIG] == null
            ? FeaturesConfig()
            : FeaturesConfig.toModel(map[FEATURES_CONFIG]),
        bankConfigs: map[BANK_CONFIG] == null
            ? []
            : BankConfig.toModelList(map[BANK_CONFIG]),
        ad: map[AD] == null ? [] : Ad.toModelList(map[AD]),
        categories: map[CATEGORIES] == null
            ? []
            : Category.toModelList(map[CATEGORIES]),
        firstModified: map[FIRST_MODIFIED],
        lastModified: map[LAST_MODIFIED]);
  }

  /// Changes List of Map to List of Model
  static List<GlobalConfig> toModelList(List<Map<String, dynamic>> maps) {
    List<GlobalConfig> modelList = [];
    maps.forEach((Map<String, dynamic> map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<GlobalConfig> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((GlobalConfig model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}

/// Defines additionalFee model
class AdditionalFee {
  /// Defines key values to extract from a map
  static const String ADDITIONAL_FEE_ID = "additionalFeeId";
  static const String TRANSACTION_FEE_TYPE =
      "transactionFeeType"; // Defines calculation type, flat rate or percentage
  static const String TRANSACTION_FEE_VALUE = "transactionFeeValue";
  static const String TAX_FEE_VALUE = "taxFeeValue";
  static const String DELIVERY_FEE_TYPE =
      "deliveryFeeType"; // Defines calculation type for delivery fee type, km or flat rate
  static const String DELIVERY_FEE_VALUE = "deliveryFeeValue";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String? additionalFeeId;
  String? transactionFeeType;
  num? transactionFeeValue;
  num? taxFeeValue;

  String? deliveryFeeType;
  num? deliveryFeeValue;
  DateTime? firstModified;
  DateTime? lastModified;

  AdditionalFee(
      {this.additionalFeeId,
      this.transactionFeeType,
      this.transactionFeeValue,
      this.taxFeeValue,
      this.deliveryFeeType,
      this.deliveryFeeValue,
      this.firstModified,
      this.lastModified});

  /// Converts Model to Map
  static Map<String, dynamic> toMap(AdditionalFee additionalFee) {
    return {
      ADDITIONAL_FEE_ID: additionalFee.additionalFeeId,
      TRANSACTION_FEE_TYPE: additionalFee.transactionFeeType,
      TRANSACTION_FEE_VALUE: additionalFee.transactionFeeValue,
      TAX_FEE_VALUE: additionalFee.taxFeeValue,
      DELIVERY_FEE_TYPE: additionalFee.deliveryFeeType,
      DELIVERY_FEE_VALUE: additionalFee.deliveryFeeValue,
      FIRST_MODIFIED: additionalFee.firstModified,
      LAST_MODIFIED: additionalFee.lastModified
    };
  }

  /// Converts Map to Model
  static AdditionalFee toModel(Map<String, dynamic> map) {
    return AdditionalFee(
        additionalFeeId: map[ADDITIONAL_FEE_ID],
        transactionFeeType: map[TRANSACTION_FEE_TYPE],
        transactionFeeValue: map[TRANSACTION_FEE_VALUE],
        taxFeeValue: map[TAX_FEE_VALUE],
        deliveryFeeType: map[DELIVERY_FEE_TYPE],
        deliveryFeeValue: map[DELIVERY_FEE_VALUE],
        firstModified: map[FIRST_MODIFIED],
        lastModified: map[LAST_MODIFIED]);
  }

  /// Changes List of Map to List of Model
  static List<AdditionalFee> toModelList(List<Map<String, dynamic>> maps) {
    List<AdditionalFee> modelList = [];
    maps.forEach((Map<String, dynamic> map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<AdditionalFee> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((AdditionalFee model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}

/// Defines subscriptionPackage model
class SubscriptionPackage {
  /// Defines key values to extract from a map
  static const String SUBSCRIPTION_PACKAGES_ID = "subscriptionPackageId";
  static const String NAME = "name";
  static const String FEATURES = "features";
  static const String MONTHLY_PRICE = "monthlyPrice";
  static const String YEARLY_PRICE = "yearlyPrice";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String? subscriptionPackageId;
  String? name;
  List<dynamic>? features;
  num? monthlyPrice;
  num? yearlyPrice;
  DateTime? firstModified;
  DateTime? lastModified;

  SubscriptionPackage(
      {this.subscriptionPackageId,
      this.name,
      this.features,
      this.monthlyPrice,
      this.yearlyPrice,
      this.firstModified,
      this.lastModified});

  /// Converts Model to Map
  static Map<String, dynamic> toMap(SubscriptionPackage subscriptionPackage) {
    return {
      SUBSCRIPTION_PACKAGES_ID: subscriptionPackage.subscriptionPackageId,
      NAME: subscriptionPackage.name,
      FEATURES: subscriptionPackage.features,
      MONTHLY_PRICE: subscriptionPackage.monthlyPrice,
      YEARLY_PRICE: subscriptionPackage.yearlyPrice,
      FIRST_MODIFIED: subscriptionPackage.firstModified,
      LAST_MODIFIED: subscriptionPackage.lastModified
    };
  }

  /// Converts Map to Model
  static SubscriptionPackage toModel(dynamic map) {
    return SubscriptionPackage(
        subscriptionPackageId: map[SUBSCRIPTION_PACKAGES_ID],
        name: map[NAME],
        features: map[FEATURES],
        monthlyPrice: map[MONTHLY_PRICE],
        yearlyPrice: map[YEARLY_PRICE],
        firstModified: map[FIRST_MODIFIED],
        lastModified: map[LAST_MODIFIED]);
  }

  /// Changes List of Map to List of Model
  static List<SubscriptionPackage> toModelList(List<dynamic> maps) {
    List<SubscriptionPackage> modelList = [];
    maps.forEach((dynamic map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(
      List<SubscriptionPackage> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((SubscriptionPackage model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}

/// Defines featuresConfig model
class FeaturesConfig {
  /// Defines key values to extract from a map
  static const String FEATURES_CONFIG_ID = "featuresConfigId";
  static const String BUY_CREDIT = "buyCredit";
  static const String WALLET = "wallet";
  static const String TRANSACTIONS = "transactions";
  static const String COMPANY = "company";
  static const String CLAIM_GIFT = "claimGift";
  static const String WISH_LIST = "wishList";
  static const String NEWS = "news";
  static const String ABOUT_US = "aboutUs";
  static const String ORDER = "order";
  static const String FORCE_NEWS_ON_HOME = "forceNewsOnHome";

  /// If toggled on shows best sellers page
  static const String BEST_SELLERS = "bestSellers";

  /// If toggled on, supports cash out
  static const String CASH_OUT = "cashOut";

  /// If toggled on, shows detail information about the company
  static const String COMPANY_DETAIL = "companyDetail";

  /// If toggled on, shows the location of the item
  static const String COMPANY_INFORMATION = "companyInformation";

  /// If toggled on, shows cash on delivery payment method
  static const String PAYMENT_METHOD_CASH_ON_DELIVERY =
      "paymentMethodCashOnDelivery";

  /// If toggled on, shows Kelem wallet as a payment method
  static const String PAYMENT_METHOD_KELEM_WALLET = "paymentMethodKelemWallet";

  /// If toggled on, shows Hisab Wallet as a payment method.
  static const String PAYMENT_METHOD_HISAB_WALLET = "paymentMethodHisabWallet";

  /// Contains the list of banks that support cash out methods.
  static const String CASH_OUT_SUPPORT_BANKS = "cashOutSupportBanks";

  /// If toggled on, show tin input field in company and when performing payment
  static const String TIN = "tin";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String? featuresConfigId;
  bool? buyCredit;
  bool? wallet;
  bool? transactions;
  bool? claimGift;
  bool? company;
  bool? wishList;
  bool? news;
  bool? aboutUs;
  bool? order;
  bool? forceNewsOnHome;
  bool? bestSellers;
  bool? cashOut;
  bool? companyDetail;
  bool? companyInformation;
  bool? paymentMethodCashOnDelivery;
  bool? paymentMethodKelemWallet;
  bool? paymentMethodHisabWallet;
  bool? tin;
  List<dynamic>? cashOutSupportBanks;
  DateTime? firstModified;
  DateTime? lastModified;

  FeaturesConfig(
      {this.featuresConfigId,
      this.buyCredit,
      this.wallet,
      this.transactions,
      this.company,
      this.claimGift,
      this.wishList,
      this.news,
      this.aboutUs,
      this.order,
      this.forceNewsOnHome,
      this.bestSellers,
      this.cashOut,
      this.companyDetail,
      this.companyInformation,
      this.paymentMethodCashOnDelivery,
      this.paymentMethodKelemWallet,
      this.paymentMethodHisabWallet,
      this.cashOutSupportBanks,
      this.tin,
      this.firstModified,
      this.lastModified});

  /// Converts Model to Map
  static Map<String, dynamic> toMap(FeaturesConfig featuresConfig) {
    return {
      FEATURES_CONFIG_ID: featuresConfig.featuresConfigId,
      BUY_CREDIT: featuresConfig.buyCredit,
      WALLET: featuresConfig.wallet,
      TRANSACTIONS: featuresConfig.transactions,
      CLAIM_GIFT: featuresConfig.claimGift,
      COMPANY: featuresConfig.company,
      WISH_LIST: featuresConfig.wishList,
      NEWS: featuresConfig.news,
      ABOUT_US: featuresConfig.aboutUs,
      ORDER: featuresConfig.order,
      FORCE_NEWS_ON_HOME: featuresConfig.forceNewsOnHome,
      BEST_SELLERS: featuresConfig.bestSellers,
      CASH_OUT: featuresConfig.cashOut,
      COMPANY_DETAIL: featuresConfig.companyDetail,
      COMPANY_INFORMATION: featuresConfig.companyInformation,
      PAYMENT_METHOD_CASH_ON_DELIVERY:
          featuresConfig.paymentMethodCashOnDelivery,
      PAYMENT_METHOD_KELEM_WALLET: featuresConfig.paymentMethodKelemWallet,
      PAYMENT_METHOD_HISAB_WALLET: featuresConfig.paymentMethodHisabWallet,
      CASH_OUT_SUPPORT_BANKS: featuresConfig.cashOutSupportBanks,
      TIN: featuresConfig.tin,
      FIRST_MODIFIED: featuresConfig.firstModified,
      LAST_MODIFIED: featuresConfig.lastModified
    };
  }

  /// Converts Map to Model
  static FeaturesConfig toModel(Map<String, dynamic> map) {
    return FeaturesConfig(
        featuresConfigId: map[FEATURES_CONFIG_ID],
        buyCredit: map[BUY_CREDIT],
        wallet: map[WALLET],
        claimGift: map[CLAIM_GIFT],
        transactions: map[TRANSACTIONS],
        company: map[COMPANY],
        wishList: map[WISH_LIST],
        news: map[NEWS],
        aboutUs: map[ABOUT_US],
        order: map[ORDER],
        forceNewsOnHome: map[FORCE_NEWS_ON_HOME],
        bestSellers: map[BEST_SELLERS],
        cashOut: map[CASH_OUT],
        companyDetail: map[COMPANY_DETAIL],
        companyInformation: map[COMPANY_INFORMATION],
        paymentMethodCashOnDelivery: map[PAYMENT_METHOD_CASH_ON_DELIVERY],
        paymentMethodKelemWallet: map[PAYMENT_METHOD_KELEM_WALLET],
        paymentMethodHisabWallet: map[PAYMENT_METHOD_HISAB_WALLET],
        cashOutSupportBanks: map[CASH_OUT_SUPPORT_BANKS],
        tin: map[TIN],
        firstModified: map[FIRST_MODIFIED],
        lastModified: map[LAST_MODIFIED]);
  }

  /// Changes List of Map to List of Model
  static List<FeaturesConfig> toModelList(List<Map<String, dynamic>> maps) {
    List<FeaturesConfig> modelList = [];
    maps.forEach((Map<String, dynamic> map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<FeaturesConfig> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((FeaturesConfig model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}

/// Defines dialling pattern
class BankConfig {
  /// Defines key values to extract from a map
  static const String BANK_CONFIG_ID = "bankConfigId";
  static const String BANK_NAME = "bankName";
  static const String DEPOSIT_TO_DIALLING_PATTERN = "depositToDiallingPattern";
  static const String KELEM_BANK_ACCOUNT = "kelemBankAccount";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String? bankConfigId;
  String? bankName;
  String? depositToDiallingPattern;
  String? kelemBankAccount;
  DateTime? firstModified;
  DateTime? lastModified;

  BankConfig(
      {this.bankConfigId,
      this.bankName,
      this.depositToDiallingPattern,
      this.kelemBankAccount,
      this.firstModified,
      this.lastModified});

  /// Converts Model to Map
  static Map<String, dynamic> toMap(BankConfig bankConfig) {
    return {
      BANK_CONFIG_ID: bankConfig.bankConfigId,
      BANK_NAME: bankConfig.bankName,
      DEPOSIT_TO_DIALLING_PATTERN: bankConfig.depositToDiallingPattern,
      KELEM_BANK_ACCOUNT: bankConfig.kelemBankAccount,
      FIRST_MODIFIED: bankConfig.firstModified,
      LAST_MODIFIED: bankConfig.lastModified
    };
  }

  /// Converts Map to Model
  static BankConfig toModel(Map<String, dynamic> map) {
    return BankConfig(
        bankConfigId: map[BANK_CONFIG_ID],
        bankName: map[BANK_NAME],
        depositToDiallingPattern: map[DEPOSIT_TO_DIALLING_PATTERN],
        kelemBankAccount: map[KELEM_BANK_ACCOUNT],
        firstModified: map[FIRST_MODIFIED],
        lastModified: map[LAST_MODIFIED]);
  }

  /// Changes List of Map to List of Model
  static List<BankConfig> toModelList(List<dynamic> maps) {
    List<BankConfig> modelList = [];
    maps.forEach((dynamic map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<BankConfig> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((BankConfig model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}

/// Defines kelemWalletUssdDialPatterns model [KelemWalletUssdDialPatterns]
class KelemWalletUssdDialPatterns {
  /// Defines key values to extract from a map
  static const String KELEM_WALLET_USSD_DIAL_PATTERNS_ID =
      "kelemWalletUssdDialPatternsId";
  static const String GET_TRANSACTION_HISTORY = "getTransactionHistory";
  static const String CHECK_BALANCE = "checkBalance";
  static const String SEND_CREDIT = "sendCredit";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String? kelemWalletUssdDialPatternsId;
  String? getTransactionHistory;
  String? checkBalance;
  String? sendCredit;
  DateTime? firstModified;
  DateTime? lastModified;

  KelemWalletUssdDialPatterns(
      {this.kelemWalletUssdDialPatternsId,
      this.getTransactionHistory,
      this.checkBalance,
      this.sendCredit,
      this.firstModified,
      this.lastModified});

  /// Converts Model to Map
  static Map<String, dynamic> toMap(
      KelemWalletUssdDialPatterns kelemWalletUssdDialPatterns) {
    return {
      KELEM_WALLET_USSD_DIAL_PATTERNS_ID:
          kelemWalletUssdDialPatterns.kelemWalletUssdDialPatternsId,
      GET_TRANSACTION_HISTORY:
          kelemWalletUssdDialPatterns.getTransactionHistory,
      CHECK_BALANCE: kelemWalletUssdDialPatterns.checkBalance,
      SEND_CREDIT: kelemWalletUssdDialPatterns.sendCredit,
      FIRST_MODIFIED: kelemWalletUssdDialPatterns.firstModified,
      LAST_MODIFIED: kelemWalletUssdDialPatterns.lastModified
    };
  }

  /// Converts Map to Model
  static KelemWalletUssdDialPatterns toModel(Map<String, dynamic> map) {
    return KelemWalletUssdDialPatterns(
        kelemWalletUssdDialPatternsId: map[KELEM_WALLET_USSD_DIAL_PATTERNS_ID],
        getTransactionHistory: map[GET_TRANSACTION_HISTORY],
        checkBalance: map[CHECK_BALANCE],
        sendCredit: map[SEND_CREDIT],
        firstModified: map[FIRST_MODIFIED],
        lastModified: map[LAST_MODIFIED]);
  }

  /// Changes List of Map to List of Model
  static List<KelemWalletUssdDialPatterns> toModelList(
      List<Map<String, dynamic>> maps) {
    List<KelemWalletUssdDialPatterns> modelList = [];
    maps.forEach((Map<String, dynamic> map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(
      List<KelemWalletUssdDialPatterns> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((KelemWalletUssdDialPatterns model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}

/// Defines items categories
class Category {
  /// Defines key values to extract from a map
  static const String CATEGORY_ID = "categoryId";
  static const String NAME = "name";
  static const String ICON = "icon";
  static const String SUB_CATEGORIES = "subCategories";
  static const String FIRST_MODIFIED = "firstModified";
  static const String LAST_MODIFIED = "lastModified";

  String? categoryId;
  String? name;
  String? icon;
  List<dynamic>? subCategories;
  DateTime? firstModified;
  DateTime? lastModified;

  /// Category constructor
  Category(
      {this.categoryId,
      this.name,
      this.icon,
      this.subCategories,
      this.firstModified,
      this.lastModified});

  /// Converts Model to Map
  static Map<String, dynamic> toMap(Category category) {
    return {
      CATEGORY_ID: category.categoryId,
      NAME: category.name,
      ICON: category.icon,
      SUB_CATEGORIES: category.subCategories,
      FIRST_MODIFIED: category.firstModified,
      LAST_MODIFIED: category.lastModified
    };
  }

  /// Converts Map to Model
  static Category toModel(dynamic map) {
    return Category(
        categoryId: map[CATEGORY_ID],
        name: map[NAME],
        icon: map[ICON],
        subCategories: map[SUB_CATEGORIES],
        firstModified: map[FIRST_MODIFIED],
        lastModified: map[LAST_MODIFIED]);
  }

  /// Changes List of Map to List of Model
  static List<Category> toModelList(dynamic maps) {
    List<Category> modelList = [];
    maps.forEach((dynamic map) {
      modelList.add(toModel(map));
    });
    return modelList;
  }

  /// Changes List of Model to List of Map
  static List<Map<String, dynamic>> toMapList(List<Category> models) {
    List<Map<String, dynamic>> mapList = [];
    models.forEach((Category model) {
      mapList.add(toMap(model));
    });
    return mapList;
  }
}
