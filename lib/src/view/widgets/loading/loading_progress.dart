import 'dart:async';

import 'package:ladytabtab/exports_main.dart';

class LoadingProgress {
  LoadingProgress._sharedIntance();
  static final LoadingProgress _shared = LoadingProgress._sharedIntance();
  factory LoadingProgress.instance() => _shared;

  LoadingProgressController? _controller;

  void show({
    required BuildContext context,
    required String message,
  }) {
    if (_controller?.update(message) ?? false) {
      return;
    } else {
      _controller = _showDialog(context: context, message: message);
    }
  }

  LoadingProgressController _showDialog({
    required BuildContext context,
    required String message,
  }) {
    final textMsg = StreamController<String>();
    textMsg.add(message);

    return LoadingProgressController(
      close: () {
        textMsg.close();
        return true;
      },
      update: (textt) {
        textMsg.add(textt);

        return true;
      },
    );
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  // LoadingProgressController _controller;
}

typedef CloseLoadingProgress = bool Function();
typedef UpdateLoadingProgress = bool Function(String text);

@immutable
class LoadingProgressController {
  final CloseLoadingProgress close;
  final UpdateLoadingProgress update;

  const LoadingProgressController({
    required this.close,
    required this.update,
  });
}
