import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import '../authentication/login.dart';

class Todo {
  final String title;
  final DateTime? dueDate;
  bool isCompleted;

  Todo({
    required this.title,
    this.dueDate,
    this.isCompleted = false,
  });
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Todo> todos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return ListTile(
            leading: Checkbox(
              value: todo.isCompleted,
              onChanged: (newValue) {
                setState(() {
                  todo.isCompleted = newValue!;
                  if (newValue) {
                    _moveToTop(index);
                  }
                });
              },
            ),
            title: Text(todo.title),
            subtitle: todo.dueDate != null
                ? Text(
                    'Due Date: ${todo.dueDate!.day}/${todo.dueDate!.month}/${todo.dueDate!.year}')
                : null,
            trailing: IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                _deleteTodo(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodo();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTodo() async {
    final Todo? newTodo = await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController titleController = TextEditingController();
        DateTime? selectedDate;
        return AlertDialog(
          title: Text('Add New Todo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Todo Title'),
              ),
              SizedBox(height: 8),
              ListTile(
                title: Text(selectedDate != null
                    ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                    : 'Select Due Date'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  String task = titleController.text;
                  print('$task');
                  ParseObject user = ParseObject('TaskList')
                    ..set('Tasks', '$task');
                  await user.save();
                  Navigator.of(context).pop(Todo(
                    title: titleController.text,
                    dueDate: selectedDate,
                  ));
                },
                child: Text('Add Todo'),
              ),
            ],
          ),
        );
      },
    );

    if (newTodo != null) {
      setState(() {
        todos.add(newTodo);
        _sortTodosByDueDate();
      });
    }
  }

  void _sortTodosByDueDate() {
    todos.sort((a, b) {
      if (a.dueDate == null) {
        return 1;
      } else if (b.dueDate == null) {
        return -1;
      }
      return a.dueDate!.compareTo(b.dueDate!);
    });
  }

  void _moveToTop(int index) {
    setState(() {
      final Todo item = todos.removeAt(index);
      todos.insert(0, item);
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginApp()),
    );
  }
}
