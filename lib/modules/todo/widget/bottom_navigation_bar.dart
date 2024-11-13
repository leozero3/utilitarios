import 'package:flutter/material.dart';
import 'package:utilitarios/modules/todo/view/completed_todo_list_screen%20.dart';
import 'package:utilitarios/modules/todo/view/todo_list_screen.dart';

class MainTodoScreen extends StatefulWidget {
  const MainTodoScreen({super.key});

  @override
  _MainTodoScreenState createState() => _MainTodoScreenState();
}

class _MainTodoScreenState extends State<MainTodoScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const TodoListScreen(),
    const CompletedTodoListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tarefas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_all),
            label: 'Concluídas',
          ),
        ],
      ),
    );
  }
}
