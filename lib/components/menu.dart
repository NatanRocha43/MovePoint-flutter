import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nome_do_projeto/colors/index.dart';
import 'package:nome_do_projeto/screens/feed.dart';
import 'package:nome_do_projeto/screens/login_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Container(
        color: const Color(colors.primary),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 160,
              color: const Color(colors.primary),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage:
                        user?.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : const AssetImage("assets/user.jpg")
                                as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<String>(
                    future: _getUserName(user),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(color: Colors.white);
                      } else if (snapshot.hasError) {
                        return Text(
                          'Erro ao carregar nome',
                          style: TextStyle(color: Colors.white),
                        );
                      } else {
                        return Text(
                          snapshot.data ?? 'Usuário',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    },
                  ),
                  Text(
                    user?.email ?? 'email não disponível',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Column(
                children: [
                  _buildMenuItem("Feed", FeedPage(), context),
                  ListTile(
                    title: const Text(
                      "Sair",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile _buildMenuItem(String title, function, BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w300,
        ),
      ),
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => function),
          ),
    );
  }
}

Future<String> _getUserName(User? user) async {
  if (user == null) return 'Desconhecido';

  final providers = user.providerData.map((p) => p.providerId);
  final isSocialLogin =
      providers.contains('google.com') || providers.contains('facebook.com');

  if (isSocialLogin) {
    return user.displayName ?? 'Usuário';
  }

  final doc =
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(user.uid)
          .get();

  if (doc.exists && doc.data() != null && doc.data()!.containsKey('nome')) {
    return doc['nome'];
  }

  return 'Usuário';
}
