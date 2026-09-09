import 'package:connectcall/core/theme/app_theme.dart';
import 'package:connectcall/core/theme/bloc/theme_bloc.dart';
import 'package:connectcall/firebase_options.dart';
import 'package:connectcall/repo/auth_repo.dart';
import 'package:connectcall/routes/app_routers.dart';
import 'package:connectcall/routes/app_routes.dart';
import 'package:connectcall/screen/auth/bloc/auth_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(AuthRepository())),
        BlocProvider(create: (_) => ThemeBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Callly',
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            
            theme: AppTheme.light.copyWith(
              textTheme: GoogleFonts.plusJakartaSansTextTheme(AppTheme.light.textTheme),
            ),
            darkTheme: AppTheme.dark.copyWith(
              textTheme: GoogleFonts.plusJakartaSansTextTheme(AppTheme.dark.textTheme),
            ),
           
            themeMode: themeState.mode, 
            initialRoute: AppRoutes.splash, 
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}

