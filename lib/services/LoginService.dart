import 'dart:async';
import 'dart:convert';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appvts/services/FetchAppointmentList.dart';
import 'package:http/http.dart' as http;
import 'package:appvts/Globals.dart';
Token t;
Future<void> getNameFromOffice() async {
  String reduri = "https://10.0.2.2:9000";
  http.Response response;
  http.Response details;
  String code;
  String url = "https://login.microsoftonline.com/9b0861df-ad09-47df-b4d4-9a00828ab9f0/oauth2/v2.0/authorize?client_id=5a5a0c69-278b-46a0-921d-e1d6c11bf7b6&response_type=code&redirect_uri="+
      Uri.encodeFull(reduri)+"&response_mode=query&scope=https://graph.microsoft.com/offline_access&state=12345";
 //String url ="https://login.microsoftonline.com/9b0861df-ad09-47df-b4d4-9a00828ab9f0/oauth2/authorize?response_type=id_token&client_id=45ec14c2-0179-4d81-8170-ae485bcdc078&redirect_uri=https%3A%2F%2Fhrms.senecaglobal.com%2F&state=SomeState&nonce=SomeNonce";
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  flutterWebviewPlugin.launch(url);
  flutterWebviewPlugin.onUrlChanged.listen((String url) async{
    if(url.length > 25) {
      int no = url.indexOf("&state");
      if (url.substring(23).startsWith("code")) {
        code = url.substring(28, no);
        flutterWebviewPlugin.close();
        response = await http.post(
            "https://login.microsoftonline.com/9b0861df-ad09-47df-b4d4-9a00828ab9f0/oauth2/v2.0/token",
            body: {
              "client_id": "5a5a0c69-278b-46a0-921d-e1d6c11bf7b6",
              "scope": "https://graph.microsoft.com/offline_access",
              "code": code,
              "redirect_uri": "https://10.0.2.2:9000",
              "grant_type": "authorization_code",
              "client_secret": "Tb3nGhH6U-ZzwHsjUI4OBZ]9EOFvge?.",
            }
        );
//     response = await http.post(
//       "https://login.microsoftonline.com/9b0861df-ad09-47df-b4d4-9a00828ab9f0/oauth2/v2.0/token",
//       body:{
//         "client_id": "45ec14c2-0179-4d81-8170-ae485bcdc078",
//      //   "scope": "https://graph.microsoft.com/offline_access",
//         "code": code,
//         "redirect_uri": "https%3A%2F%2Fhrms.senecaglobal.com%2F",
//         "grant_type": "authorization_code",
//        // "client_secret": "Tb3nGhH6U-ZzwHsjUI4OBZ]9EOFvge?.",
//       }
//     );

        final jresp = json.decode(response.body);
        print(response.body);
        t = new Token.fromJson(jresp);
        details = await http.get(
            "https://graph.microsoft.com/v1.0/me",
            headers: {"Authorization": "Bearer " + t.access_token}
        );
        final bjresp = json.decode(details.body);
        String name = bjresp["displayName"].toString();
        print(details.body);
        username = name;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username',name);
        String phone = bjresp["businessPhones"].toString();
        prefs.setString('phone', phone.substring(1,phone.length-1));
          try {
          var resp = await http.get('http://192.168.1.101:81/VTS-Dev-Service/api/appointment/getLoggedInUser?username='+name);
            var data = resp.body;
            var role = data.toString().substring((data.toString().lastIndexOf('|'))+1,data.toString().length);
            if(role.contains('Admin')){
              role='admin';
              prefs.setString('role', role);
              isAdmin = true;
            }
          } catch (error) {
            print(error);
          }
      }
    }
  });
}

class Token{
  String access_token;
  Token({this.access_token});
  factory Token.fromJson(Map<String, dynamic> parsedJson){
    return Token(
      access_token: parsedJson['access_token'],
    );
  }
}