import 'package:flutter/material.dart';
import 'package:nibjobs/db/k_shared_preference.dart';
import 'package:nibjobs/page/company/add_item.dart';
//import 'package:nibjobs/page/company/add_item.dart';
import 'package:nibjobs/page/company/admin.dart';
import 'package:nibjobs/page/company/detail.dart';
import 'package:nibjobs/page/company/edit.dart';
import 'package:nibjobs/page/company/job_list_view.dart';
import 'package:nibjobs/page/company/rating.dart';
import 'package:nibjobs/page/info/contact_us.dart';
import 'package:nibjobs/page/info/help.dart';
import 'package:nibjobs/page/info/news.dart';
import 'package:nibjobs/page/info/notification.dart';
import 'package:nibjobs/page/info/terms_and_conditions.dart';
import 'package:nibjobs/page/info/version_and_update.dart';
import 'package:nibjobs/page/info/welcome.dart';
import 'package:nibjobs/page/product/best_sellers.dart';
import 'package:nibjobs/page/product/category_product_full_page.dart';
import 'package:nibjobs/page/product/detail.dart';
import 'package:nibjobs/page/product/edit.dart';
import 'package:nibjobs/page/product/home.dart';
import 'package:nibjobs/page/profile/category_preference.dart';
import 'package:nibjobs/page/profile/gift.dart';
import 'package:nibjobs/page/profile/language.dart';
import 'package:nibjobs/page/profile/signin.dart';
import 'package:nibjobs/page/profile/wishlist.dart';
import 'package:nibjobs/page/setting/general/general.dart';
import 'package:nibjobs/page/setting/general/payment_and_delivery.dart';
import 'package:nibjobs/page/setting/wallet/cash_out_method.dart';
import 'package:nibjobs/page/setting/wallet/change_password.dart';
import 'package:nibjobs/page/setting/wallet/general.dart';
import 'package:nibjobs/page/setting/wallet/setup_password.dart';
import 'package:nibjobs/page/wallet/cash_out.dart';
import 'package:nibjobs/page/wallet/dashboard.dart';
import 'package:nibjobs/page/wallet/login.dart';
import 'package:nibjobs/page/wallet/send_credit.dart';
import 'package:nibjobs/widget/nav/category_job_selected.dart';
import 'package:nibjobs/widget/nav/notification_job_nav.dart';

class RouteTo {
  // Root path
  static const String ROOT = "/";

  // Info pages

  static const String INFO_CONTACT_US = "/info/contactUs";
  static const String GIFT = "/info/gift";
  static const String INFO_HELP = "/info/help";
  static const String INFO_NEWS = "/info/news";
  static const String INFO_TERMS_AND_CONDITIONS = "/info/termsAndConditions";
  static const String INFO_VERSION_AND_UPDATE = "/info/versionAndUpdate";
  static const String INFO_WELCOME = "/info/welcome";

  // Job pages
  static const String JOB_BEST_SELLERS = "/job/bestSellers";
  static const String JOB_DETAIL = "/job/detail";
  static const String JOB_SEARCH = "/job/search";
  static const String JOB_CATEGORY = "/job/category";
  static const String NOTIFICATION = "/notification";
  static const String JOB_EDIT = "/job/edit";
  static const String HOME = "/job/list";

  // Order pages
  static const String ORDER_CART = "/order/cart";
  static const String ORDER_CHECK_OUT = "/order/checkOut";
  static const String ORDER_VIEW = "/order/view";

  // Profile pages
  static const String PROFILE_LANGUAGE_SELECTOR = "/profile/languageSelector";
  static const String PROFILE_SIGN_IN = "/profile/signIn";
  static const String PROFILE_WISH_LIST = "/profile/wishList";

  // General settings pages
  static const String SETTING_GENERAL = "/setting/general";
  static const String SETTING_PAYMENT_AND_DELIVERY =
      "/setting/paymentAndDelivery";

  // Wallet settings page
  static const String SETTING_WALLET_CASH_OUT_METHODS =
      "/setting/wallet/cashOutMethods";
  static const String SETTING_WALLET_CHANGE_PASSWORD =
      "/setting/wallet/changePassword";
  static const String SETTING_WALLET_GENERAL = "/setting/wallet/general";
  static const String SETTING_WALLET_SETUP_PASSWORD =
      "/setting/wallet/setupPassword";

  // Company pages
  static const String SHOP_ADMIN = "/company/admin";
  static const String SHOP_DETAIL = "/company/detail";
  static const String SHOP_EDIT = "/company/edit";
  static const String SHOP_ISSUE_COUPON = "/company/issueCoupon";
  static const String SHOP_RATING = "/company/rating";
  static const String SHOP_ADD_ITEM = "/company/add_item";
  static const String SHOP_JOB_LIST = "/company/job";

  // Wallet pages
  static const String WALLET_CASH_OUT = "/wallet/cashOut";
  static const String WALLET_DASHBOARD = "/wallet/dashboard";
  static const String WALLET_LOGIN = "/wallet/login";
  static const String WALLET_SEND_CREDIT = "/wallet/send/credit";
  static const String CATEGORY_PREFERENCE = "/info/preference";

  static const String JOB_Notification = "/notification/job";

  var routes;
  RouteTo() {
    routes = {
      ROOT: (BuildContext context) => SafeArea(
            child: FutureBuilder(
              builder: buildFirstPage,
              future: isFirstTime(),
            ),
          ),
      // ROOT: (BuildContext context) =>
      //     HomePage(), // todo uncomment the above code after internet

      /// Info page

      CATEGORY_PREFERENCE: (BuildContext context) =>
          SafeArea(child: CategoryPreferencePage()),
      GIFT: (BuildContext context) => SafeArea(child: GiftPage()),
      INFO_CONTACT_US: (BuildContext context) =>
          SafeArea(child: ContactUsPage()),
      INFO_HELP: (BuildContext context) => SafeArea(child: HelpPage()),
      INFO_NEWS: (BuildContext context) => SafeArea(child: NewsPage()),
      INFO_TERMS_AND_CONDITIONS: (BuildContext context) =>
          SafeArea(child: TermsAndConditionsPage()),
      INFO_VERSION_AND_UPDATE: (BuildContext context) =>
          SafeArea(child: VersionAndUpdatePage()),
      INFO_WELCOME: (BuildContext context) => SafeArea(child: WelcomePage()),

      /// Job pages
      JOB_BEST_SELLERS: (BuildContext context) =>
          SafeArea(child: BestSellersPage()),
      JOB_DETAIL: (BuildContext context) => SafeArea(child: JobDetailPage()),
      JOB_SEARCH: (BuildContext context) => SafeArea(child: KelemSearchPage()),
      JOB_CATEGORY: (BuildContext context) =>
          SafeArea(child: CategorySelectedJobNavigation()),

      JOB_EDIT: (BuildContext context) => SafeArea(child: JobEditPage()),
      HOME: (BuildContext context) => SafeArea(child: HomePage()),

      /// Profile pages
      PROFILE_LANGUAGE_SELECTOR: (BuildContext context) =>
          SafeArea(child: LanguagePage()),
      PROFILE_SIGN_IN: (BuildContext context) => SafeArea(child: SignInPage()),
      PROFILE_WISH_LIST: (BuildContext context) =>
          SafeArea(child: WishListPage()),

      /// General settings pages
      SETTING_GENERAL: (BuildContext context) => GeneralSettingsPage(),
      SETTING_PAYMENT_AND_DELIVERY: (BuildContext context) =>
          SafeArea(child: PaymentAndDeliverySettingsPage()),

      /// Wallet settings pages
      SETTING_WALLET_CASH_OUT_METHODS: (BuildContext context) =>
          SafeArea(child: CashOutMethodWalletSettingsPage()),
      SETTING_WALLET_CHANGE_PASSWORD: (BuildContext context) =>
          SafeArea(child: ChangePasswordWalletSettingsPage()),
      SETTING_WALLET_GENERAL: (BuildContext context) =>
          SafeArea(child: WalletSettingsPage()),
      SETTING_WALLET_SETUP_PASSWORD: (BuildContext context) =>
          SafeArea(child: SetupPasswordWalletSettingsPage()),

      /// Company pages
      SHOP_ADMIN: (BuildContext context) => SafeArea(child: CompanyAdminPage()),
      SHOP_DETAIL: (BuildContext context) =>
          SafeArea(child: CompanyDetailPage()),
      SHOP_EDIT: (BuildContext context) => SafeArea(child: EditCompanyPage()),
      SHOP_RATING: (BuildContext context) =>
          SafeArea(child: CompanyRatingPage()),
      SHOP_ADD_ITEM: (BuildContext context) => SafeArea(child: AddItemPage()),
      SHOP_JOB_LIST: (BuildContext context) =>
          SafeArea(child: CompanyJobPage()),
      NOTIFICATION: (BuildContext context) =>
          SafeArea(child: NotificationsPage()),
      JOB_Notification: (BuildContext context) =>
          SafeArea(child: NotificationJobNav()),

      /// Wallet pages
      WALLET_CASH_OUT: (BuildContext context) => SafeArea(child: CashOutPage()),
      WALLET_DASHBOARD: (BuildContext context) =>
          SafeArea(child: WalletDashboardPage()),
      WALLET_LOGIN: (BuildContext context) =>
          SafeArea(child: LoginWalletPage()),
      WALLET_SEND_CREDIT: (BuildContext context) =>
          SafeArea(child: SendCreditPage()),
    };
  }

  Widget buildFirstPage(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.none &&
        snapshot.hasData == null) {
      return CircularProgressIndicator();
    } else if (snapshot.data == true) {
      return LanguagePage();
    } else if (snapshot.data == false) {
      return HomePage(); // change to home page
    } else {
      return Container(color: Colors.white, child: CircularProgressIndicator());
    }
  }

  Future<bool> isFirstTime() async {
    HSharedPreference localPreference = GetHSPInstance.hSharedPreference;
    return await localPreference
        .get(HSharedPreference.KEY_FIRST_TIME)
        .then((firstTime) => firstTime == null ? true : false);
  }
}
