import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:paila_kicks/presentation/screens/auth/providers/signup_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/ui.dart';
import '../../widgets/gap_widget.dart';
import '../../widgets/link_button.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/primary_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static const String routName = "signup";

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SignupProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text("Paila Kicks"),
      ),
      body: SafeArea(
        child: Form(
          key: provider.formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text("Create Account", style: TextStyles.heading2),
              const GapWidget(),

              PrimaryTextField(
                controller: provider.emailController,
                validator: (value){
                  if(value == null || value.trim().isEmpty){
                    return "Email address filed cannot be null!";
                  }

                  if(!EmailValidator.validate(value.trim())){
                    return "Please enter your valid email address!";
                  }

                  return null;
                },
                labelText: "Email Address",
              ),
              const GapWidget(),
              PrimaryTextField(
                controller: provider.passwordController,
                validator: (value){
                  if(value == null || value.trim().isEmpty){
                    return "Password is required!";
                  }

                  return null;
                },
                labelText: "Password",
                obsecureText: true,
              ),

              const GapWidget(),
              PrimaryTextField(
                controller: provider.cPasswordController,
                validator: (value){
                  if(value == null || value.trim().isEmpty){
                    return "Confirm your Password!";
                  }

                  if(value.trim() != provider.passwordController.text.trim()){
                    return "Password do not match with confirm password!";
                  }

                  return null;
                },
                labelText: "Confirm Password",
                obsecureText: true,
              ),

              const GapWidget(size: -10,),

              (provider.error != "")? Text(
                provider.error,
                style: const TextStyle(color: Colors.red),
              ) : const GapWidget(),

              PrimaryButton(
                onPressed: provider.signUp,
                text: (provider.isLoading) ? "..." : "Sign Up",
              ),
              const GapWidget(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 16),
                  ),
                  const GapWidget(),
                  LinkButton(
                    text: "Sign In",
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
