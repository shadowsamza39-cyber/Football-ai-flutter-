import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> matchData;

  const DetailScreen({Key? key, required this.matchData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final probs = matchData['probabilites_pourcent'];
    final xg = matchData['xG_attendus'];

    return Scaffold(
      appBar: AppBar(
        title: Text("${matchData['equipe_domicile']} vs ${matchData['equipe_exterieur']}"),
        backgroundColor: Colors.indigo[900],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text("Expected Goals (xG) Calculés", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text("${xg['domicile']}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo)),
                            Text(matchData['equipe_domicile'], style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                        const Text("-", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        Column(
                          children: [
                            Text("${xg['exterieur']}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo)),
                            Text(matchData['equipe_exterieur'], style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text("Répartition des Probabilités", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildProbaBar("Victoire ${matchData['equipe_domicile']} (1)", probs['victoire_domicile_1']),
            _buildProbaBar("Match Nul (X)", probs['match_nul_X']),
            _buildProbaBar("Victoire ${matchData['equipe_exterieur']} (2)", probs['victoire_exterieur_2']),
            _buildProbaBar("Plus de 2.5 Buts", probs['plus_de_2_5_buts']),
            _buildProbaBar("Les 2 Équipes Marquent (BTTS)", probs['les_deux_equipes_marquent']),
          ],
        ),
      ),
    );
  }

  Widget _buildProbaBar(String label, dynamic percentage) {
    double value = (percentage as num).toDouble();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text("$value%", style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: value / 100,
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            color: value > 50 ? Colors.green : Colors.indigo,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
