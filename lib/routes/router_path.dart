class RouteData {
  final String name;
  final String path;
  final String fullPath;

  const RouteData({
    required this.name,
    required this.path,
    required this.fullPath,
  });
}

class RouteInfo {

  //splash
  static RouteData splash = const RouteData(
    name: 'splash',
    path: 'splash',
    fullPath: '/splash',
  );
  //error
  static RouteData error = const RouteData(
    name: 'error',
    path: 'error',
    fullPath: '/error',
  );
  //main
  static RouteData main = const RouteData(
    name: 'main',
    path: 'main',
    fullPath: '/main',
  );
  //home
  static RouteData home = RouteData(
    name: 'home',
    path: 'home',
    fullPath: '${main.fullPath}/home',
  );
  static RouteData imageRecognition = RouteData(
    name: 'imageRecognition',
    path: 'imageRecognition',
    fullPath: '${home.fullPath}/imageRecognition',
  );
  //profile
  static RouteData profile = RouteData(
    name: 'profile',
    path: 'profile',
    fullPath: '${main.fullPath}/profile',
  );
  //login
  static RouteData login = const RouteData(
    name: 'login',
    path: 'login',
    fullPath: '/login',
  );
  static RouteData loginHelp = RouteData(
    name: 'loginHelp',
    path: 'help',
    fullPath: '${login.fullPath}/help',
  );
  //signUp
  static RouteData signUp = RouteData(
    name: 'signUp',
    path: 'signUp',
    fullPath: '${login.fullPath}/signUp',
  );
  //find
  static RouteData find = RouteData(
    name: 'find',
    path: 'find',
    fullPath: '${login.fullPath}/find',
  ); //not page
  static RouteData findUserId = RouteData(
    name: 'findUserId',
    path: '${find.path}/userId',
    fullPath: '${find.fullPath}/userId',
  );
  static RouteData findUserIdComplete = RouteData(
    name: 'findUserIdComplete',
    path: '${findUserId.path}/complete',
    fullPath: '${findUserId.fullPath}/complete',
  );
  static RouteData resetPassword = RouteData(
    name: 'resetPassword',
    path: '${find.path}/resetPassword',
    fullPath: '${find.fullPath}/resetPassword',
  );
  static RouteData sendSMStoResetPassword = RouteData(
    name: 'sendSMStoResetPassword',
    path: '${resetPassword.path}/sendSMS',
    fullPath: '${resetPassword.fullPath}/sendSMS',
  );
  static RouteData verifySMStoResetPassword = RouteData(
    name: 'verifySMStoResetPassword',
    path: '${resetPassword.path}/verifySMS',
    fullPath: '${resetPassword.fullPath}/verifySMS',
  );
  static RouteData resetPasswordComplete = RouteData(
    name: 'resetPasswordComplete',
    path: '${resetPassword.path}/complete',
    fullPath: '${resetPassword.fullPath}/complete',
  );
}