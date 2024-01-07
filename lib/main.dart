// Import the material package, which contains Flutter's material design framework.
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paila_kicks/core/routes.dart';
import 'package:paila_kicks/logic/cubits/cart_cubit/cart_cubit.dart';
import 'package:paila_kicks/logic/cubits/category_cubit/category_cubit.dart';
import 'package:paila_kicks/logic/cubits/order_cubit/order_cubit.dart';
import 'package:paila_kicks/logic/cubits/product_cubit/product_cubit.dart';
import 'package:paila_kicks/logic/cubits/user_cubit/user_cubit.dart';
import 'package:paila_kicks/presentation/screens/splash/splash_screen.dart';

import 'core/ui.dart';

// Main entry point of the application
void main() async {
  // Ensure that Flutter binding is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  // Run the PailaKicks application.
  runApp(const PailaKicks());
}

// Define a StatelessWidget
class PailaKicks extends StatelessWidget {

  // Constructor for the PailaKicks widget
  const PailaKicks({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // Return a MaterialApp widget, which is a wrapper for the entire application.
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserCubit()),
        BlocProvider(create: (context) => CategoryCubit()),
        BlocProvider(create: (context) => ProductCubit()),
        BlocProvider(create: (context) => CartCubit(
          BlocProvider.of<UserCubit>(context)
        )),
        BlocProvider(create: (context) => OrderCubit(
          BlocProvider.of<UserCubit>(context),
          BlocProvider.of<CartCubit>(context),
        )),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Themes.defaultTheme,
        onGenerateRoute: Routes.onGenerateRoute,
        initialRoute: SplashScreen.routeName,
      ),
    );
  }
}

class MyBlocObserver extends BlocObserver{
  @override
  void onCreate(BlocBase bloc) {
    log("Created: $bloc");
    // TODO: implement onCreate
    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    log("Created: $bloc: $change");
    // TODO: implement onChange
    super.onChange(bloc, change);
  }
  
  @override
  void onTransition(Bloc bloc, Transition transition) {
    log("Change in $bloc: $transition");
    // TODO: implement onTransition
    super.onTransition(bloc, transition);
  }
  
  @override
  void onClose(BlocBase bloc) {
    log("Closed $bloc");
    // TODO: implement onClose
    super.onClose(bloc);
  }
}