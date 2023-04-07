import 'package:flutter/material.dart';

extension GetMaterialStateProperty on Color {
  MaterialStateProperty<Color> get getMaterialStateProperty =>
      MaterialStatePropertyAll<Color>(this);
}
