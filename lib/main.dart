import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String output = "0"; // Muestra el número actual
  String input = ""; // Muestra el historial de entrada
  List<String> inputHistory = []; // Lista para almacenar los números y operadores
  bool isNewInput = true; // Indica si estamos en un nuevo número después de una operación

  // Función que maneja la lógica de las operaciones
  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "AC") {
        // Resetear todo
        output = "0";
        input = "";
        inputHistory.clear();
        isNewInput = true;
      } else if (buttonText == "+" || buttonText == "-" || buttonText == "÷" || buttonText == "×") {
        // Si presionas un operador
        if (!isNewInput) {
          inputHistory.add(output);  // Agregar el número actual a la lista
          inputHistory.add(buttonText);  // Agregar el operador a la lista
          input += " $output $buttonText";  // Agregar al historial visual
        }
        isNewInput = true;
      } else if (buttonText == ".") {
        // Si el punto ya está en la cadena, no lo agregamos
        if (!output.contains(".")) {
          output += buttonText;
          isNewInput = false;
        }
      } else if (buttonText == "=") {
        // Realizamos el cálculo con todos los números y operadores almacenados
        inputHistory.add(output); // Agregar el último número antes de calcular
        calculate();
        input += " $output ="; // Agregar el resultado al historial de entrada
      } else {
        // Si presionas un número
        if (isNewInput) {
          output = buttonText;  // Si es el primer número o después de un operador, reinicia el valor
          isNewInput = false;
        } else {
          output += buttonText; // Concatenamos el número al actual
        }
      }
    });
  }

  // Función para realizar el cálculo con todos los números y operadores
  void calculate() {
    double result = double.tryParse(inputHistory[0]) ?? 0.0; // Primer número

    for (int i = 1; i < inputHistory.length; i += 2) {
      String operator = inputHistory[i];
      double num = double.tryParse(inputHistory[i + 1]) ?? 0.0;

      if (operator == "+") {
        result += num;
      } else if (operator == "-") {
        result -= num;
      } else if (operator == "×") {
        result *= num;
      } else if (operator == "÷") {
        if (num != 0) {
          result /= num;
        } else {
          result = double.nan;  // Manejo de error para división por cero
        }
      }
    }

    output = result.toString();  // Muestra el resultado final
    if (output.endsWith(".0")) {
      output = output.substring(0, output.length - 2);  // Eliminar decimales innecesarios
    }
  }

  // Función para construir los botones
  Widget buildButton(String buttonText, Color color, Color textColor) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => buttonPressed(buttonText),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(24),
          backgroundColor: color,
          shape: CircleBorder(),
        ),
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 24, color: textColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          // Pantalla que muestra el historial de entrada
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Text(
              input,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white70,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Pantalla que muestra el número actual
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            child: Text(
              output,
              style: TextStyle(
                fontSize: output.length > 10 ? 32 : 48,  // Ajusta el tamaño según la longitud del texto
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(child: Divider()),
          Column(
            children: [
              // Fila de botones de operaciones
              Row(
                children: [
                  buildButton("AC", Colors.grey, Colors.black),
                  buildButton("+/-", Colors.grey, Colors.black),
                  buildButton("%", Colors.grey, Colors.black),
                  buildButton("÷", Colors.orange, Colors.white),
                ],
              ),
              Row(
                children: [
                  buildButton("7", Colors.black54, Colors.white),
                  buildButton("8", Colors.black54, Colors.white),
                  buildButton("9", Colors.black54, Colors.white),
                  buildButton("×", Colors.orange, Colors.white),
                ],
              ),
              Row(
                children: [
                  buildButton("4", Colors.black54, Colors.white),
                  buildButton("5", Colors.black54, Colors.white),
                  buildButton("6", Colors.black54, Colors.white),
                  buildButton("-", Colors.orange, Colors.white),
                ],
              ),
              Row(
                children: [
                  buildButton("1", Colors.black54, Colors.white),
                  buildButton("2", Colors.black54, Colors.white),
                  buildButton("3", Colors.black54, Colors.white),
                  buildButton("+", Colors.orange, Colors.white),
                ],
              ),
              Row(
                children: [
                  buildButton("0", Colors.black54, Colors.white),
                  buildButton(",", Colors.black54, Colors.white),
                  buildButton(".", Colors.black54, Colors.white),
                  buildButton("=", Colors.orange, Colors.white),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
