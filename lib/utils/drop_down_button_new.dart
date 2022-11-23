import 'package:flutter/material.dart';

class DropdownButtonNew extends StatefulWidget {
  final List<String> items;
  final ValueChanged<String?> onSelect;
  final IconData icon;
  final int flex;
  final String initValue;

  const DropdownButtonNew(
      {super.key,
      required this.items,
      required this.onSelect,
      required this.icon,
      required this.flex,
      required this.initValue});

  @override
  State<DropdownButtonNew> createState() => _DropdownButtonNewState();
}

class _DropdownButtonNewState extends State<DropdownButtonNew> {
  late String valueShow;
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      (widget.items.length == 0)
          ? valueShow = "null"
          : valueShow = widget.items.first;
    });
    super.initState();
  }

  late List<String> listNull = ["", " ", " "];
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton<String>(
          value: widget.initValue,
          icon: Icon(widget.icon),
          elevation: 16,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          isExpanded: true,
          onTap: () {},
          onChanged: (String? value) {
            widget.onSelect(value);
            setState(() {
              valueShow = value!;
            });
          },
          items: (widget.items.isEmpty)
              ? listNull.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, overflow: TextOverflow.ellipsis),
                  );
                }).toList()
              : widget.items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
        ),
      ),
    );
  }
}
