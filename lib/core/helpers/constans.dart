bool isLoggedInUser = false;

class SharedPrefKeys {
  static const String userToken = 'userToken';
  static const String userName = 'userName';
  static const String userEmail = 'userEmail';
  static const String recentSearches = 'recentSearches';

  // Notification preferences
  static const String notifPush = 'notifPush';
  static const String notifSound = 'notifSound';
  static const String notifVibrate = 'notifVibrate';
  static const String notifAppUpdates = 'notifAppUpdates';
  static const String notifSpecialOffers = 'notifSpecialOffers';

  // Security preferences
  static const String secRememberPassword = 'secRememberPassword';
  static const String secFaceId = 'secFaceId';
  static const String secPin = 'secPin';

  // Language
  static const String languageCode = 'languageCode';

  // Payment
  static const String paymentMethods = 'paymentMethods';
}
