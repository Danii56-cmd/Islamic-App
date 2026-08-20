import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/providers/fontsize_provider.dart';
import 'package:provider/provider.dart';
import 'package:islamic_app/providers/duas_provider.dart';
import 'package:islamic_app/providers/location_provider.dart';
import 'package:islamic_app/providers/prayer_provider.dart';
import 'package:islamic_app/providers/quran_provider.dart';
import 'package:islamic_app/screens/mainscreen/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final fontSizeProvider = FontSizeProvider();
  await fontSizeProvider.load();

  runApp(MyApp(fontSizeProvider: fontSizeProvider));
}

class MyApp extends StatelessWidget {
  final FontSizeProvider fontSizeProvider;

  const MyApp({super.key, required this.fontSizeProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocationProvider()..fetchLocation(),
        ),
        ChangeNotifierProxyProvider<LocationProvider, PrayerProvider>(
          create: (ctx) =>
              PrayerProvider()
                ..fetchTimings(latitude: 33.6844, longitude: 73.0479),
          update: (ctx, locationProvider, prayerProvider) {
            final loc = locationProvider.location;
            if (loc != null && prayerProvider != null) {
              if (prayerProvider.timings == null) {
                prayerProvider.fetchTimings(
                  latitude: loc.latitude,
                  longitude: loc.longitude,
                );
              }
            }
            return prayerProvider ?? PrayerProvider();
          },
        ),
        ChangeNotifierProvider(create: (_) => QuranProvider()..init()),
        ChangeNotifierProvider(create: (_) => DuasProvider()..init()),
        ChangeNotifierProvider.value(value: fontSizeProvider),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            final fontProvider = context.watch<FontSizeProvider>();
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(fontProvider.scale)),
              child: child!,
            );
          },
          home: const MainScreen(),
        ),
      ),
    );
  }
}
