import 'package:flutter/material.dart';

import '../../../app/core/utils/colors_manager.dart';
import '../../../app/core/utils/values_manager.dart';

class MyLocationInputField extends StatelessWidget {
  const MyLocationInputField({
    Key? key,
    required TextEditingController controller,
    required String hintText,
  })  : _controller = controller,
        _hintText = hintText,
        super(key: key);

  final TextEditingController _controller;
  final String _hintText;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final borderDecoration = OutlineInputBorder(
      borderRadius: BorderRadius.circular(width * ValuesManager.s0_05),
      borderSide: const BorderSide(
          color: ColorsManager.grey, width: ValuesManager.s0_5),
    );

    return SizedBox(
      height: width * ValuesManager.s0_1,
      child: TextFormField(
        decoration: InputDecoration(
          hintText: _hintText,
          enabledBorder: borderDecoration,
          focusedBorder: borderDecoration,
          border: borderDecoration,
        ),
        controller: _controller,
      ),
    );
  }
}
