import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../utils/app_modal.dart';
import '../views/login_screen.dart';
import 'app_exceptions.dart';
import 'constants.dart';
import 'dart:convert' show utf8, base64;

class ApiBaseHelper {
  final String _baseUrl = AppConstant.appBaseURL;



  Future<dynamic> get(String url, BuildContext context) async {
    var responseJson;
    print(url+'  API CALLED');
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Accept':'application/json',
        'X-Requested-With':'XMLHttpRequest'
      });
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);

      responseJson = _returnResponse(response, context);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }


  Future<dynamic> getAPI(
      String url, BuildContext context) async {
    print(_baseUrl+url+'  API CALLED');
    var responseJson;
    try {
      final response = await http.get(Uri.parse(_baseUrl + url),
          headers: {
            'Content-Type': 'application/json',
            'Accept':'application/json'
          }
      );
      log(response.body.toString());
      responseJson = _returnResponse2(response, context);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }


  Future<dynamic> postAPI(
      String url, var apiParams, BuildContext context) async {
    print(_baseUrl+url+'  API CALLED');
    print(apiParams.toString());
    var responseJson;
    try {
      final response = await http.post(Uri.parse(_baseUrl + url),
          body: json.encode(apiParams),
          headers: {
            'Content-Type': 'application/json',
            'Accept':'application/json'
          }
          );
      log(response.body.toString());
      responseJson = _returnResponse2(response, context);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse2(http.Response response, BuildContext context) {
    String base64Response = response.body.toString();

    String foo = base64Response.split('.')[0];
    List<int> res = base64.decode(base64.normalize(foo));

    print(utf8.decode(res));

    print(response.statusCode.toString() +'Status Code******* ');

    // log('api helper response $response');
    switch (response.statusCode) {
      case 200:
        log(response.body.toString());
        return utf8.decode(res);
      case 302:
        print(response.body.toString());
        return utf8.decode(res);
      case 201:
        print(response.body.toString());
        return utf8.decode(res);
      case 400:
        print(response.body.toString());
        return utf8.decode(res);
      case 401:
        Toast.show('Unauthorized User!!',
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.black);
        throw BadRequestException(response.body.toString());
        break;
      case 403:
        Toast.show('Internal server error !!',
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.black);
        throw UnauthorisedException(response.body.toString());
      case 500:
        Toast.show('Internal server error!!',
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.black);
        break;
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }


  dynamic _returnResponse(http.Response response, BuildContext context) {
    var responseJson = jsonDecode(response.body.toString());
    print(response.statusCode.toString() +'Status Code******* ');
    log(responseJson.toString());

    // log('api helper response $response');
    switch (response.statusCode) {
      case 200:
        log(response.body.toString());
        return response;
      case 302:
        print(response.body.toString());
        return response;
      case 201:
        print(response.body.toString());
        return response;
      case 400:
        print(response.body.toString());
        return response;
      case 401:
        Toast.show('Unauthorized User!!',
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.black);
        throw BadRequestException(response.body.toString());
        break;
      case 403:
        Toast.show('Internal server error !!',
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.black);
        throw UnauthorisedException(response.body.toString());
      case 500:
        print(response.body.toString());
        return response;
        break;
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
  _logOut(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Toast.show('Your session has expired, Please login to continue!',
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
        backgroundColor: Colors.blue);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);
  }
}
