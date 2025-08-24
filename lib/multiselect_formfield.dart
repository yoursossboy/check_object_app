import 'package:flutter/material.dart';
import 'package:check_object/providers/multi_select_provider.dart';
import 'package:provider/provider.dart';

class MultiSelectFormField extends FormField<dynamic> {
  final Widget hintWidget;
  final bool required;
  final String errorText;
  final Color? fillColor;
  final TextStyle? chipLabelStyle;
  final Color? chipBackGroundColor;
  final TextStyle dialogTextStyle;
  final Color? checkColor;
  final Color? activeColor;
  @override
  final bool enabled;

  MultiSelectFormField({super.key, 
    FormFieldSetter<dynamic>? onSaved,
    FormFieldValidator<dynamic>? validator,
    dynamic initialValue,
    AutovalidateMode autovalidate = AutovalidateMode.disabled,
    this.hintWidget = const Text('Выберите что-нибудь уже'),
    this.required = false,
    this.errorText = 'Заполните поле',
    this.fillColor,
    this.chipLabelStyle,
    this.enabled = true,
    this.chipBackGroundColor,
    this.dialogTextStyle = const TextStyle(),
    this.activeColor,
    this.checkColor,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidate,
          builder: (FormFieldState<dynamic> state) {
            final List<String> selectedOptions =
                state.context.read<MultiSelectProvider>().data;

            return InputDecorator(
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.backspace,
                  ),
                  onPressed: state.value == null
                      ? null
                      : () {
                          List<String> newItems = [];
                          newItems.addAll(state.value);
                          newItems.removeLast();
                          state.context.read<MultiSelectProvider>().data =
                              newItems;
                          state.didChange(newItems);
                          state.save();
                        },
                ),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    borderSide: BorderSide(color: Colors.blue)),
                filled: true,
                errorText: state.hasError ? state.errorText : null,
                errorMaxLines: 4,
                fillColor: fillColor ?? Theme.of(state.context).canvasColor,
              ),
              isEmpty: state.value == null || state.value == '',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  state.value != null && state.value.length > 0
                      ? Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: selectedOptions
                              .map((e) => Chip(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    clipBehavior: Clip.none,
                                    labelStyle: chipLabelStyle,
                                    backgroundColor: chipBackGroundColor,
                                    label: Text(
                                      e,
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                    ),
                                  ))
                              .toList(),
                        )
                      : Container(
                          padding: const EdgeInsets.only(top: 4),
                          child: hintWidget,
                        )
                ],
              ),
            );
          },
        );
}
