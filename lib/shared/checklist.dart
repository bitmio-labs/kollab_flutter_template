// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:kollab_template/model/ChecklistsModel.dart';

class ChecklistWidget extends StatelessWidget {
  final ChecklistModel model;
  final Function(String, bool) onToggle;

  ChecklistWidget({this.model, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          child: Text(model.name,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(fontWeight: FontWeight.w500)),
        ),
        Container(height: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: model.items.map((each) {
            return ChecklistRow(
                model: each,
                onToggle: onToggle != null
                    ? (isToggled) => onToggle(each.id, isToggled)
                    : null);
          }).toList(),
        ),
        Container(height: 30),
      ],
    );
  }
}

class ChecklistRow extends StatefulWidget {
  final ChecklistItemModel model;
  final Function(bool) onToggle;

  ChecklistRow({this.model, this.onToggle});

  @override
  State<StatefulWidget> createState() {
    return _ChecklistRowRow();
  }
}

class _ChecklistRowRow extends State<ChecklistRow> {
  bool changedValue;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(widget.model.name),
      value: changedValue != null ? changedValue : widget.model.is_checked,
      onChanged: (bool value) {
        if (widget.onToggle != null) {
          widget.onToggle(value);
          return;
        }

        setState(() {
          changedValue = value;
        });
      },
    );
  }
}
