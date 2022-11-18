import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputHandler {
  static bool initialized = false;

  static void initialize() {
    if (!initialized) {
      initialized = true;

      RawKeyboard.instance.addListener((event) {
      if (event.runtimeType == RawKeyUpEvent) {
        TraversalDirection? direction =
            event.logicalKey == LogicalKeyboardKey.arrowLeft ?
                TraversalDirection.left :
            event.logicalKey == LogicalKeyboardKey.arrowRight ?
                TraversalDirection.right :
            event.logicalKey == LogicalKeyboardKey.arrowUp ?
                TraversalDirection.up :
            event.logicalKey == LogicalKeyboardKey.arrowDown ?
                TraversalDirection.down :
                null;

        if (direction != null) {
          FocusManager.instance.primaryFocus?.focusInDirection(direction);
        }
      }
    });
    }
  }
}
