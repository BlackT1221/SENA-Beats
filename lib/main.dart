import 'package:flutter/material.dart';
import 'package:mi_primer_proyecto/providers/auth_provider.dart';
import 'package:mi_primer_proyecto/providers/favourites_provider.dart';
import 'package:mi_primer_proyecto/providers/music_provider.dart';
import 'package:mi_primer_proyecto/providers/profile_provider.dart';
import 'package:mi_primer_proyecto/screens/main_screen.dart';
import 'package:provider/provider.dart';

void main(){
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => FavouritesProvider()),
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ChangeNotifierProvider(create: (_) => MusicProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider()),
    ],
    child: const SenaBeatsApp(),
    ),
  );
}

class SenaBeatsApp extends StatelessWidget {
  const SenaBeatsApp({super.key});

  @override
  Widget build(BuildContext context) {

    final musicProvider = context.watch<MusicProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SENA Canciones',
      
      // CONFIGURACIÓN MATERIAL 3
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: musicProvider.themeColor,
          brightness: Brightness.dark,
          ),
          fontFamily: 'Urbanist',
      ),

      themeMode: ThemeMode.dark,

      home: MainScreen(),
    );
  }
}