import 'package:flutter/services.dart';
import 'package:surf2sawa/utils/extensions.dart';

class TimeFormatter {
  String timeLeft(int time) {
    int minutes = (time / 60).truncate();
    String minStr = (minutes % 60).toString().padLeft(2, '0');
    String secStr = (time % 60).toString().padLeft(2, '0');
    return "$minStr:$secStr";
  }
}

class AccountFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();

    if (oldValue.selection.baseOffset == 0 &&
        newValue.selection.baseOffset == 0) {
      return TextEditingValue.empty;
    }
    if (newValue.text.length > oldValue.text.length &&
        (newValue.text == "6" || newValue.text.characters.first == "6")) {
      return oldValue;
    }
    if (newTextLength >= 4) {
      newText.write('${newValue.text.substring(0, usedSubstringIndex = 3)} ');
      if (newValue.selection.end >= 3) selectionIndex += 1;
    }
    if (newTextLength >= 8) {
      newText.write('${newValue.text.substring(3, usedSubstringIndex = 7)} ');
      if (newValue.selection.end >= 7) selectionIndex += 1;
    }
    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
