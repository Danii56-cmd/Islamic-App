import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app/core/app_theme.dart';
import 'package:islamic_app/providers/duas_provider.dart';
import 'package:islamic_app/providers/favourites_provider.dart';
import 'package:islamic_app/providers/fontsize_provider.dart';
import 'package:islamic_app/providers/location_provider.dart';
import 'package:islamic_app/providers/prayer_provider.dart';
import 'package:islamic_app/providers/qibla_provider.dart';
import 'package:islamic_app/providers/quran_provider.dart';
import 'package:islamic_app/providers/theme_provider.dart';
import 'package:islamic_app/screens/mainscreen/main_screen.dart';
import 'package:provider/provider.dart';

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
        // THEME
        ChangeNotifierProvider(create: (_) => ThemeChangerProvider()),

        // LOCATION
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),

        // QIBLA
        ChangeNotifierProvider(create: (_) => QiblaProvider()),

        // PRAYER
        ChangeNotifierProxyProvider<LocationProvider, PrayerProvider>(
          create: (_) {
            return PrayerProvider()
              ..fetchTimings(latitude: 33.6844, longitude: 73.0479);
          },
          update: (context, locationProvider, prayerProvider) {
            final location = locationProvider.location;

            if (location != null &&
                prayerProvider != null &&
                prayerProvider.timings == null) {
              prayerProvider.fetchTimings(
                latitude: location.latitude,
                longitude: location.longitude,
              );
            }
            return prayerProvider ?? PrayerProvider();
          },
        ),

        // QURAN
        ChangeNotifierProvider(create: (_) => QuranProvider()..init()),

        // DUAS
        ChangeNotifierProvider(create: (_) => DuasProvider()..init()),

        // FONT SIZE
        ChangeNotifierProvider.value(value: fontSizeProvider),
        // FAVOURITES AYAH AND DUAAS
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],

      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,

        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            // THEMES
            theme: AppTheme.lightTheme,
            themeMode: context.watch<ThemeChangerProvider>().themeMode,
            darkTheme: ThemeData(brightness: Brightness.dark),

            // FONT SIZE
            builder: (context, child) {
              final fontProvider = context.watch<FontSizeProvider>();
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(fontProvider.scale)),
                child: child!,
              );
            },

            // HOME
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
