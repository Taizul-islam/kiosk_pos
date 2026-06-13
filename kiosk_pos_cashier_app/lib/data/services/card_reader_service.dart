import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CardReaderService extends GetxService {
  String _buffer = '';
  Timer? _timer;

  final _cardStreamController = StreamController<String>.broadcast();
  Stream<String> get cardScanned => _cardStreamController.stream;

  final isCardDetected = false.obs;
  final currentCardUid = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _startListening();
  }

  void _startListening() {
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    final char = _getCharFromKey(event.logicalKey);
    if (char == null) return false;

    // Enter key = card read complete
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _processCard(_buffer);
      _buffer = '';
      return true;
    }

    // Escape = cancel
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _buffer = '';
      isCardDetected.value = false;
      return true;
    }

    _buffer += char;

    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 300), () {
      if (_buffer.isNotEmpty) {
        _processCard(_buffer);
        _buffer = '';
      }
    });

    return true;
  }

  String? _getCharFromKey(LogicalKeyboardKey key) {
    // Use if-else chain instead of const map to avoid the warning
    final keyId = key.keyId;

    // Numbers 0-9
    if (keyId >= LogicalKeyboardKey.digit0.keyId &&
        keyId <= LogicalKeyboardKey.digit9.keyId) {
      return String.fromCharCode(
          48 + (keyId - LogicalKeyboardKey.digit0.keyId));
    }

    // Letters A-Z
    if (keyId >= LogicalKeyboardKey.keyA.keyId &&
        keyId <= LogicalKeyboardKey.keyZ.keyId) {
      return String.fromCharCode(
          65 + (keyId - LogicalKeyboardKey.keyA.keyId));
    }

    // Numpad numbers
    if (keyId >= LogicalKeyboardKey.numpad0.keyId &&
        keyId <= LogicalKeyboardKey.numpad9.keyId) {
      return String.fromCharCode(
          48 + (keyId - LogicalKeyboardKey.numpad0.keyId));
    }

    return null;
  }

  void _processCard(String data) {
    final trimmed = data.trim();
    if (trimmed.isEmpty) return;

    currentCardUid.value = trimmed;
    isCardDetected.value = true;
    _cardStreamController.add(trimmed);

    HapticFeedback.mediumImpact();

    Future.delayed(const Duration(seconds: 5), () {
      isCardDetected.value = false;
      currentCardUid.value = '';
    });
  }

  // For demo/testing: manually simulate a card scan
  void simulateCardScan(String cardUid) {
    _processCard(cardUid);
  }

  @override
  void onClose() {
    _timer?.cancel();
    _cardStreamController.close();
    super.onClose();
  }
}