import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/todo_model.dart';
import '../../providers/todo_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodoModal extends StatelessWidget {
  final String type;
  final Todo? item;
  final TextEditingController _formFieldController = TextEditingController();

  TodoModal({Key? key, required this.type, required this.item}) : super(key: key);

  // Method to show the title of the modal depending on the functionality
  Text _buildTitle() {
    switch (type) {
      case 'Add':
        return const Text("Add new todo");
      case 'Edit':
        return const Text("Edit todo");
      case 'Delete':
        return const Text("Delete todo");
      default:
        return const Text("");
    }
  }

  // Method to build the content or body depending on the functionality
  Widget _buildContent(BuildContext context) {
    switch (type) {
      case 'Delete':
        {
          return Text(
            "Are you sure you want to delete '${item!.title}'?",
          );
        }
      // Edit and add will have input field in them
      default:
        return TextField(
          controller: _formFieldController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        );
    }
  }

  void _addTodo(BuildContext context) {
    // Get current user UID
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;

      // Create new Todo object
      Todo temp = Todo(
        userId: userId,
        completed: false,
        title: _formFieldController.text,
      );

      // Add todo using TodoListProvider
      context.read<TodoListProvider>().addTodo(temp);

      // Close the dialog
      Navigator.of(context).pop();
    } else {
      print("No user is currently signed in.");
    }
  }

  TextButton _dialogAction(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (type == 'Add') {
          _addTodo(context); // Call _addTodo function for 'Add' action
        } else if (type == 'Edit') {
          context.read<TodoListProvider>().editTodo(item!.id!, _formFieldController.text);
          Navigator.of(context).pop(); // Close the dialog after editing
        } else if (type == 'Delete') {
          context.read<TodoListProvider>().deleteTodo(item!.id!);
          Navigator.of(context).pop(); // Close the dialog after deleting
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(context),
      actions: <Widget>[
        _dialogAction(context),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cancel button
          },
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
