import 'package:flutter/material.dart';

class Item extends StatefulWidget {
  final Function(List<String>) onChanged;
  final List<String> selectedOptions;

  const Item({
    Key? key,
    required this.onChanged,
    required this.selectedOptions,
  }) : super(key: key);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  late List<String> _itemOptions;

  @override
  void initState() {
    super.initState();
    _itemOptions = [
      "Foods",
      "Clothes",
      "Cash",
      "Necessities",
      "Others",
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Items:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF01563F),
            ),
          ),
          SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _itemOptions.map((item) {
              return FilterChip(
                label: Text(
                  item,
                  style: TextStyle(
                    color: widget.selectedOptions.contains(item)
                        ? Colors.white
                        : Color(0xFFFFC107),
                  ),
                ),
                backgroundColor: widget.selectedOptions.contains(item)
                    ? Colors.blue
                    : Color(0xFF01563F),
                selected: widget.selectedOptions.contains(item),
                onSelected: (bool value) {
                  setState(() {
                    if (value) {
                      widget.selectedOptions.add(item);
                    } else {
                      widget.selectedOptions.remove(item);
                    }
                  });
                  widget.onChanged(widget.selectedOptions);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}