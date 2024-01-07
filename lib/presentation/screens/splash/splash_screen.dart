import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paila_kicks/logic/cubits/user_cubit/user_cubit.dart';
import 'package:paila_kicks/logic/cubits/user_cubit/user_state.dart';
import 'package:paila_kicks/presentation/screens/auth/login_screen.dart';
import 'package:paila_kicks/presentation/screens/dashboard/dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = "splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void goToNextScreen() {
    UserState userState = BlocProvider.of<UserCubit>(context).state;
    if(userState is UserLoggedInState){
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    }
    else if(userState is UserLoggedOutState){
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, LoginScreen.routName);
    }
    else if(userState is UserErrorState){
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, LoginScreen.routName);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(milliseconds: 100), () {
      goToNextScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state){
        goToNextScreen();
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
