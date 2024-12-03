import 'package:flutter/material.dart';
import 'history_screen.dart';
import '../services/database_service.dart';
import 'package:google_fonts/google_fonts.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = '0';
  String _input = '';
  double? _num1; // Перше число
  double? _num2; // Друге число
  String? _operator; // Оператор

  // Історія обчислень
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  // Завантаження історії з бази даних
  Future<void> _loadHistory() async {
    final db = await DatabaseService().database;
    final userHistory = await db.query(
      'calculations',
      orderBy: 'timestamp DESC',
      limit: 10, // Обмежуємо кількість записів
    );

    setState(() {
      _history = userHistory.map((e) => e['calculation'] as String).toList();
    });
  }

  // Форматування результату
  String formatResult(double result) {
    if (result % 1 == 0) {
      return result.toInt().toString(); // Ціле число без дробової частини
    } else {
      return result.toString(); // З плаваючою точкою
    }
  }

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _input = '';
        _output = '0';
        _num1 = null;
        _num2 = null;
        _operator = null;
      } else if (value == '+' || value == '-' || value == '*' || value == '/') {
        if (_num1 == null) {
          _num1 = double.tryParse(_input);
          _input = '';
          _operator = value;
        }
      } else if (value == '=') {
        if (_num1 != null && _operator != null && _input.isNotEmpty) {
          _num2 = double.parse(_input); // Друге число

          double result;
          switch (_operator) {
            case '+':
              result = _num1! + _num2!;
              break;
            case '-':
              result = _num1! - _num2!;
              break;
            case '*':
              result = _num1! * _num2!;
              break;
            case '/':
              result = _num2! != 0 ? _num1! / _num2! : double.nan;
              break;
            default:
              result = 0;
          }

          _output = formatResult(result); // Форматуємо результат

          // Додаємо обчислення в історію
          _saveCalculation(_num1!, _operator!, _num2!, result);

          _input = '';
          _num1 = null;
          _operator = null;
        }
      } else {
        _input += value;
        _output = _input;
      }
    });
  }

  // Збереження обчислення в базу даних
  Future<void> _saveCalculation(double num1, String operator, double num2, double result) async {
    final db = await DatabaseService().database;

    try {
      await db.insert('calculations', {
        'calculation': '$num1 $operator $num2 = ${formatResult(result)}',
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error saving calculation: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        actions: [
          IconButton(
            icon: Icon(Icons.history_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.all(24),
              child: Text(
                _output,
                style: TextStyle(fontSize: 52, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _buildButtonRow(['7', '8', '9', '/']),
                _buildButtonRow(['4', '5', '6', '*']),
                _buildButtonRow(['1', '2', '3', '-']),
                _buildButtonRow(['C', '0', '=', '+']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons.map((btn) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3.0), // Зменшили відступ
              child: ElevatedButton(
                onPressed: () => _onButtonPressed(btn),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70,
                  foregroundColor: Colors.black,
                  shape: CircleBorder(), // Кругла форма кнопки
                  padding: EdgeInsets.all(15), // Зменшили розмір кнопок
                  textStyle: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text(btn),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
