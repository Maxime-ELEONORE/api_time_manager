import 'package:flutter/material.dart';

class DateTimePickerCustom extends StatefulWidget {
  final Function(DateTime dateTime) onDateTimeSelected;
  final String titleButton;
  const DateTimePickerCustom(
      {super.key, required this.onDateTimeSelected, required this.titleButton});

  @override
  DateTimePickerState createState() => DateTimePickerState();
}

class DateTimePickerState extends State<DateTimePickerCustom> {
  DateTime selectedDate = DateTime.now();
  String titleButton = "";
  @override
  void initState() {
    super.initState();
    titleButton = widget.titleButton;
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );
    if (pickedTime == null) return;

    setState(() {
      selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });

    widget.onDateTimeSelected(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _selectDateTime(context),
      child: Text(titleButton),
    );
  }
}
