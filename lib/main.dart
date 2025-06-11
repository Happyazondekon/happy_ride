import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/start_screen.dart';
import 'services/game_service.dart';
import 'services/audio_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize services
  final storageService = StorageService();
  await storageService.init();

  final audioService = AudioService();
  await audioService.init();

  runApp(MyApp(
    storageService: storageService,
    audioService: audioService,
  ));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  final AudioService audioService;

  const MyApp({
    Key? key,
    required this.storageService,
    required this.audioService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        Provider<AudioService>.value(value: audioService),
        ChangeNotifierProvider(
          create: (context) => GameService(
            storageService: storageService,
            audioService: audioService,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Happy Ride',
        theme: ThemeData(
          primarySwatch: Colors.red,
          brightness: Brightness.dark,
          fontFamily: 'Montserrat',
          scaffoldBackgroundColor: const Color(0xFF121212),
        ),
        home: const StartScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}