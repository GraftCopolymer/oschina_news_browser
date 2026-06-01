import 'dart:async';

mixin FutureLoadMixin {
  Completer? _completer = null;

  void startLoad() {
    _completer = Completer();
  }

  void endLoad() {
    _completer?.complete();
    _completer = null;
  }

  Future? get loadingFuture => _completer?.future;

  bool isCompleted() {
    return _completer == null ? true : _completer!.isCompleted;
  }
}