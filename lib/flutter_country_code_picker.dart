import 'package:flutter/material.dart';
import 'package:flutter_country_code_picker/src/countries.dart';
import 'package:flutter_country_code_picker/src/country.dart';
import 'package:flutter_country_code_picker/src/dialog.dart';

class CountryCodePicker extends StatefulWidget {
  /// Called when new country is selected
  final ValueChanged<Country> onChanged;

  /// Called on initial load with the initialCountry's country
  final ValueChanged<Country> onInit;

  final String initialCountry;
  final List<String> favorites;

  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final bool showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle searchStyle;
  final WidgetBuilder emptySearchBuilder;
  final Function(Country) builder;

  /// Shows the country name instead of it's dial code
  final bool showCountryName;

  /// Aligns the widget to the left and fills the available space.
  ///
  /// This is useful in combination with [showCountryName]
  /// to display longer country names on one line
  final bool alignLeft;

  /// Shows the country's flag
  final bool showFlag;

  /// Filters the displayed country list with these country codes or dial code
  final List<String> countryFilter;

  CountryCodePicker({
    this.onChanged,
    this.onInit,
    this.initialCountry,
    this.favorites = const [],
    this.countryFilter,
    this.textStyle,
    this.padding = EdgeInsets.zero,
    this.showCountryOnly = false,
    this.searchDecoration = const InputDecoration(),
    this.searchStyle,
    this.emptySearchBuilder,
    this.showCountryName = false,
    this.alignLeft = false,
    this.showFlag = true,
    this.builder,
  });

  @override
  State<StatefulWidget> createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePicker> {
  Country selectedCountry;
  List<Country> favoriteElements = [];

  List<Country> getCountries() {
    if (widget.countryFilter != null && widget.countryFilter.length > 0) {
      return countries
          .where((country) => widget.countryFilter.contains(country.code))
          .toList();
    }

    return countries;
  }

  @override
  Widget build(BuildContext context) {
    Widget _widget;
    if (widget.builder != null)
      _widget = InkWell(
        onTap: _showSelectionDialog,
        child: widget.builder(selectedCountry),
      );
    else {
      _widget = FlatButton(
        padding: widget.padding,
        onPressed: _showSelectionDialog,
        child: Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            widget.showFlag
                ? Flexible(
                    flex: widget.alignLeft ? 0 : 1,
                    fit: widget.alignLeft ? FlexFit.tight : FlexFit.loose,
                    child: Padding(
                      padding: widget.alignLeft
                          ? const EdgeInsets.only(right: 16.0, left: 8.0)
                          : const EdgeInsets.only(right: 16.0),
                      child: Image.asset(
                        selectedCountry.flagUri,
                        package: 'flutter_country_code_picker',
                        width: 32.0,
                      ),
                    ),
                  )
                : Container(),
            Flexible(
              fit: widget.alignLeft ? FlexFit.tight : FlexFit.loose,
              child: Text(
                widget.showCountryName
                    ? selectedCountry.toCountryStringOnly()
                    : selectedCountry.toString(),
                style: widget.textStyle ?? Theme.of(context).textTheme.button,
              ),
            ),
          ],
        ),
      );
    }
    return _widget;
  }

  @override
  void didUpdateWidget(CountryCodePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialCountry != widget.initialCountry) {
      final countries = getCountries();

      if (widget.initialCountry != null) {
        selectedCountry = countries.firstWhere(
          (country) => country.matches(widget.initialCountry),
          orElse: () => countries[0],
        );
      } else {
        selectedCountry = countries[0];
      }
    }
  }

  @override
  initState() {
    super.initState();

    final countries = getCountries();

    if (widget.initialCountry != null) {
      selectedCountry = countries.firstWhere(
        (country) => country.matches(widget.initialCountry),
        orElse: () => countries[0],
      );
    } else {
      selectedCountry = countries[0];
    }

    favoriteElements = countries
        .where(
          (country) => widget.favorites.any(
            (favourite) => country.matches(favourite),
          ),
        )
        .toList();

    // Trigger onInit after first paint (so setState can be used)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onInit != null) {
        widget.onInit(selectedCountry);
      }
    });
  }

  Future<void> _showSelectionDialog() async {
    final country = await showDialog(
      context: context,
      builder: (context) => CountryPickerDialog(
        getCountries(),
        favouriteCountries: favoriteElements,
        showCountryOnly: widget.showCountryOnly,
        emptySearchBuilder: widget.emptySearchBuilder,
        searchDecoration: widget.searchDecoration,
        searchStyle: widget.searchStyle,
        showFlag: widget.showFlag,
      ),
    );

    if (country != null) {
      setState(() {
        selectedCountry = country;
      });

      if (widget.onChanged != null) {
        widget.onChanged(country);
      }
    }
  }
}
