import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api_connection/models/teams.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var domin = 'balldontlie.io';
  var path = 'api/v1/teams';
  List<Teams> teams = [];
  Future getTeams() async {
    var reponse = await http.get(Uri.https(domin, path));
    var jsonData = jsonDecode(reponse.body);
    for (var eachTeam in jsonData['data']) {
      teams.add(Teams(
        abbreviation: eachTeam['abbreviation'],
        city: eachTeam['city'],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    getTeams();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: const Center(
          child: Text('NBA TEAMS'),
        ),
        elevation: 0,
      ),
      body: Container(
        // color: Colors.grey[200],
        child: FutureBuilder(
          future: getTeams(),
          builder: (context, snapshot) {
            //if done loading
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[200],
                      ),
                      child: ListTile(
                        title: Text(teams[index].abbreviation),
                        subtitle: Text(teams[index].city),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
