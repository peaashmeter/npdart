import 'package:flutter_test/flutter_test.dart';
import 'package:visual_novel/core/director.dart';
import 'package:visual_novel/core/scene.dart';
import 'package:visual_novel/core/verse.dart';

void main() {
  test('runAction with dummy id and empty list', () {
    expect(() => Director().runAction('dummy_id', []), throwsAssertionError);
  });

  test('runAction with unacceptable arguments', () async {
    assert(Director().getFunction('next_scene') != () {});
    expect(await Director().runAction('next_scene', [1, 2, 3]), false);
  });
  test('runAction with acceptable arguments', () async {
    expect(
        await Director()
            .runAction('next_scene', [Director().getScene('test_scene')]),
        true);
  });
}
