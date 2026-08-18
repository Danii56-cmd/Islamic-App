import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_app/main.dart';

void main() {
  testWidgets('App renders all tabs on small phone without overflow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320 * 2.0, 640 * 2.0);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(MyApp), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Switch to Quran tab
    await tester.tap(find.text('QURAN'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);

    // Switch to Prayer tab
    await tester.tap(find.text('PRAYER'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);

    // Switch to More tab
    await tester.tap(find.text('MORE'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
  });

  testWidgets('App renders all tabs on tablet without overflow', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800 * 2.0, 1280 * 2.0);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(MyApp), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Switch to Quran tab
    await tester.tap(find.text('QURAN'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);

    // Switch to Prayer tab
    await tester.tap(find.text('PRAYER'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);

    // Switch to More tab
    await tester.tap(find.text('MORE'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
  });
}
