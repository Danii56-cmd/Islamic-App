import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_app/providers/location_provider.dart';
import 'package:islamic_app/providers/qibla_provider.dart';
import 'package:islamic_app/screens/qibla/qiblafinder_screen.dart';
import 'package:islamic_app/widgets/qibla_widgets/qibla_map_view.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('QiblaFinderScreen renders correctly with QiblaProvider', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360 * 2.0, 690 * 2.0);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocationProvider()),
          ChangeNotifierProvider(create: (_) => QiblaProvider()),
        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 690),
          builder: (context, child) {
            return const MaterialApp(
              home: QiblaFinderScreen(),
            );
          },
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(QiblaFinderScreen), findsOneWidget);
    expect(find.text('Compass'), findsOneWidget);
    expect(find.text('Map'), findsOneWidget);

    // Switch to Map tab
    await tester.tap(find.text('Map'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(QiblaMapView), findsOneWidget);

    // Switch back to Compass tab
    await tester.tap(find.text('Compass'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
  });
}
