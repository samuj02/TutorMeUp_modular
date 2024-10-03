import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:TutorMeUp/screens/InterfazRegistrarTutoria.dart';
import 'package:TutorMeUp/services/storage_service.dart';

class InterfazMyTutorias extends StatefulWidget {
  InterfazMyTutorias();

  @override
  _InterfazMyTutoriasState createState() => _InterfazMyTutoriasState();
}

class _InterfazMyTutoriasState extends State<InterfazMyTutorias> {
  List<DocumentSnapshot> _myTutorias = [];

  @override
  void initState() {
    super.initState();
    _fetchMyTutorias();
  }

  Future<void> _fetchMyTutorias() async {
    try {
      // Obtenemos el id del doc del usuario que ingresó
      String? storedUserId = await StorageService.getUserId();
      // Consultar las tutorías del usuario actual en Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('tutorias')
          .where('user_id', isEqualTo: storedUserId)
          .get();

      setState(() {
        _myTutorias = querySnapshot.docs;
      });
    } catch (e) {
      print('Error fetching tutorias: $e');
    }
  }

  Future<void> _deleteTutoria(DocumentSnapshot tutoria) async {
    try {
      await FirebaseFirestore.instance
          .collection('tutorias')
          .doc(tutoria.id)
          .delete();
      setState(() {
        _myTutorias.remove(tutoria);
      });
    } catch (e) {
      print('Error deleting tutoria: $e');
    }
  }

  Future<void> _modifyTutoria(DocumentSnapshot tutoria) async {
    // Aquí puedes navegar a la pantalla para modificar los detalles de la tutoría,
    // pasándole los datos de la tutoría actual.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModificarTutoria(tutoria: tutoria),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mis tutorias',
          style: TextStyle(
              fontFamily: 'SF-Pro-Rounded',
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800),
        ),
        backgroundColor: Color(0xFF004BAD),
      ),
      body: Column(
        children: [
          Expanded(
            child: _myTutorias.isEmpty
                ? Center(
                    child: Text(
                    '¡Aún no tienes ninguna tutoría publicada! 🤔',
                    style: TextStyle(
                        fontFamily: 'SF-Pro-Rounded',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004BAD)),
                    textAlign: TextAlign.center,
                  ))
                : ListView.builder(
                    itemCount: _myTutorias.length,
                    itemBuilder: (context, index) {
                      return _buildTutoriaCard(_myTutorias[index]);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: ElevatedButton(
              onPressed: () {
                _navigateToRegistrarTutoria();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF004BAD),
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                      fontSize: 25,
                      fontFamily: 'SF-Pro-Text',
                      fontWeight: FontWeight.w600)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_circle_rounded,
                    size: 30,
                  ),
                  SizedBox(width: 8),
                  Text('Publicar tutoría'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutoriaCard(DocumentSnapshot tutoria) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Horario: ${tutoria['timestamp'].toDate().toString()}',
                  style: TextStyle(
                    fontFamily: 'SF-Pro-Text',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    _modifyTutoria(tutoria);
                  },
                  child: Text(
                    'Modificar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _confirmDeleteTutoria(tutoria);
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteTutoria(DocumentSnapshot tutoria) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar cancelación'),
          content: Text('¿Estás seguro de que deseas cancelar esta tutoría?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                _deleteTutoria(tutoria); // Eliminar la tutoría
              },
              child: Text('Sí'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToRegistrarTutoria() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrarTutoria(),
      ),
    );
  }
}

class ModificarTutoria extends StatefulWidget {
  final DocumentSnapshot tutoria;

  ModificarTutoria({required this.tutoria});

  @override
  _ModificarTutoriaState createState() => _ModificarTutoriaState();
}

class _ModificarTutoriaState extends State<ModificarTutoria> {
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  DocumentSnapshot? _horarioDoc;

  List<String> _diasSemana = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  String? _diaSeleccionado;
  TimeOfDay? _horaInicio;
  TimeOfDay? _horaFin;

  @override
  void initState() {
    super.initState();
    _tituloController.text = widget.tutoria['titulo'];
    _descripcionController.text = widget.tutoria['descripcion'];
    _fetchHorario(); // Obtener el horario de la tutoría
  }

  Future<void> _fetchHorario() async {
    try {
      // Consultar el horario usando el "materia_id" de la tutoría
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('horarios')
          .where('materia_id', isEqualTo: widget.tutoria['materia_id'])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot horarioDoc = querySnapshot.docs.first;
        setState(() {
          _horarioDoc = horarioDoc;
          _diaSeleccionado = horarioDoc['dia_semana'];
          _horaInicio = _parseTimeOfDay(horarioDoc['hora_inicio']);
          _horaFin = _parseTimeOfDay(horarioDoc['hora_fin']);
        });
      }
    } catch (e) {
      print('Error fetching horario: $e');
    }
  }

  // Convertir una cadena "HH:MM AM/PM" en un objeto TimeOfDay
  TimeOfDay _parseTimeOfDay(String hora) {
    final timeParts = hora.split(' ');
    final hourMinute = timeParts[0].split(':');
    int hour = int.parse(hourMinute[0]);
    int minute = int.parse(hourMinute[1]);

    if (timeParts[1] == 'PM' && hour != 12) hour += 12;
    if (timeParts[1] == 'AM' && hour == 12) hour = 0;

    return TimeOfDay(hour: hour, minute: minute);
  }

  // Seleccionar una hora
  Future<void> _seleccionarHora(BuildContext context, bool esHoraInicio) async {
    final TimeOfDay? horaElegida = await showTimePicker(
      context: context,
      initialTime: esHoraInicio
          ? (_horaInicio ?? TimeOfDay.now())
          : (_horaFin ?? TimeOfDay.now()),
    );

    if (horaElegida != null) {
      setState(() {
        if (esHoraInicio) {
          _horaInicio = horaElegida;
        } else {
          _horaFin = horaElegida;
        }
      });
    }
  }

  Future<void> _updateTutoria() async {
    try {
      // Actualizar la información de la tutoría
      await FirebaseFirestore.instance
          .collection('tutorias')
          .doc(widget.tutoria.id)
          .update({
        'titulo': _tituloController.text,
        'descripcion': _descripcionController.text,
      });

      // Actualizar la información del horario
      if (_horarioDoc != null) {
        await FirebaseFirestore.instance
            .collection('horarios')
            .doc(_horarioDoc!.id)
            .update({
          'dia_semana': _diaSeleccionado,
          'hora_inicio': _horaInicio!.format(context),
          'hora_fin': _horaFin!.format(context),
        });
      }

      Navigator.of(context).pop();
    } catch (e) {
      print('Error updating tutoria and horario: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar tutoría'),
        backgroundColor: Color(0xFF004BAD),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _descripcionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            SizedBox(height: 20),
            // Campo para el día de la semana
            DropdownButton<String>(
              value: _diaSeleccionado,
              hint: Text('Seleccionar día de la semana'),
              items: _diasSemana.map((String dia) {
                return DropdownMenuItem<String>(
                  value: dia,
                  child: Text(dia),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _diaSeleccionado = newValue;
                });
              },
            ),
            // Botón para seleccionar la hora de inicio
            Row(
              children: [
                Text(
                    'Hora de inicio: ${_horaInicio?.format(context) ?? 'Seleccionar'}'),
                IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () => _seleccionarHora(context, true),
                ),
              ],
            ),
            // Botón para seleccionar la hora de fin
            Row(
              children: [
                Text(
                    'Hora de fin: ${_horaFin?.format(context) ?? 'Seleccionar'}'),
                IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () => _seleccionarHora(context, false),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTutoria,
              child: Text('Guardar cambios'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF004BAD),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
