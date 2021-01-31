import 'dart:io' show Platform;

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  Map<String, String> convertedValues = {};
  bool isWaiting = false;

  @override
  void initState() {
    getCoinData();
    super.initState();
  }

  Future<void> getCoinData() async {
    isWaiting = true;
    CoinData coinData = CoinData();
    Map<String, String> coinValues = {};
    for (String crypto in cryptoList) {
      var data = await coinData.getCoinData(from: crypto, to: selectedCurrency);
      if (data == null) {
        coinValues[crypto] = 'Error getting';
      } else {
        double rate = data['rate'];
        coinValues[crypto] = rate.toStringAsFixed(0);
      }
    }
    isWaiting = false;

    setState(() {
      convertedValues = coinValues;
    });
  }

  Widget getPlatformPicker() {
    return Platform.isIOS ? iOSPicker() : androidPicker();
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerChildren = currenciesList.map((e) => Text(e)).toList();
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (int index) {
        setState(() {
          selectedCurrency = currenciesList[index];
        });
        getCoinData();
      },
      children: pickerChildren,
    );
  }

  DropdownButton<String> androidPicker() {
    List<DropdownMenuItem<String>> items = currenciesList
        .map((e) => DropdownMenuItem(child: Text(e), value: e))
        .toList();

    return DropdownButton(
      value: selectedCurrency,
      items: items,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
        getCoinData();
      },
    );
  }

  List<CoinExchangeCard> getCoinExchangeCardList() {
    return cryptoList
        .map((e) => CoinExchangeCard(
              convertedValue: isWaiting ? '?' : convertedValues[e],
              selectedCurrency: selectedCurrency,
              cryptoName: e,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: getCoinExchangeCardList(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPlatformPicker(),
          ),
        ],
      ),
    );
  }
}

class CoinExchangeCard extends StatelessWidget {
  const CoinExchangeCard({
    Key key,
    @required this.convertedValue,
    @required this.selectedCurrency,
    @required this.cryptoName,
  }) : super(key: key);

  final String convertedValue;
  final String selectedCurrency;
  final String cryptoName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoName = $convertedValue $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
