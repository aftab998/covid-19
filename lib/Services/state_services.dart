import 'dart:convert';

import 'package:covid19/Model/WorldStatesModel.dart';
import 'package:http/http.dart' as http;

import 'Utilies/app_url.dart';

class StateServices{

  Future<WorldStatesModel> fetchworldStatesRecord () async{
    final response = await http.get(Uri.parse(AppUrl.worldStateApi));
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      return WorldStatesModel.fromJson(data);
    }else{
      throw Exception('Error');
    }

  }

  Future<List<dynamic>> countriesListApi ()async{
    var data;
    final response = await http.get(Uri.parse(AppUrl.countriesList));

    if(response.statusCode == 200){
       data = jsonDecode(response.body);
      return data;
    }else{
      throw Exception('Error');
    }

  }

}