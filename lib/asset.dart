import 'dart:async';

import 'package:flutter/services.dart';
import 'package:multi_image_picker/picker.dart';

class Asset {
  String _identifier;
  ByteData thumbData;
  ByteData imageData;

  Asset(this._identifier);

  String get _channel {
    return 'multi_image_picker/image/$_identifier';
  }

  Future<dynamic> requestThumbnail(int width, int height) {
    Completer completer = new Completer();
    BinaryMessages.setMessageHandler(_channel, (ByteData message) {
      thumbData = message;
      completer.complete(message);
      BinaryMessages.setMessageHandler(_channel, null);
    });

    MultiImagePicker.requestThumbnail(_identifier, width, height);
    return completer.future;
  }

  Future<dynamic> requestOriginal() {
    Completer completer = new Completer();
    BinaryMessages.setMessageHandler(_channel, (ByteData message) {
      imageData = message;
      completer.complete(message);
      BinaryMessages.setMessageHandler(_channel, null);
    });

    MultiImagePicker.requestOriginal(_identifier);
    return completer.future;
  }
}
