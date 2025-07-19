import 'dart:async';

import 'package:betchya_frontend/src/routing/go_router_refresh_stream.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('notifies listeners when stream emits', () async {
    final controller = StreamController<int>();
    final refresh = GoRouterRefreshStream(controller.stream);

    var notified = false;
    refresh.addListener(() {
      notified = true;
    });

    controller.add(1);
    await Future<void>.delayed(Duration.zero); // let the event loop run

    expect(notified, isTrue);

    // Clean up
    refresh.dispose();
    await controller.close();
  });

  test('cancels subscription on dispose', () async {
    final controller = StreamController<int>();
    GoRouterRefreshStream(controller.stream).dispose();

    // After dispose, adding to the stream should not throw, but also not notify
    expect(() => controller.add(1), returnsNormally);

    await controller.close();
  });
}
