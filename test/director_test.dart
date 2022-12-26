import 'package:flutter_test/flutter_test.dart';
import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/core/scene.dart';
import 'package:visual_novel/core/verse.dart';

void main() {
  test('runAction with dummy id and empty list', () {
    expect(() => Director().runAction('dummy_id', []), throwsAssertionError);
  });

  test('runAction with unacceptable arguments', () async {
    assert(Director().getFunctionById('next_scene') != () {});
    expect(await Director().runAction('next_scene', [1, 2, 3]), false);
  });
  test('runAction with acceptable arguments', () async {
    expect(
        await Director()
            .runAction('next_scene', [Director().getSceneById('test_scene')]),
        true);
  });

  test('trying to set variable of unacceptable type', () async {
    expect(() => Director().setVariable('dummy_id', <Object>[Object()]),
        throwsAssertionError);
  });

  test('trying to set variable of acceptable type', () async {
    // Test with bool type
    Director().setVariable<bool>('dummy_bool', true);
    expect(Director().getVariable('dummy_bool'), true);

    // Test with int type
    Director().setVariable<int>('dummy_int', 42);
    expect(Director().getVariable('dummy_int'), 42);

    // Test with double type
    Director().setVariable<double>('dummy_double', 3.14);
    expect(Director().getVariable('dummy_double'), 3.14);

    // Test with String type
    Director().setVariable<String>('dummy_string', 'hello');
    expect(Director().getVariable('dummy_string'), 'hello');

    // Test with List type
    Director().setVariable<List>('dummy_list', [42, 3.14, 'hello', true]);
    expect(Director().getVariable('dummy_list'), [42, 3.14, 'hello', true]);
  });
}
