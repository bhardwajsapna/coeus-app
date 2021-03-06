import 'package:coeus_v1/utils/const.dart';
import 'package:coeus_v1/widget/inputEmail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  String title;
  int? font;
  TextEditingController? controller;
  Color? color;
  DatePickerWidget(
      {required this.title, this.controller, this.color, this.font});
  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? date;

  String getText() {
    if (date == null) {
      return widget.title;
    } else {
      widget.controller!.text = DateFormat('yyyy-MM-dd').format(date!);
      return widget.title + ": " + DateFormat('yyyy-MM-dd').format(date!);
      // return '${date.month}/${date.day}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) => ButtonHeaderWidget(
        title: 'Date',
        text: getText(),
        color: widget.color != null ? widget.color! : Constants.backgroundColor,
        onClicked: () => pickDate(context),
        font: widget.font != null ? widget.font! : 22,
      );
/*
06 aug 21
ns - changed start date to 1930 yrs 
*/
  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: date ?? initialDate,
      firstDate: DateTime(1930),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (newDate == null) return;

    setState(() => date = newDate);
  }
}

class ButtonHeaderWidget extends StatelessWidget {
  final String title;
  final String text;
  final VoidCallback onClicked;
  final Color color;
  final int font;

  const ButtonHeaderWidget({
    Key? key,
    required this.title,
    required this.text,
    required this.onClicked,
    required this.color,
    required this.font,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => HeaderWidget(
        title: title,
        child: ButtonWidget(
          text: text,
          onClicked: onClicked,
          color: color,
          font: font,
        ),
      );
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final Color color;
  final int font;
  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
    required this.color,
    required this.font,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(40),
            primary: this.color,
          ),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: TextStyle(
                  fontSize: this.font.toDouble(), color: Constants.textPrimary),
            ),
          ),
          onPressed: onClicked,
        ),
      );
}

class HeaderWidget extends StatelessWidget {
  final String title;
  final Widget child;

  const HeaderWidget({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          child,
        ],
      );
}
