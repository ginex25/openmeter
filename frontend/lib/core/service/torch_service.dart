import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/constant/log.dart';

part 'torch_service.g.dart';

class TorchService {
  static const _channel = MethodChannel('com.example.openmeter/main');
  static const _enableTorch = 'turnOn';
  static const _disableTorch = 'turnOff';
  static const _torchAvailable = 'hasFlashlight';

  bool _torch = false;

  bool? _isAvailable;

  bool get stateTorch => _torch;

  Future<bool?> _isTorchAvailable() async {
    try {
      _isAvailable = await _channel.invokeMethod(_torchAvailable) as bool;
      return _isAvailable;
    } on PlatformException catch (e) {
      log(e.message ?? '', name: LogNames.torchHandler);
      _isAvailable = false;
      return false;
    }
  }

  Future<bool> getTorch({bool isInit = false}) async {
    if (_isAvailable == null) {
      bool? torchAvailable = await _isTorchAvailable();

      if (torchAvailable == null || torchAvailable == false) {
        return false;
      }
    }

    if (_isAvailable != null && _isAvailable == false) {
      return false;
    }

    if (!isInit) {
      _toggleTorch();
    }

    if (_torch) {
      try {
        await _channel.invokeMethod(_enableTorch);
        return true;
      } on PlatformException catch (e) {
        _torch = false;
        log(e.message ?? '', name: LogNames.torchHandler);
      }
    } else {
      try {
        await _channel.invokeMethod(_disableTorch);
        return true;
      } on PlatformException catch (e) {
        _torch = false;
        log(e.message ?? '', name: LogNames.torchHandler);
      }
    }

    return false;
  }

  _toggleTorch() {
    _torch = !_torch;
  }

  void setStateTorch(bool state) {
    _torch = state;
  }
}

@riverpod
TorchService torchService(Ref ref) {
  throw UnimplementedError();
}
