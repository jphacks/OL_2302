import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:pills_app/view/bought.dart';
import 'package:pills_app/view/navigation.dart';
import 'package:pills_app/view/note.dart';
import 'package:pills_app/view/search_partner.dart';
import 'package:pills_app/view/slide_show.dart';
import 'package:pills_app/view/story/story.dart';
import 'package:pills_app/view/story/story2.dart';
import 'package:pills_app/view/time_select.dart';
import 'package:pills_app/view/number_select.dart';
import 'package:pills_app/view/pill.dart';
import 'package:pills_app/view/pill_select.dart';
import 'package:pills_app/view/sign_in.dart';
import 'package:pills_app/view/sign_up.dart';
import 'package:pills_app/view/user_status.dart';

class AppRoutes {
  static const String home = '/';
  static const String signIn = '/sign_in';
  static const String signUp = '/sign_up';
  static const String pill = '/pill';
  static const String pillSelect = '/pill_select';
  static const String numberSelect = '/number_select';
  static const String dateSelect = '/date_select';
  static const String bought = '/bought';
  static const String navi = '/navi';
  static const String note = '/note';
  static const String story = '/story';
  static const String story2 = '/story2';
  static const String status = '/status';
  static const String partner = '/partner';
  static const String slide = '/slide';
}

mixin AppPages {
  static final routes = [
    GetPage<SignIn>(name: AppRoutes.signIn, page: () => const SignIn()),
    GetPage<SignUp>(name: AppRoutes.signUp, page: () => const SignUp()),
    GetPage<PillPage>(name: AppRoutes.pill, page: () => const PillPage()),
    GetPage<PillSelectPage>(name: AppRoutes.pillSelect, page: () => const PillSelectPage()),
    GetPage<NumberSelectPage>(
        name: AppRoutes.numberSelect, page: () => const NumberSelectPage()),
    GetPage<DateSelectPage>(
        name: AppRoutes.dateSelect, page: () => const DateSelectPage()),
    GetPage<DateSelectPage>(
        name: AppRoutes.bought, page: () => const BoughtPage()),
    GetPage<Navigation>(name: AppRoutes.navi, page: () => const Navigation()),
    GetPage<NotePage>(name: AppRoutes.note, page: () => const NotePage()),
    GetPage<UserStatusPage>(name: AppRoutes.status, page: () => const UserStatusPage()),
    GetPage<SearchPartnerPage>(name: AppRoutes.partner, page: () => const SearchPartnerPage()),
    GetPage<SlideShowScreen>(
        name: AppRoutes.slide, page: () => const SlideShowScreen()),

    GetPage<StoryPage>(name: AppRoutes.story, page: () => const StoryPage()),
    GetPage<StoryTwoPage>(name: AppRoutes.story2, page: () => const StoryTwoPage()),
  ];
}
