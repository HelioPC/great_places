// ignore_for_file: constant_identifier_names

enum AppRoutes {
  login,
  signup,
  home,
  form,
  detail,
}

extension AppRoutesString on AppRoutes {
  String routeAsString() {
    return '/${toString()}';
  }
}
