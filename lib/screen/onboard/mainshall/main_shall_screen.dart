import 'package:connectcall/repo/call_repo.dart';
import 'package:connectcall/repo/contract_repo.dart';
import 'package:connectcall/repo/profile_repo.dart';
import 'package:connectcall/screen/onboard/calls/bloc/calls_bloc.dart';
import 'package:connectcall/screen/onboard/calls/bloc/calls_event.dart';
import 'package:connectcall/screen/onboard/calls/call_history_screen.dart';
import 'package:connectcall/screen/onboard/contact/contact_screen.dart';
import 'package:connectcall/screen/onboard/home/home_screen.dart';
import 'package:connectcall/screen/onboard/profile/bloc/profile_bloc.dart';
import 'package:connectcall/screen/onboard/profile/bloc/profile_event.dart';
import 'package:connectcall/screen/onboard/profile/profile_screen.dart';
import 'package:connectcall/widgets/app_buttomnav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectcall/repo/search_repo.dart';
import 'package:connectcall/screen/onboard/search/bloc/search_bloc.dart';
import 'package:connectcall/screen/onboard/contact/bloc/contact_bloc.dart';
import 'package:connectcall/screen/onboard/contact/bloc/contact_event.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SearchBloc(SearchRepository())),
       BlocProvider(
  create: (_) => ContactBloc(
    ContactRepository(),
    CallLogRepository(), 
  )..add(LoadContacts()),
),
        BlocProvider(
  create: (_) => CallLogBloc(CallLogRepository())..add(LoadCallLogs()),
  child: const CallLogsScreen(),
),
   BlocProvider(
      create: (_) => ProfileBloc(ProfileRepository())..add(LoadProfile()), 
    )     
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            HomeScreen(),
            ContactsScreen(),
            CallLogsScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}


