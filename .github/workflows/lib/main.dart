import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'screens/detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football AI Predictor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int leagueIdSelectionnee = 39;
  late Future<List<dynamic>> futureMatchs;

  @override
  void initState() {
    super.initState();
    futureMatchs = ApiService.fetchPredictions(leagueIdSelectionnee);
  }

  void changerLigue(int newLeagueId) {
    setState(() {
      leagueIdSelectionnee = newLeagueId;
      futureMatchs = ApiService.fetchPredictions(leagueIdSelectionnee);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Football AI Predictor", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.indigo[900],
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.indigo[900],
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("78.5%", style: TextStyle(color: Colors.greenAccent, fontSize: 22, fontWeight: FontWeight.bold)),
                      Text("Taux de Réussite", style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                  Column(
                    children: [
                      Text("8/10", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      Text("Validation Hier", style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              children: [
                _buildFilterChip("Premier League", 39),
                _buildFilterChip("Ligue 1", 61),
                _buildFilterChip("Champions League", 2),
                _buildFilterChip("La Liga", 140),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: futureMatchs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Erreur : ${snapshot.error}", style: const TextStyle(color: Colors.red)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Aucun match disponible pour le moment."));
                }

                final matchs = snapshot.data!;
                return ListView.builder(
                  itemCount: matchs.length,
                  itemBuilder: (context, index) {
                    final match = matchs[index];
                    final probs = match['probabilites_pourcent'];

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(match['equipe_domicile'], style: const TextStyle(fontWeight: FontWeight.bold))),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text("VS", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ),
                            Expanded(child: Text(match['equipe_exterieur'], textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold))),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Chip(label: Text("1: ${probs['victoire_domicile_1']}%"), backgroundColor: Colors.indigo[50]),
                              Chip(label: Text("Over 2.5: ${probs['plus_de_2_5_buts']}%"), backgroundColor: Colors.green[50]),
                              Chip(label: Text("BTTS: ${probs['les_deux_equipes_marquent']}%"), backgroundColor: Colors.orange[50]),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(matchData: match),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int leagueId) {
    final isSelected = leagueIdSelectionnee == leagueId;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: Colors.indigo[900],
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
        onSelected: (bool selected) {
          if (selected) changerLigue(leagueId);
        },
      ),
    );
  }
}
