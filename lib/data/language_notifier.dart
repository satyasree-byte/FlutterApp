import 'package:flutter/material.dart';

// Global language toggle — false = English, true = Hinglish
final ValueNotifier<bool> isHinglish = ValueNotifier(false);

String t(String english, String hinglish) =>
    isHinglish.value ? hinglish : english;
