import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final Map<String, bool> filters;
  final Function(Map<String, bool>) onApplyFilters;

  const FilterScreen({
    Key? key,
    required this.filters,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late bool _isVegetarian;
  late bool _isVegan;
  late bool _isNonveg;

  @override
  void initState() {
    super.initState();
    _isVegetarian = widget.filters['isVegetarian'] ?? false;
    _isVegan = widget.filters['isVegan'] ?? false;
    _isNonveg = widget.filters['isNonveg'] ?? false;
  }

  void _applyFilters() {
    widget.onApplyFilters({
      'isVegetarian': _isVegetarian,
      'isVegan': _isVegan,
      'isNonveg': _isNonveg,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.brown[200],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select Filters',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Vegetarian'),
            subtitle: const Text('Show only vegetarian recipes'),
            value: _isVegetarian,
            onChanged: (value) {
              setState(() {
                _isVegetarian = value;
                _applyFilters(); // Apply filters in real-time
              });
            },
            activeColor: Color.fromARGB(255, 136, 0, 0),
            activeTrackColor: Colors.brown[100],
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.black12,
          ),
          SwitchListTile(
            title: const Text('Vegan'),
            subtitle: const Text('Show only vegan recipes'),
            value: _isVegan,
            onChanged: (value) {
              setState(() {
                _isVegan = value;
                _applyFilters(); // Apply filters in real-time
              });
            },
            activeColor: const Color.fromARGB(255, 136, 0, 0),
            activeTrackColor: Colors.brown[100],
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.black12,
          ),
          SwitchListTile(
            title: const Text('Non-Vegetarian'),
            subtitle: const Text('Show only non-vegetarian recipes'),
            value: _isNonveg,
            onChanged: (value) {
              setState(() {
                _isNonveg = value;
                _applyFilters(); // Apply filters in real-time
              });
            },
            activeColor: Color.fromARGB(255, 136, 0, 0),
            activeTrackColor: Colors.brown[100],
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.black12,
          ),
        ],
      ),
    );
  }
}
