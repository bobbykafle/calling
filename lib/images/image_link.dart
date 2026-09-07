
enum AppImageType {
  createAccount,
  login,
  forgot,
  otp,
  update,
  success,
  loading,
  emptyState,
}


extension AppImageTypeExt on AppImageType {
  String get assetPath {
    switch (this) {
      case AppImageType.createAccount:
        return 'assets/images/signup.png';
      case AppImageType.login:
        return 'assets/images/signin.png';
      case AppImageType.forgot:
        return'assets/images/forgot.png';
      case AppImageType.otp:
        return'assets/images/otp.png';  
      case AppImageType.update:
        return'assets/images/update.png';    
      case AppImageType.success:
        return 'https://assets9.lottiefiles.com/packages/lf20_7W3j2q.json';
      case AppImageType.loading:
        return 'https://assets4.lottiefiles.com/packages/lf20_a2chheef.json';
      case AppImageType.emptyState:
        return 'https://assets3.lottiefiles.com/packages/lf20_dmw319.json';
    }
  }
}