import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 250,
          ),
          CardContainer(
              child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                'Login',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(
                height: 30,
              ),
              const Text('Formulario'),
              ChangeNotifierProvider(
                create: (_) => LoginFormProvider(),
                child: _LoginForm(),
              )
            ],
          )),
          const SizedBox(height: 50),
          const Text('Crear una nueva cuenta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 50),
        ],
      ),
    )));
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        //TODO: Mantener la referencia al KEY
        key: loginForm.formKey,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'john.doe@gmail.com',
                  labelText: 'Correo electrónico',
                  prefixIcon: Icons.alternate_email_outlined),
              onChanged: (value) => loginForm.email = value,
              validator: (value) => _Validator.validateEmail(value),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '********', labelText: 'Contraseña', prefixIcon: Icons.lock_clock_outlined),
              onChanged: (value) => loginForm.password = value,
              validator: (value) => _Validator.validatePassword(value),
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.deepPurple,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                  child: Text(
                    loginForm.isLoading ? 'Espere...' : 'Ingresar',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();

                        if (!loginForm.isValidForm()) return;

                        loginForm.isLoading = true;
                        await Future.delayed(const Duration(seconds: 2));
                        loginForm.isLoading = false;


                        Navigator.pushReplacementNamed(context, 'home');
                      })
          ],
        ),
      ),
    );
  }
}

class _Validator {
  static validateEmail(value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value ?? '') ? null : 'El valor ingresado no es un correo electrónico';
  }

  static validatePassword(value) {
    return (value != null && value.length >= 6) ? null : 'La contraseña debe ser de al menos 6 caracteres';
  }
}
