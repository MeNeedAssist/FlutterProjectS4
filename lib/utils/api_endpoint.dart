class ApiEndPoints {
  static const String baseUrl = 'http://10.0.2.2:8080/api/project4/';
  static const String backendUrl = 'http://10.0.2.2:8080/';
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
  static _CategoriesEndPoint categoriesEndpoints = _CategoriesEndPoint();
  static _LessonsEndPoint lessonEndpoints = _LessonsEndPoint();
  // static _AdminEndPoints adminEndpoints = _AdminEndPoints();
}

class _AuthEndPoints {
  final String registerUser = 'auth/register';
  final String loginWebAccount = 'auth/login';
  final String sendVerifyCode = 'auth/create-verify-email';
  final String activeUser = 'auth/active-user';
  final String gemData = 'thanh/game/user-data';
  final String buyGem = 'thanh/payment/buy-gem';
  final String updateProfile = 'users/update-user';
  final String uploadFile = 'file/upload-image';
}

class _CategoriesEndPoint {
  final String getCategories = 'categories/list-category';
  final String getCategoriesByToken = 'thanh/favorite/category';
  final String addOrRemove = 'thanh/favorite/add';
}

class _LessonsEndPoint {
  final String getLesson = 'thanh/lesson/list';
  final String getLessonByUserId = 'thanh/lesson';
  final String buyLesson = 'thanh/payment/buy-lesson';
  final String boughtLesson = 'thanh/lesson/my-lesson';
  final String checkPoint = 'thanh/test-result';
  final String addComment = 'thanh/lesson/comment';
  final String getFavListLesson = 'thanh/favorite/lesson';
  final String refundLesson = 'thanh/payment/refund-lesson';
  final String authorList = 'thanh/author/all-author';
  final String authorProfile = 'thanh/author/list-lesson';
}
