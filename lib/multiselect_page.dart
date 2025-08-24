import 'package:flutter/material.dart';
import 'package:check_object/model/house_object.dart';
import 'package:check_object/providers/multi_select_provider.dart';
import 'package:check_object/multiselect_formfield.dart';
import 'package:check_object/providers/house_objects.dart';
import 'package:check_object/selected_data.dart';
import 'package:provider/provider.dart';

class MultiselectPage extends StatefulWidget {
  final Function(bool)? onDone;

  const MultiselectPage({super.key, this.onDone});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MultiselectPage> {
  late List<HouseObject> dataList;
  List? selectedData;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dataList = context.read<HouseObjects>().houseObjects;
    selectedData = context.read<MultiSelectProvider>().data;
  }

  _saveForm() {
    var form = formKey.currentState!;
    form.save();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          verticalDirection: VerticalDirection.up,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: MultiSelectFormField(
                autovalidate: AutovalidateMode.onUserInteraction,
                chipBackGroundColor: const Color.fromARGB(255, 0, 70, 70),
                chipLabelStyle: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
                dialogTextStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                activeColor: const Color.fromARGB(255, 0, 70, 70),
                checkColor: Colors.white,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Заполните поле';
                  }
                  return null;
                },
                hintWidget: const Text('Нажмите...'),
                initialValue: selectedData,
                onSaved: (value) {
                  if (value == null) return;
                  setState(() {
                    selectedData = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SelectData(
                  saveForm: _saveForm,
                  dialogTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22),
                  activeColor: const Color.fromARGB(255, 0, 70, 70),
                  checkColor: Colors.white,
                  onDone: widget.onDone,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}