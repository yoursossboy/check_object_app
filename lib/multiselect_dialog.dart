import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:check_object/providers/multi_select_provider.dart';
import 'package:provider/provider.dart';

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.finish);

  final V value;
  final bool finish;
}

class MultiSelectDialog<V> extends StatefulWidget {
  final List<MultiSelectDialogItem<V>>? items;
  final List<V>? initialSelectedValues;
  final Widget? title;
  final TextStyle labelStyle;
  final Color? checkColor;
  final Color? activeColor;
  final VoidCallback? saveForm;

  const MultiSelectDialog(
      {super.key,
      this.items,
      this.initialSelectedValues,
      this.title,
      this.labelStyle = const TextStyle(),
      this.activeColor,
      this.checkColor,
      this.saveForm});

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = <V>[];
final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues!);
    }
  }
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _onItemCheckedChange(V itemValue) {
    context.read<MultiSelectProvider>().add(itemValue.toString());
    setState(() {
      _selectedValues.add(itemValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
          shrinkWrap: true,
          children: widget.items!.map(_buildItem).toList(),
        );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    // final checked = _selectedValues.contains(item.value);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        child: Container(
          constraints: const BoxConstraints(minHeight: 50),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 0, 70, 70),
              ),
              borderRadius: BorderRadius.circular(16),
              color: widget.checkColor),
          child: item.finish
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(CupertinoIcons.building_2_fill),
                    Expanded(
                      child: Text(
                        ' ${item.value!}',
                        textAlign: TextAlign.center,
                        style: widget.labelStyle,
                        maxLines: 3,
                        overflow: TextOverflow.visible,
                        softWrap: true,
                      ),
                    ),
                  ],
                )
              : Text(
                  item.value!.toString(),
                  textAlign: TextAlign.center,
                  style: widget.labelStyle,
                  maxLines: 3,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
        ),
        onTap: () {
          _onItemCheckedChange(item.value);
          widget.saveForm!();
        },
      ),
    );
  }
}
