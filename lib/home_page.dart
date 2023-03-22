import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static String API_KEY = "c06d9164d89e46d889054514232103";
  String location = 'India';
  String weatherIcon = 'heavycloud.png';
  int temperature = 0;
  int windSpeed =0;
  int humidity = 0;
  int cloud = 0;
  String currentDate ='';

  List hourlyWeatherForeCast = [];
  List dailyWeatherForeCast = [];

  String currentWeatherStatus = '';

  String searchWeatherApPI = 'https://api.weatherapi.com/v1/forecast.json?key=' + API_KEY + "&days=&q=";

  @override
  void initState() {
    fetchWeatherData(location);
    super.initState();
  }

  void fetchWeatherData(String searchText) async{
    try{
      var searchResult = await http.get(Uri.parse(searchWeatherApPI + searchText));
      final weatherData = Map<String,dynamic>.from(
          json.decode(searchResult.body) ?? 'No Data');
      var locationData = weatherData["location"];
      var currentWeather = weatherData["current"];
      setState(() {
        location = getShortLocationName(locationData["name"]);

        var parsedDate = DateTime.parse(locationData["localtime"].substring(0,10));
        var newDate = DateFormat('dMMMMEEEE').format(parsedDate);
        currentDate= newDate;

        currentWeatherStatus = currentWeather["condition"]["text"];
        weatherIcon = currentWeatherStatus.replaceAll(' ', '').toLowerCase() + ".png";
        temperature = currentWeather['temp_c'].toInt();
      });
    }catch(e){

    }
  }

  static String getShortLocationName(String s){
    List<String>wordList = s.split(" ");

    if(wordList.isNotEmpty){
      if(wordList.length>1){
        return wordList[0] + " "+ wordList[1];
      }else{
        return wordList[0];
      }
    }else{
      return " ";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('Weather App'),
      ),
    );
  }
}
