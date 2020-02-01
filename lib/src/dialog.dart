import 'package:flutter/material.dart';
import 'package:flutter_country_code_picker/src/country.dart';

/// selection dialog used for selection of the country code
class CountryPickerDialog extends StatefulWidget {
  final List<Country> countries;
  final bool showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle searchStyle;
  final WidgetBuilder emptySearchBuilder;
  final bool showFlag;
  final List<Country> favouriteCountries;
  final String searchLabel;

  CountryPickerDialog(
    this.countries, {
    this.favouriteCountries,
    Key key,
    this.showCountryOnly,
    this.emptySearchBuilder,
    this.searchDecoration,
    this.searchStyle,
    this.showFlag,
    this.searchLabel = "Search countries",
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  /// this is useful for filtering purpose
  List<Country> filteredCountries;

  @override
  void initState() {
    filteredCountries = widget.countries;
    super.initState();
  }

  int get _listLength {
    var length = 0;
    if (widget.favouriteCountries.isNotEmpty) {
      length++;
    }

    if (filteredCountries.isEmpty) {
      length++;
    } else {
      length += filteredCountries.length;
    }

    return length;
  }

  Widget _buildListElement(BuildContext context, int index) {
    if (widget.favouriteCountries.isNotEmpty) {
      if (index == 0) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[]
              ..addAll(widget.favouriteCountries
                  .map(
                    (f) => SimpleDialogOption(
                      child: _buildCountry(f),
                      onPressed: () {
                        _selectCountry(f);
                      },
                    ),
                  )
                  .toList())
              ..add(const Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: const Divider(),
              )));
      } else {
        index--;
      }
    }

    if (filteredCountries.isEmpty) {
      if (index == 0) {
        return _buildEmptySearchWidget(context);
      } else {
        index--;
      }
    }

    final country = filteredCountries[index];

    return SimpleDialogOption(
      key: Key(country.toLongString()),
      child: _buildCountry(country),
      onPressed: () {
        _selectCountry(country);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      title: TextField(
        style: widget.searchStyle,
        decoration: (widget.searchDecoration ?? InputDecoration()).copyWith(
          labelText: widget.searchLabel,
        ),
        onChanged: _filterElements,
      ),
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: _listLength,
            itemBuilder: _buildListElement,
          ),
        ),
      ],
    );
  }

  Widget _buildCountry(Country country) {
    return Container(
      height: 32,
      child: Row(
        children: <Widget>[
          widget.showFlag
              ? Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Image.asset(
                    country.flagUri,
                    package: 'flutter_country_code_picker',
                    width: 32.0,
                  ),
                )
              : Container(),
          Expanded(
            child: Text(
              country.name,
            ),
          ),
          SizedBox(width: 8),
          Text(country.dialCode)
        ],
      ),
    );
  }

  Widget _buildEmptySearchWidget(BuildContext context) {
    if (widget.emptySearchBuilder != null) {
      return widget.emptySearchBuilder(context);
    }

    return Center(child: Text('No Country Found'));
  }

  void _filterElements(String value) {
    if (value.isEmpty) {
      setState(() {
        filteredCountries = widget.countries;
      });
      return;
    }

    value = value.toUpperCase();
    setState(() {
      filteredCountries = widget.countries
          .where(
            (country) =>
                country.code.contains(value) ||
                country.dialCode.contains(value) ||
                country.name.toUpperCase().contains(value),
          )
          .toList();
    });
  }

  void _selectCountry(Country country) {
    Navigator.pop(context, country);
  }
}
