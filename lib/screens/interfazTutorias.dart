import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:TutorMeUp/services/storage_service.dart';

class InterfazTutorias extends StatefulWidget {
  final String? userId;
  final String? materiaBuscada;

  InterfazTutorias({this.userId, this.materiaBuscada});

  @override
  _InterfazTutoriasState createState() => _InterfazTutoriasState();
}

class _InterfazTutoriasState extends State<InterfazTutorias> {
  List<DocumentSnapshot> _tutorias = [];
  List<DocumentSnapshot> _filteredTutorias = []; // Lista de tutorías filtradas
  TextEditingController _searchController = TextEditingController(); // Controlador para la barra de búsqueda

  @override
  void initState() {
    super.initState();
    _fetchTutorias();
    _searchController.addListener(_filterTutorias); // Escucha cambios en la barra de búsqueda
    
    if (widget.materiaBuscada != null && widget.materiaBuscada!.isNotEmpty) {
      _searchController.text = widget.materiaBuscada!;
      _filterTutorias();
    }
  }

  Future<void> _fetchTutorias() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('tutorias').get();

      setState(() {
        _tutorias = querySnapshot.docs;
        _filteredTutorias = _tutorias; // Inicialmente, mostrar todas las tutorías
      });
    } catch (e) {
      print('Error fetching tutorias: $e');
    }
  }

  void _filterTutorias() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      _filteredTutorias = _tutorias.where((tutoria) {
        String titulo = tutoria['titulo'].toLowerCase();
        return titulo.contains(searchText); // Comparar el título con el texto de búsqueda
      }).toList();
    });
  }

  Future<void> _solicitarTutoria(DocumentSnapshot tutoria) async {
    String? userIdStoraged = await StorageService.getUserId();
    try {
      await FirebaseFirestore.instance.collection('solicitudes').add({
        'user_id': userIdStoraged,
        'tutoria_id': tutoria.id,
        'tutor_id': tutoria['user_id'],
        'titulo': tutoria['titulo'],
        'descripcion': tutoria['descripcion'],
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Solicitud enviada con éxito!')),
      );
    } catch (e) {
      print('Error al enviar la solicitud: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar la solicitud')),
      );
    }
  }

  Future<List<QueryDocumentSnapshot>> _fetchHorarios(String materiaId) async {
    QuerySnapshot horariosSnapshot = await FirebaseFirestore.instance
        .collection('horarios')
        .where('materia_id', isEqualTo: materiaId)
        .get();
    return horariosSnapshot.docs;
  }

  void _mostrarDetallesTutoria(BuildContext context, DocumentSnapshot tutoria) async {
    List<QueryDocumentSnapshot> horarios = await _fetchHorarios(tutoria['materia_id']);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tutoria['titulo']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Descripción:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(tutoria['descripcion']),
              SizedBox(height: 16),
              Text(
                "Horarios:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              for (var horario in horarios)
                Text(
                  '${horario['dia_semana']}: de ${horario['hora_inicio']} a ${horario['hora_fin']}',
                  style: TextStyle(fontSize: 16),
                ),
              SizedBox(height: 16),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar",
                  style: TextStyle(
                      fontFamily: 'SF-Pro-Text', fontWeight: FontWeight.w600)),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Solicitar",
                  style: TextStyle(
                      fontFamily: 'SF-Pro-Text', fontWeight: FontWeight.w600)),
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFFFFB400),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await _solicitarTutoria(tutoria);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Widget> _fetchHorarioCard(DocumentSnapshot tutoria) async {
    List<QueryDocumentSnapshot> horarios = await _fetchHorarios(tutoria['materia_id']);
    String aula = tutoria['aula'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aula: $aula',
          style: TextStyle(
            fontFamily: 'SF-Pro-Text',
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Horarios:',
          style: TextStyle(
            fontFamily: 'SF-Pro-Text',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        for (var horario in horarios)
          Text(
            '${horario['dia_semana']}: de ${horario['hora_inicio']} a ${horario['hora_fin']}',
            style: TextStyle(
              fontFamily: 'SF-Pro-Text',
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todas las Tutorías',
          style: TextStyle(
              fontFamily: 'SF-Pro-Rounded',
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800),
        ),
        backgroundColor: Color(0xFF3A6CAD),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0), // Altura del AppBar
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar tutoría...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _filteredTutorias.isEmpty
                ? Center(
                    child: Text(
                      '¡No hay tutorías disponibles! 🤔',
                      style: TextStyle(
                          fontFamily: 'SF-Pro-Rounded',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0082AD)),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredTutorias.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<Widget>(
                        future: _fetchHorarioCard(_filteredTutorias[index]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error al cargar el horario');
                          } else {
                            return _buildTutoriaCard(_filteredTutorias[index], snapshot.data!);
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutoriaCard(DocumentSnapshot tutoria, Widget horarioWidget) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () => _mostrarDetallesTutoria(context, tutoria),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tutoria['titulo'],
                style: TextStyle(
                  fontFamily: 'SF-Pro-Rounded',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3A6CAD),
                ),
              ),
              SizedBox(height: 8),
              Text(
                tutoria['descripcion'],
                style: TextStyle(
                  fontFamily: 'SF-Pro-Text',
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
              horarioWidget,  // Añadimos el widget de los horarios y aula
            ],
          ),
        ),
      ),
    );
  }
}
