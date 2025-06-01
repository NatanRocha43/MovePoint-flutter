import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nome_do_projeto/screens/evento.dart';

class EventCard extends StatelessWidget {
  final String eventoId;
  final Color? backgroundColor;

  const EventCard({Key? key, required this.eventoId, this.backgroundColor})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('eventos').doc(eventoId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            color: backgroundColor,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Card(
            color: backgroundColor,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Evento não encontrado'),
            ),
          );
        }

        final evento = snapshot.data!;
        final titulo = evento['nomeEvento'] ?? 'Sem título';
        final local = evento['local'] ?? 'Sem local';
        final dataHora = (evento['dataHora'] as Timestamp).toDate();
        final modalidade =
            evento['modalidade'] != null
                ? '${evento['modalidade']} - ${evento['categoria']}'
                : 'Indefinida';
        final diasSemana = [
          'Domingo',
          'Segunda-feira',
          'Terça-feira',
          'Quarta-feira',
          'Quinta-feira',
          'Sexta-feira',
          'Sábado',
        ];
        final diaSemana = diasSemana[dataHora.weekday % 7];
        final dataFormatada =
            '$diaSemana ${dataHora.day}/${dataHora.month}/${dataHora.year} às ${dataHora.hour.toString().padLeft(2, '0')}h${dataHora.minute.toString().padLeft(2, '0')}';

        return Card(
          color: backgroundColor ?? Colors.white,
          margin: EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventPage(eventoId: eventoId),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(local, style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        dataFormatada,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.sports, size: 14, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        modalidade,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
