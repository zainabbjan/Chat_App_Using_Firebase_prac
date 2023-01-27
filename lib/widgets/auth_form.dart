import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:udemy_firebase/widgets/pickers/user_picker.dart';
import 'package:image_picker/image_picker.dart';

class SuthForm extends StatefulWidget {
  const SuthForm(this.submitFn, this.isLoading);
  final Function(String email, String password, String username, bool isLogin,
      File image) submitFn;
  final bool isLoading;

  @override
  State<SuthForm> createState() => _SuthFormState();
}

class _SuthFormState extends State<SuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;

  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File? _userImagefile;

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_userImagefile == null && !_isLogin) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please pick an image')));
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();

      ///
      widget.submitFn(
          _userEmail, _userPassword, _userName, _isLogin, _userImagefile!);
    }
  }

  void _pickedImage(File image) {
    _userImagefile = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isLogin)
                      UserPickerImage(
                        imagePickFn: _pickedImage,
                      ),
                    if (!_isLogin)
                      TextFormField(
                        key: const ValueKey('email'),
                        onSaved: ((newValue) {
                          _userEmail = newValue.toString();
                        }),
                        validator: ((value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        }),
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email address',
                        ),
                      ),
                    TextFormField(
                      key: const ValueKey('username'),
                      onSaved: ((newValue) {
                        _userName = newValue.toString();
                      }),
                      validator: ((value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter atleast 4 characters';
                        }
                        return null;
                      }),
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                    ),
                    TextFormField(
                      key: const ValueKey('password'),
                      onSaved: ((newValue) {
                        _userPassword = newValue.toString();
                      }),
                      validator: ((value) {
                        if (value!.isEmpty || value.length < 7) {
                          return 'Password must be atleast 7 characters long';
                        }
                        return null;
                      }),
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    if (widget.isLoading) const CircularProgressIndicator(),
                    if (!widget.isLoading)
                      ElevatedButton(
                          onPressed: _trySubmit,
                          child: Text(_isLogin ? 'Login' : 'Signup')),
                    if (!widget.isLoading)
                      TextButton(
                          onPressed: (() {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          }),
                          child: Text(_isLogin
                              ? 'Create new account'
                              : 'I already have an account'))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
