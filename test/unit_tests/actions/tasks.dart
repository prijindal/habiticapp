import 'package:test/test.dart';

import 'package:Habitter/actions/tasks.dart';
import 'package:Habitter/actions/base.dart';

main() {
  test('Check type of action', () {
    var action = new TaskAction();
    expect(action, new isInstanceOf<Action>());
  });
}
