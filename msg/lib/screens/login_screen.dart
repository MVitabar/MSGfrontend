import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import '../providers/auth_provider.dart';
import '../widgets/country_code_selector.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _credentialController = TextEditingController();
  final _passwordController = TextEditingController();
  late Country _selectedCountry;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedCountry = CountryPickerUtils.getCountryByIsoCode('AR'); // Argentina por defecto
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login to MSG'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble, size: 80, color: Theme.of(context).colorScheme.primary),
            SizedBox(height: 20),
            Text(
              'Welcome Back!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
            ),
            SizedBox(height: 20),
            // Campo para email o teléfono
            TextFormField(
              controller: _credentialController,
              decoration: InputDecoration(
                labelText: 'Email or Phone',
                border: OutlineInputBorder(),
                prefixIcon: CountryCodeSelector(
                  initialCountry: _selectedCountry,
                  onChanged: (country) {
                    setState(() {
                      _selectedCountry = country;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator(color: Theme.of(context).colorScheme.primary)
                : ElevatedButton(
                    onPressed: () async {
                      setState(() => _isLoading = true);
                      final credential = _credentialController.text;
                      final isEmail = credential.contains('@');
                      final finalCredential = isEmail ? credential : '+${_selectedCountry.phoneCode}$credential';
                      final success = await context.read<AuthProvider>().login(
                        finalCredential,
                        _passwordController.text,
                      );
                      setState(() => _isLoading = false);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Login successful!')),
                        );
                        Navigator.pushReplacementNamed(context, '/chats');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Login failed. Check console for details.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Login', style: TextStyle(fontSize: 18)),
                  ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: Text('Don\'t have an account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
