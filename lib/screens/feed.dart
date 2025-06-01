import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nome_do_projeto/colors/index.dart';
import 'package:nome_do_projeto/components/eventCard.dart';
import 'package:nome_do_projeto/screens/cadastro_evento.dart';
import 'package:nome_do_projeto/screens/evento.dart';
import 'package:nome_do_projeto/components/menu.dart';

final diasSemana = [
  'Domingo',
  'Segunda-feira',
  'Terça-feira',
  'Quarta-feira',
  'Quinta-feira',
  'Sexta-feira',
  'Sábado',
];

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text('Eventos Agendados')),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('eventos')
                .orderBy('dataHora')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Nenhum evento encontrado'));
          }

          final eventos = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: eventos.length,
            itemBuilder: (context, index) {
              final evento = eventos[index];

              return EventCard(
                backgroundColor:
                    index.isEven ? Color(colors.secondary) : Colors.white,
                eventoId: evento.id,
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CriarEventoPage()),
            ),
        backgroundColor: Color(colors.primary),
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
