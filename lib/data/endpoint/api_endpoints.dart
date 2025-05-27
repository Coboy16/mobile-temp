class ApiEndpoints {
  static const String validateUser = '/attemp/validation';
  static const String checkUserLockStatus = '/auth/attemp/validation';
  static const String login = '/auth/self/login';
  static const String loginGoogle = '/auth/self/login-google';
  static const String logout = '/auth/self/logout';
  static const String registerUser = '/auth/user';
  static const String registerWithGoogle = '/auth/user/gmail';
  static const String otpRequest = '/auth/otp/request';
  static const String otpVerify = '/auth/otp/verify';
  static const String changePassword = '/auth/self/forgot';
  static const String getUserDetails = '/auth/user/{id}';
  static const String updateUserDetails = '/auth/user/{id}';
  static const String deleteUser = '/auth/user/{id}';
  static const String checkSessionStatus = '/auth/session/{email}';
}
