import 'package:flutter/material.dart';

class InterfazIA extends StatefulWidget {
  @override
  _InterfazIAState createState() => _InterfazIAState();
}

class _InterfazIAState extends State<InterfazIA> {
  final _formKey = GlobalKey<FormState>();
  final _responses = {};

  bool _isLoading = false;
  List<String> _recommendedSubjects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encuesta de Recomendación'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildQuestion("¿Cuál es tu materia favorita?", "favorite_subject"),
                        _buildQuestion("¿En qué materia te sientes más débil?", "weak_subject"),
                        _buildQuestion("¿Cuántas horas al día dedicas al estudio?", "study_hours"),
                        _buildQuestion("¿Qué nivel de confianza tienes en tus habilidades matemáticas?", "math_confidence"),
                        _buildQuestion("¿Cómo calificarías tu comprensión de los conceptos básicos de física?", "physics_understanding"),
                        _buildQuestion("¿Tienes experiencia previa en programación?", "programming_experience"),
                        _buildQuestion("¿Te sientes cómodo resolviendo problemas lógicos y algoritmos?", "logic_comfort"),
                        _buildQuestion("¿Qué tanto disfrutas de las tareas relacionadas con cálculos matemáticos?", "math_enjoyment"),
                        _buildQuestion("¿Cuál es tu experiencia previa en física experimental?", "physics_experience"),
                        _buildQuestion("¿Te sientes cómodo trabajando con lenguajes de programación?", "programming_comfort"),
                        // Puedes agregar más preguntas aquí
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text('Obtener Recomendaciones'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  _recommendedSubjects.isNotEmpty
                      ? _buildRecommendations()
                      : Container(),
                ],
              ),
      ),
    );
  }

  Widget _buildQuestion(String question, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: question,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, responde esta pregunta';
          }
          return null;
        },
        onSaved: (value) {
          _responses[key] = value;
        },
      ),
    );
  }

  Widget _buildRecommendations() {
    return Expanded(
      child: ListView.builder(
        itemCount: _recommendedSubjects.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_recommendedSubjects[index]),
          );
        },
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _getRecommendations();
    }
  }

  void _getRecommendations() async {
    setState(() {
      _isLoading = true;
    });

    // Simular la llamada a la API de IA
    await Future.delayed(Duration(seconds: 2));

    // Aquí iría la llamada a la API real que devolvería las recomendaciones.
    // Esta es solo una simulación con datos ficticios.
    setState(() {
      _recommendedSubjects = ["Matemáticas", "Física", "Programación"];
      _isLoading = false;
    });
  }
}
