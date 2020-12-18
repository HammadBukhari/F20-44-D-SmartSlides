import 'package:get_it/get_it.dart';
import 'package:web/model/portal.dart';

import 'LoginProvider.dart';

class PortalProvider {
  final loginProvider = GetIt.I<LoginProvider>();
  List<Portal> getAllPortalOfUser() {
    // get current logged in user
    final currentUser = loginProvider.getLoggedInUser();
    // retrieve portals in which "currentUser" is enrolled/teaching
  }
}
