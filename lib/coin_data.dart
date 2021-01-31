import 'dart:convert';

import 'package:bitcoin_ticker/secrets.dart';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  final baseURL = 'https://rest.coinapi.io/v1';

  Future<dynamic> getCoinData({String from, String to}) async {
    print('Getting coin data');
    String url = '$baseURL/exchangerate/$from/$to';
    http.Response response = await http.get(
      url,
      headers: {"X-CoinAPI-Key": coinApiKey},
    );

    if (response.statusCode == 200) {
      var coinData = response.body;
      return jsonDecode(coinData);
    } else {
      print('Error in response');
      print(response.statusCode);
      print(response.reasonPhrase);
      print(response.body);
    }
  }
}
