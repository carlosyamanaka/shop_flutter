// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter/models/auth.dart';

import '../exceptions/auth_exception.dart';

// ignore: constant_identifier_names
enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  //Para pegar o valor da senha para fazer a validação com o repeat password

  final _formKey = GlobalKey<FormState>();
  //Serve pra obter as info do formulário

  bool _isLoading = false;

  AuthMode _authMode = AuthMode.Login; //Alternar modo login e registro

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLogin() => _authMode == AuthMode.Login;
  bool _isSignup() => _authMode == AuthMode.Signup;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.Signup;
      } else {
        _authMode = AuthMode.Login;
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        //Login
        await auth.login(
          //! garante que vai ter as info
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        //Registrar
        await auth.signup(
          //! garante que vai ter as info
          _authData['email']!,
          _authData['password']!,
        );
      }

      setState(() => _isLoading = false);
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
      setState(() => _isLoading = false);
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 9,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Shop flutter',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Text(
            'Bem-vindo de volta! Faça o login para continar.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
          Container(
            width: deviceSize.width * 0.4,
            margin: const EdgeInsets.only(
              bottom: 6,
              top: 12,
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            height: _isLogin() ? 310 : 400,
            width: deviceSize.width * 0.75,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 2),
                    child: const Text('E-mail'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Insira aqui seu e-mail',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (email) => _authData['email'] = email ?? '',
                    validator: (newEmail) {
                      final email = newEmail ?? '';
                      if (email.trim().isEmpty || !email.contains('@')) {
                        return 'Informe um e-mail válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 2),
                    child: const Text('Senha'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Insira aqui a sua senha',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    controller: _passwordController,
                    onSaved: (password) =>
                        _authData['password'] = password ?? '',
                    validator: (newPassword) {
                      final password = newPassword ?? '';
                      if (password.isEmpty || password.length < 6) {
                        return 'Informe uma senha válida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  if (_isSignup())
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 2),
                      child: const Text('Confirmar senha'),
                    ),
                  if (_isSignup())
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Insira novamente sua senha',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      validator: _isLogin()
                          ? null
                          : (newPassword) {
                              final password = newPassword ?? '';
                              if (password != _passwordController.text) {
                                return 'Senhas informadas não conferem.';
                              }
                              return null;
                            },
                    ),
                  const SizedBox(height: 20),
                  if (_isLoading)
                    // ignore: prefer_const_constructors
                    CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                          _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR'),
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: _switchAuthMode,
                    child: Text(
                      _isLogin() ? 'DESEJA REGISTRAR?' : 'JÁ POSSUI CONTA?',
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
