import 'package:flutter/material.dart';
import 'package:flutter_country_code_picker/flutter_country_code_picker.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatefulWidget {
  @override
  _ExampleAppState createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Country Picker Example'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CountryCodePicker(
                    onChanged: print,
                    // Initial selection and favorite can be one of code ('IT') OR dial_code ('+39')
                    initialCountry: 'IT',
                    favorites: ['+39', 'FR'],
                    //Get the country information relevant to the initial selection
                    onInit: (code) => print("${code.name} ${code.dialCode}"),
                  ),
                  SizedBox(
                    width: 400,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CountryCodePicker(
                        onChanged: print,
                        initialCountry: 'TF',
                        showCountryOnly: true,
                        showCountryName: true,
                        alignLeft: true,
                        builder: (countryCode) {
                          return Text('${countryCode.code}');
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 400,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CountryCodePicker(
                          onChanged: print,
                          initialCountry: 'TF',
                          showCountryOnly: true,
                          showCountryName: true,
                          favorites: ['+39', 'FR']),
                    ),
                  ),
                ],
              ),
            )));
  }
}
