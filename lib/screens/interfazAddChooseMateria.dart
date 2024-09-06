import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modular2/screens/customTimeField.dart';
import 'package:modular2/screens/interfazMyTutorias.dart';

class AddChooseMateria extends StatefulWidget {
  final Map<String, dynamic>? datosTutoria;
  AddChooseMateria([this.datosTutoria]);

  @override
  _AddChooseMateriaState createState() => _AddChooseMateriaState();
}

class _AddChooseMateriaState extends State<AddChooseMateria> {
  int _numHorarios = 2; // Número de horarios por defecto
  List<String?> _diasSeleccionados = [];
  List<TimeOfDay?> _horasInicio = [];
  List<TimeOfDay?> _horasFinal = [];

  List<String> _diasSemana = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  @override
  void initState() {
    super.initState();
    _inicializarListas();
  }

  void _inicializarListas() {
    _diasSeleccionados = List<String?>.filled(_numHorarios, null);
    _horasInicio = List<TimeOfDay?>.filled(_numHorarios, null);
    _horasFinal = List<TimeOfDay?>.filled(_numHorarios, null);
  }

  Future<void> _seleccionarHora(
      BuildContext context, bool esHoraInicio, int index) async {
    final TimeOfDay? horaElegida = await showTimePicker(
      context: context,
      initialTime: esHoraInicio
          ? (_horasInicio[index] ?? TimeOfDay.now())
          : (_horasFinal[index] ?? TimeOfDay.now()),
    );

    if (horaElegida != null) {
      setState(() {
        if (esHoraInicio) {
          _horasInicio[index] = horaElegida;
        } else {
          _horasFinal[index] = horaElegida;
        }
      });
    }
  }

  void _actualizarNumHorarios(int num) {
    setState(() {
      _numHorarios = num;
      _inicializarListas();
    });
  }

  Future<void> _registrarTutoriaComplete(
      Map<String, dynamic> datosTutoria) async {
    try {
      // Crear la materia
      DocumentReference materiaRef =
          await FirebaseFirestore.instance.collection('materias').add({
        'titulo': datosTutoria['titulo'], // Usar el campo "titulo"
        'descripcion': datosTutoria['descripcion'], // Usar los datos existentes
      });

      // Registrar los horarios en la colección "horarios"
      List<String> idsHorarios = [];
      for (int i = 0; i < _numHorarios; i++) {
        DocumentReference horarioRef =
            await FirebaseFirestore.instance.collection('horarios').add({
          'materia_id': materiaRef.id, // Relacionar con la materia
          'dia_semana': _diasSeleccionados[i],
          'hora_inicio': _horasInicio[i]?.format(context),
          'hora_fin': _horasFinal[i]?.format(context),
        });
        idsHorarios.add(horarioRef.id);
      }

      // Registrar la tutoría en la colección "tutorias"
      await FirebaseFirestore.instance.collection('tutorias').add({
        'user_id': datosTutoria['user_id'].toString(),
        'materia_id': materiaRef.id,
        'titulo': datosTutoria['titulo'], // Usar el campo "titulo"
        'aula': datosTutoria['aula'], // Usar los datos existentes
        'descripcion': datosTutoria['descripcion'], // Usar los datos existentes
        'timestamp': Timestamp.now(),
      });

      // Navegar a la pantalla de mis tutorías
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InterfazMyTutorias()),
      );
    } catch (e) {
      print("Error al registrar la tutoría: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Registrar materia',
              style: TextStyle(
                  fontFamily: 'SF-Pro-Rounded',
                  fontSize: 26.0,
                  fontWeight: FontWeight.w900)),
        ),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DropdownButtonFormField<int>(
                        value: _numHorarios,
                        decoration: InputDecoration(
                          labelText: 'Número de horarios',
                          labelStyle: TextStyle(
                            fontFamily: 'SF-Pro-Text',
                            fontSize: 20.0,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF004AAD),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color.fromARGB(128, 0, 0, 0)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF004AAD)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        items: List.generate(10, (index) => index + 1)
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child:
                                Text('$value horario${value > 1 ? 's' : ''}'),
                          );
                        }).toList(),
                        onChanged: (nuevoValor) {
                          if (nuevoValor != null) {
                            _actualizarNumHorarios(nuevoValor);
                          }
                        },
                      ),
                      SizedBox(height: 20.0),
                      ...List.generate(_numHorarios, (index) {
                        return Column(
                          children: [
                            DropdownButtonFormField<String>(
                              value: _diasSeleccionados[index],
                              decoration: InputDecoration(
                                labelText: 'Día de la semana ${index + 1}',
                                labelStyle: TextStyle(
                                  fontFamily: 'SF-Pro-Text',
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF004AAD),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(128, 0, 0, 0)),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF004AAD)),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              items: _diasSemana.map((String dia) {
                                return DropdownMenuItem<String>(
                                  value: dia,
                                  child: Text(
                                    dia,
                                    style: TextStyle(
                                        fontFamily: 'SF-Pro-Text',
                                        fontSize: 14.0),
                                  ),
                                );
                              }).toList(),
                              onChanged: (nuevoValor) {
                                setState(() {
                                  _diasSeleccionados[index] = nuevoValor;
                                });
                              },
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: TimeField(
                                  labelText: 'Hora de inicio ${index + 1}',
                                  time: _horasInicio[index],
                                  onTap: () =>
                                      _seleccionarHora(context, true, index),
                                )),
                                SizedBox(width: 20),
                                Expanded(
                                  child: TimeField(
                                    labelText: 'Hora final ${index + 1}',
                                    time: _horasFinal[index],
                                    onTap: () =>
                                        _seleccionarHora(context, false, index),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 20.0),
                          ],
                        );
                      }),
                      SizedBox(height: 40),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            await _registrarTutoriaComplete(
                                widget.datosTutoria ?? {});
                          },
                          child: Text(
                            'Publicar tutoría',
                            style: TextStyle(color: Colors.white, shadows: [
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 3.0,
                                color: Color.fromARGB(128, 0, 0, 0),
                              )
                            ]),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Color(0xFF004AAD), // Fondo del botón
                            shadowColor: Colors.black,
                            elevation: 8.0,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            textStyle: TextStyle(
                              fontFamily: 'SF-Pro-Rounded',
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
