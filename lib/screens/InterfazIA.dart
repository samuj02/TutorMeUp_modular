import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:TutorMeUp/screens/interfazTutorias.dart';
import 'dart:convert';

class InterfazIA extends StatefulWidget {
  @override
  _InterfazIAState createState() => _InterfazIAState();
}

class _InterfazIAState extends State<InterfazIA> {
  final _formKey = GlobalKey<FormState>();

  // Variables para guardar las respuestas de cada sección (asegúrate de que sean enteros)
  Map<String, Map<int, int>> _responses = {
  'Matematicas': {},
  'Fisica': {},
  'Quimica': {},
  'Programacion': {},
  'Probabilidad_Y_Estadistica': {},
};


  // Preguntas y respuestas de opción múltiple
  Map<String, List<Map<String, dynamic>>> _questions = {
    'Matematicas': [
  {
    'pregunta': '¿Cuál es el resultado de la derivada de f(x) = 3x^2 + 4x - 5?',
    'opciones': {
      '6x + 4': 1,  // Respuesta correcta
      '6x + 2': 2,  // Respuesta incorrecta
      '3x + 4': 3   // Respuesta incorrecta
    }
  },
  {
    'pregunta': '¿Cómo se resuelve la ecuación cuadrática 2x^2 - 4x + 1 = 0?',
    'opciones': {
      'x = -1 ± 1/2': 1,  // Respuesta correcta
      'x = 2 ± 1/2': 2,   // Respuesta incorrecta
      'x = 1 ± 1/2': 3    // Respuesta incorrecta
    }
  },
  {
    'pregunta': 'Si una recta tiene pendiente m = 2 y pasa por el punto (3, 4), ¿cuál es su ecuación?',
    'opciones': {
      'y = 2x + 4': 1,  // Respuesta correcta
      'y = 2x - 2': 2,  // Respuesta incorrecta
      'y = 2x + 2': 3   // Respuesta incorrecta
    }
  },
  {
    'pregunta': '¿Qué es un número imaginario y cuál es el valor de i^2?',
    'opciones': {
      'i^2 = -1': 1,  // Respuesta correcta
      'i^2 = 1': 2,   // Respuesta incorrecta
      'i^2 = 0': 3    // Respuesta incorrecta
    }
  },
  {
    'pregunta': 'Resuelve la integral indefinida ∫(5x^3 - 2x + 3)dx.',
    'opciones': {
      '5x^4/4 - x^2 + 3x + C': 1,  // Respuesta correcta
      '5x^3/3 - x + 3 + C': 2,     // Respuesta incorrecta
      '5x^2 - 2x^2 + 3x + C': 3    // Respuesta incorrecta
    }
  }
],

    'Fisica': [
  {
    'pregunta': '¿Cuál es la segunda ley de Newton y cómo se expresa matemáticamente?',
    'opciones': {
      'F = ma': 1,  // Respuesta correcta
      'F = mv': 2,  // Respuesta incorrecta
      'F = m/a': 3  // Respuesta incorrecta
    }
  },
  {
    'pregunta': 'Si un objeto de masa 5 kg es acelerado a 2 m/s^2, ¿cuál es la fuerza neta que actúa sobre él?',
    'opciones': {
      '20 N': 1,   // Respuesta correcta
      '5 N': 2,    // Respuesta incorrecta
      '10 N': 3    // Respuesta incorrecta
    }
  },
  {
    'pregunta': 'Describe el concepto de energía cinética y proporciona su fórmula.',
    'opciones': {
      'Ek = 1/2 mv^2': 1,  // Respuesta correcta
      'Ek = mgh': 2,       // Respuesta incorrecta
      'Ek = mv^2': 3       // Respuesta incorrecta
    }
  },
  {
    'pregunta': '¿Qué es la ley de conservación de la energía y cómo se aplica en sistemas mecánicos?',
    'opciones': {
      'La energía no se crea ni se destruye, solo se transforma de una forma a otra': 1,  // Respuesta correcta
      'La energía puede aumentar o disminuir según las condiciones del sistema': 2,       // Respuesta incorrecta
      'La energía solo se destruye cuando se aplica trabajo externo': 3                  // Respuesta incorrecta
    }
  },
  {
    'pregunta': 'Un objeto cae libremente desde una altura de 100 metros. ¿Con qué velocidad impactará el suelo (sin considerar la resistencia del aire)?',
    'opciones': {
      '44.3 m/s': 1,  // Respuesta correcta
      '20 m/s': 2,    // Respuesta incorrecta
      '9.8 m/s': 3    // Respuesta incorrecta
    }
  },
],
    'Quimica': [
  {
    'pregunta': '¿Qué es un mol?',
    'opciones': {
      '6.022x10^23 partículas': 1,  // Respuesta correcta
      '1 gramo': 2,                 // Respuesta incorrecta
      'Una molécula': 3             // Respuesta incorrecta
    }
  },
  {
    'pregunta': '¿Cuál es la diferencia entre un enlace iónico y un enlace covalente?',
    'opciones': {
      'En un enlace iónico los electrones se transfieren entre átomos, mientras que en un enlace covalente los electrones se comparten': 1,  // Respuesta correcta
      'En un enlace iónico los átomos comparten electrones, mientras que en un enlace covalente los átomos se repelen': 2,  // Respuesta incorrecta
      'En un enlace iónico los electrones se atraen por fuerzas magnéticas, mientras que en un enlace covalente los electrones giran alrededor de ambos átomos': 3  // Respuesta incorrecta
    }
  },
  {
    'pregunta': 'Describe el proceso de neutralización entre un ácido y una base.',
    'opciones': {
      'En la neutralización, un ácido reacciona con una base para formar agua y una sal': 1,  // Respuesta correcta
      'En la neutralización, un ácido y una base reaccionan para formar un nuevo compuesto sin liberación de productos': 2,  // Respuesta incorrecta
      'En la neutralización, un ácido se convierte en gas cuando se mezcla con una base': 3  // Respuesta incorrecta
    }
  },
  {
    'pregunta': 'Explica la diferencia entre una disolución concentrada y una diluida.',
    'opciones': {
      'Una disolución concentrada tiene una gran cantidad de soluto disuelto, mientras que una diluida tiene menos soluto disuelto': 1,  // Respuesta correcta
      'Una disolución concentrada tiene menor cantidad de agua, mientras que una diluida tiene más agua': 2,  // Respuesta incorrecta
      'Una disolución concentrada tiene partículas más grandes, mientras que una diluida tiene partículas más pequeñas': 3  // Respuesta incorrecta
    }
  },
  {
    'pregunta': '¿Qué es una reacción redox y cómo se identifican los agentes oxidantes y reductores?',
    'opciones': {
      'Una reacción redox es una reacción en la que hay transferencia de electrones; el agente oxidante gana electrones y el agente reductor los pierde': 1,  // Respuesta correcta
      'Una reacción redox es una reacción donde los átomos ganan masa; el agente oxidante pierde masa y el agente reductor la gana': 2,  // Respuesta incorrecta
      'Una reacción redox es una reacción que ocurre solo en presencia de luz solar; el agente oxidante es el que genera luz': 3  // Respuesta incorrecta
    }
  },
],
    'Programacion': [
  {
    'pregunta': '¿Qué es un bucle for en programación y cómo se utiliza?',
    'opciones': {
      'Un bucle que repite una secuencia de instrucciones un número fijo de veces': 1,  // Respuesta correcta
      'Un bucle que se ejecuta hasta que se alcanza una condición infinita': 2,  // Respuesta incorrecta
      'Un bucle que se utiliza solo para estructuras de datos dinámicas': 3     // Respuesta incorrecta
    }
  },
  {
    'pregunta': 'Programa en Python que calcula la suma de los primeros 10 números naturales.',
    'opciones': {
      'total = sum(range(1, 11))\nprint(total)': 1,  // Respuesta correcta
      'for i in range(10):\n   total = i\n   print(total)': 2,  // Respuesta incorrecta
      'total = sum(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)\nprint(total)': 3  // Respuesta incorrecta
    }
  },
  {
    'pregunta': '¿Cuál es la diferencia entre una variable global y una variable local en programación?',
    'opciones': {
      'Una variable global puede ser accedida desde cualquier parte del programa, mientras que una variable local solo desde dentro de la función donde se declaró': 1,  // Respuesta correcta
      'Una variable global se declara dentro de las funciones y la local fuera de las funciones': 2,  // Respuesta incorrecta
      'Una variable global se elimina automáticamente, mientras que una local no': 3  // Respuesta incorrecta
    }
  },
  {
    'pregunta': '¿Qué es un "array" y cómo se declara un array de 5 enteros en C?',
    'opciones': {
      'Un array es una colección de variables del mismo tipo; int arr[5];': 1,  // Respuesta correcta
      'Un array es una lista dinámica de elementos; int[5] arr;': 2,  // Respuesta incorrecta
      'Un array es una matriz de caracteres; char arr[5];': 3  // Respuesta incorrecta
    }
  },
  {
    'pregunta': 'Explica qué es una función recursiva y da un ejemplo.',
    'opciones': {
      'Una función recursiva es aquella que se llama a sí misma dentro de su definición; por ejemplo, una función que calcula el factorial de un número': 1,  // Respuesta correcta
      'Una función recursiva es aquella que se ejecuta en paralelo con otras funciones': 2,  // Respuesta incorrecta
      'Una función recursiva es aquella que se repite hasta que el compilador lo detiene': 3  // Respuesta incorrecta
    }
  },
],

    'Probabilidad_Y_Estadistica': [
  {
    'pregunta': '¿Cuál es el valor de la mediana en el conjunto de datos 3, 7, 9, 12, 15?',
    'opciones': {
      '9': 1, // Respuesta correcta
      '7': 2, // Respuesta incorrecta
      '12': 3 // Respuesta incorrecta
    }
  },
  {
    'pregunta': '¿Qué es la media aritmética de un conjunto de datos?',
    'opciones': {
      'Es el valor obtenido al sumar todos los datos y dividir entre el número total de datos': 1, // Respuesta correcta
      'Es el valor que más veces se repite en el conjunto de datos': 2,  // Respuesta incorrecta
      'Es el valor central en un conjunto de datos cuando están ordenados': 3  // Respuesta incorrecta
    }
  },
  {
    'pregunta': '¿Qué es la mediana en estadística?',
    'opciones': {
      'Es el valor central en un conjunto de datos cuando están ordenados': 1, // Respuesta correcta
      'Es el valor que más veces se repite en el conjunto de datos': 2,  // Respuesta incorrecta
      'Es el promedio de todos los datos': 3  // Respuesta incorrecta
    }
  },
  {
    'pregunta': '¿Qué es la moda en un conjunto de datos?',
    'opciones': {
      'Es el valor que más veces se repite en el conjunto de datos': 1, // Respuesta correcta
      'Es el valor más alto menos el valor más bajo': 2,  // Respuesta incorrecta
      'Es el promedio de todos los datos': 3  // Respuesta incorrecta
    }
  },
  {
    'pregunta': '¿Qué es la varianza en estadística?',
    'opciones': {
      'Es una medida de la dispersión que indica cuánto se desvían los datos respecto a la media': 1, // Respuesta correcta
      'Es el valor máximo menos el valor mínimo en un conjunto de datos': 2,  // Respuesta incorrecta
      'Es la suma de todos los datos dividida por su cantidad': 3  // Respuesta incorrecta
    }
  }
]

  };

  bool _isLoading = false;
  List<String> _recommendedSubjects = [];

  void _showResultsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Te recomendamos fortalecer:'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _recommendedSubjects.map((subject) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(subject),  // Mostrar la materia
                ElevatedButton(
                  onPressed: () {
                    // Redirigir a InterfazTutorias con la materia
                    _buscarTutoria(subject);
                  },
                  child: Text('Buscar Tutoría'),
                ),
              ],
            );
          }).toList(),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();  // Cerrar el diálogo
            },
            child: Text('Cerrar'),
          ),
        ],
      );
    },
  );
}


  // Mostrar las recomendaciones en la interfaz
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Examen Diagnóstico'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                          _buildSection('Matematicas'),
                          _buildSection('Fisica'),
                          _buildSection('Quimica'),
                          _buildSection('Programacion'),
                          _buildSection('Probabilidad_Y_Estadistica'),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: Text('Enviar Respuestas'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSection(String section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _questions[section]!.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> questionData = entry.value;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                questionData['pregunta'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ...questionData['opciones'].keys.map((String option) {
                return RadioListTile<int>(
                  title: Text(option), // Texto de la opción
                  value: questionData['opciones'][option] as int, // Valor de la opción
                  groupValue: _responses[section]?[index], // Valor actual seleccionado
                  onChanged: (int? value) {
                    setState(() {
                      _responses[section]![index] = value!; // Guardar la opción seleccionada
                    });
                  },
                );
              }).toList(),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _getRecommendations();
    }
  }

  void _buscarTutoria(String materiaReforzar) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => InterfazTutorias(materiaBuscada: materiaReforzar),
    ),
  );
}

  // Enviar los promedios a la API de PythonAnywhere para obtener las predicciones
  void _getRecommendations() async {
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> promedios = {
      'Promedio_Matematicas': (_responses['Matematicas']?.values.map((val) => val == 1 ? 1 : 0).reduce((a, b) => a + b) ?? 0) * 20,
      'Promedio_Fisica': (_responses['Fisica']?.values.map((val) => val == 1 ? 1 : 0).reduce((a, b) => a + b) ?? 0) * 20,
      'Promedio_Quimica': (_responses['Quimica']?.values.map((val) => val == 1 ? 1 : 0).reduce((a, b) => a + b) ?? 0) * 20,
      'Promedio_Programacion': (_responses['Programacion']?.values.map((val) => val == 1 ? 1 : 0).reduce((a, b) => a + b) ?? 0) * 20,
      'Promedio_Probabilidad_Y_Estadistica': (_responses['Probabilidad_Y_Estadistica']?.values.map((val) => val == 1 ? 1 : 0).reduce((a, b) => a + b) ?? 0) * 20
    };


    print("Datos enviados a la API: ${json.encode(promedios)}");

  // Enviar el promedio a la API de IA
  final response = await http.post(
    Uri.parse('http://jorgeamaro210.pythonanywhere.com/predict'), // Reemplazar con tu URL de PythonAnywhere
    headers: {"Content-Type": "application/json"},
    body: json.encode(promedios),
  );

  // Verifica el código de estado y el cuerpo de la respuesta
  print("Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    final resultado = json.decode(response.body);

    // Filtrar solo las materias que necesitan ayuda (valor == 1)
    List<String> materiasConRefuerzo = [];
    if (resultado['Necesita_Ayuda_Matematicas'] == 1) {
      materiasConRefuerzo.add('Matemáticas');
    }
    if (resultado['Necesita_Ayuda_Fisica'] == 1) {
      materiasConRefuerzo.add('Física');
    }
    if (resultado['Necesita_Ayuda_Quimica'] == 1) {
      materiasConRefuerzo.add('Química');
    }
    if (resultado['Necesita_Ayuda_Programacion'] == 1) {
      materiasConRefuerzo.add('Programación');
    }
    if (resultado['Necesita_Ayuda_Probabilidad_Y_Estadistica'] == 1) {
      materiasConRefuerzo.add('Probabilidad y Est.');
    }

    setState(() {
      _recommendedSubjects = materiasConRefuerzo;
      _isLoading = false;

      // Mostrar los resultados en una ventana emergente
      _showResultsDialog(context);
    });
  } else {
    setState(() {
      _isLoading = false;
      print("Error: ${response.statusCode}");
    });
  }
  }
}