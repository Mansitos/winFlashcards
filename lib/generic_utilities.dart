// In this file, generic functions are defined

import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() {
    if (this.length > 0) {
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    } else {
      return this;
    }
  }
}

String encodeBool(bool val) {
  if (val == true) {
    return "true";
  } else {
    return "false";
  }
}

bool decodeBool(String val) {
  if (val == "true") {
    return true;
  } else if (val == "false") {
    return false;
  } else {
    debugPrint("Error in decoding encoded bool: " + val + "    false will be returned!");
    return false;
  }
}
