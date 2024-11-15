import 'package:flutter/material.dart';
import 'package:flutter_application_illumina/models/Tarefa.dart';
import 'package:flutter_application_illumina/screens/tarefa/formTarefa.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class Tarefas extends StatefulWidget {
  const Tarefas({Key? key}) : super(key: key);

  @override
  State<Tarefas> createState() => _TarefasState();
}

class _TarefasState extends State<Tarefas> {
  final now = DateTime.now();
  late DateTime _selectedDate;
  final List<Tarefa> _tarefas = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
    Intl.defaultLocale = 'pt_BR';
    _selectedDate = now;
  }

  void _adicionarTarefa(Tarefa tarefa) {
    setState(() {
      _tarefas.add(tarefa);
    });
  }

  List<Tarefa> _tarefasFiltradas() {
    return _tarefas.where((tarefa) {
      return tarefa.data.year == _selectedDate.year &&
             tarefa.data.month == _selectedDate.month &&
             tarefa.data.day == _selectedDate.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Tarefas',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: ListView(
        children: [
          _addTarefa(context),
          _dateBar(),
          _tarefasFiltradas().isEmpty
              ? const Center(
                  child: Text(
                    "Nenhuma tarefa para hoje.",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Column(
                  children: _tarefasFiltradas().map((tarefa) {
                    return ListTile(
                      title: Text(
                        tarefa.titulo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        tarefa.nota,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.greenAccent,
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _addTarefa(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: 0,
        child: ListTile(
          title: const Text(
            "Hoje",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            DateFormat("d 'de' MMMM 'de' yyyy", 'pt_BR').format(now),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
          trailing: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Tarefa'),
            onPressed: () async {
              final tarefa = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FormTarefa(),
                ),
              );

              if (tarefa != null) {
                _adicionarTarefa(tarefa);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _dateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 70,
        initialSelectedDate: _selectedDate,
        selectionColor: const Color(0xFF919CAE),
        selectedTextColor: Colors.white,
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
        monthTextStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        dateTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        dayTextStyle: const TextStyle(
          fontSize: 10,
          color: Colors.white,
        ),
        locale: 'pt',
      ),
    );
  }
}
