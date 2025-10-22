import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';

class CountryCodeSelector extends StatefulWidget {
  final ValueChanged<Country> onChanged;
  final Country initialCountry;
  
  const CountryCodeSelector({
    Key? key,
    required this.onChanged,
    required this.initialCountry,
  }) : super(key: key);

  @override
  _CountryCodeSelectorState createState() => _CountryCodeSelectorState();
}

class _CountryCodeSelectorState extends State<CountryCodeSelector> {
  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialCountry;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openCountryPickerDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CountryPickerUtils.getDefaultFlagImage(_selectedCountry),
            const SizedBox(width: 8),
            Text(
              '+${_selectedCountry.phoneCode ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _openCountryPickerDialog() {
    showDialog(
      context: context,
      builder: (context) => CountryPickerDialog(
        titlePadding: const EdgeInsets.all(8.0),
        searchInputDecoration: const InputDecoration(
          hintText: 'Buscar país...',
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(8),
        ),
        isSearchable: true,
        title: const Text('Selecciona tu país'),
        onValuePicked: (Country country) {
          setState(() {
            _selectedCountry = country;
          });
          widget.onChanged(country);
        },
        itemBuilder: (country) => _buildDialogItem(country),
        priorityList: [
          CountryPickerUtils.getCountryByIsoCode('AR'), // Argentina
          CountryPickerUtils.getCountryByIsoCode('US'), // Estados Unidos
          CountryPickerUtils.getCountryByIsoCode('ES'), // España
          CountryPickerUtils.getCountryByIsoCode('MX'), // México
          CountryPickerUtils.getCountryByIsoCode('CO'), // Colombia
        ],
      ),
    );
  }

  Widget _buildDialogItem(Country country) {
    return Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            country.name,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          "+${country.phoneCode}",
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
