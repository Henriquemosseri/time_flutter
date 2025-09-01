// lib/home_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? favoriteName;
  String? favoriteLogo;

  @override
  void initState() {
    super.initState();
    _loadFavorite();
  }

  Future<void> _loadFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteName = prefs.getString('teamName');
      favoriteLogo = prefs.getString('teamLogo');
    });
  }

  Future<void> _removeFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('teamName');
    await prefs.remove('teamLogo');
    setState(() {
      favoriteName = null;
      favoriteLogo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                await Navigator.pushNamed(context, '/select');
                _loadFavorite();
              },
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: favoriteLogo != null
                        ? Image.asset(
                            favoriteLogo!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/images/logo.png');
                            },
                          )
                        : Image.asset('assets/images/logo.png'),
                  ),
                  const SizedBox(height: 16),
                  if (favoriteName != null)
                    Text(
                      favoriteName!,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  else
                    const Text(
                      'Você ainda não escolheu seu time favorito',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: favoriteName != null ? _removeFavorite : null,
              icon: const Icon(Icons.delete),
              label: const Text('Remover time favorito'),
            ),
          ],
        ),
      ),
    );
  }
}
