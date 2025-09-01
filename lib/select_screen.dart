// lib/select_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class Team {
  final int id;
  final String name;
  final String logo;

  Team({required this.id, required this.name, required this.logo});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] as int,
      name: json['name'] as String,
      logo: json['logo'] as String,
    );
  }
}

class SelectScreen extends StatefulWidget {
  const SelectScreen({super.key});

  @override
  State<SelectScreen> createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  List<Team> teams = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadTeamsFromJson();
  }

  Future<void> _loadTeamsFromJson() async {
    try {
      final jsonString = await rootBundle.loadString('assets/teams.json');
      final List<dynamic> jsonData = json.decode(jsonString) as List<dynamic>;
      teams =
          jsonData.map((e) => Team.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      teams = [];
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> _selectTeam(Team team) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('teamName', team.name);
    await prefs.setString('teamLogo', team.logo);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecione seu time')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : teams.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum time disponível. Verifique o arquivo teams.json.',
                  ),
                )
              : ListView.builder(
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    final team = teams[index];
                    return ListTile(
                      leading: SizedBox(
                        width: 48,
                        height: 48,
                        child: Image.asset(
                          team.logo,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset('assets/images/logo.png'),
                        ),
                      ),
                      title: Text(team.name),
                      onTap: () => _selectTeam(team),
                    );
                  },
                ),
    );
  }
}
