import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_data_objects/run.dart';

void main() {
  group('Tests for Run class', () {
    // Test constants
    const french = Locale('fr');
    const englishUS = Locale('en', 'US');
    const chineseHans = Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');
    const chineseHansCN = Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN');
    const invalidLocale = Locale('xx');
    const testTextEnglish = 'Sample text';
    const testTextFrench = 'Texte exemple';
    const testTextChinese = '示例文本';

    test('Constructor initializes with correct properties for lang only code', () {
      final run = Run(lang: french, text: testTextFrench);
      expect(run.lang.languageCode, 'fr');
      expect(run.lang.countryCode, isNull);
      expect(run.lang.scriptCode, isNull);
      expect(run.languageCode, 'fr');
      expect(run.text, testTextFrench);
    });

    test('Constructor initializes with correct properties for lang and country code', () {
      final run = Run(lang: englishUS, text: testTextEnglish);
      expect(run.lang.languageCode, 'en');
      expect(run.lang.countryCode, 'US');
      expect(run.lang.scriptCode, isNull);
      expect(run.languageCode, 'en-US');
      expect(run.text, testTextEnglish);
    });

    test('Constructor initializes with correct properties for lang and script code', () {
      final run = Run(lang: chineseHans, text: testTextChinese);
      expect(run.lang.languageCode, 'zh');
      expect(run.lang.countryCode, isNull);
      expect(run.lang.scriptCode, 'Hans');
      expect(run.languageCode, 'zh-Hans');
      expect(run.text, testTextChinese);
    });

    test('Constructor initializes with correct properties for lang, script, and country code', () {
      final run = Run(lang: chineseHansCN, text: testTextChinese);
      expect(run.lang.languageCode, 'zh');
      expect(run.lang.countryCode, 'CN');
      expect(run.lang.scriptCode, 'Hans');
      expect(run.languageCode, 'zh-Hans-CN');
      expect(run.text, testTextChinese);
    });

    test('Constructor initializes with invalid locale', () {
      final run = Run(lang: invalidLocale, text: testTextEnglish);
      expect(run.lang.languageCode, 'xx');
      expect(run.lang.countryCode, isNull);
      expect(run.lang.scriptCode, isNull);
      expect(run.languageCode, 'xx');
      expect(run.text, testTextEnglish);
    });

    test('Constructor throws error when required parameters are missing', () {
      expect(
        () => Function.apply(Run.new, []),
        throwsA(isA<NoSuchMethodError>()),
      );
    });
  });
}