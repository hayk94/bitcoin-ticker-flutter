import 'dart:io' show Platform;

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String USD = '?';

  @override
  void initState() {
    getCoinData();
    super.initState();
  }

  Future<void> getCoinData() async {
    CoinData coinData = CoinData();
    var data = await coinData.getCoinData();
    print(data);
    if (data == null) {
      updateUI('Error getting');
    } else {
      double rate = data['rate'];
      updateUI(rate.toStringAsFixed(0));
    }
  }

  void updateUI(String exchangeRate) {
    setState(() {
      USD = exchangeRate;
    });
  }

  String selectedCurrency = 'USD';

  Widget getPlatformPicker() {
    return Platform.isIOS ? iOSPicker() : androidPicker();
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerChildren = currenciesList.map((e) => Text(e)).toList();
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (int value) {
        print(value);
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
      },
    );
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
          Padding(
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
                  '1 BTC = $USD USD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
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
