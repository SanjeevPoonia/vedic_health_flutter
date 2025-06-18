
class AppModel{


  static bool isLogin=false;
  static String token='';
  static String deviceID='';
  static String userEmail='';
  static String userType='';
  static bool cartLogin=false;
  static bool homeScreenLoad=false;


  static bool setLoginToken(bool value)
  {
    isLogin=value;
    return isLogin;
  }
  static bool setHomeScreenLoad(bool value)
  {
    homeScreenLoad=value;
    return homeScreenLoad;
  }
  static bool setCartLogin(bool value)
  {
    cartLogin=value;
    return cartLogin;
  }


  static String setTokenValue(String value)
  {
    token=value;
    return token;
  }
  static String setUserType(String user)
  {
    userType=user;
    return userType;
  }
  static String setDeviceID(String id)
  {
    deviceID=id;
    return deviceID;
  }

  static String setUserEmail(String email)
  {
    userEmail=email;
    return userEmail;
  }


}
