import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  // var _enteredTitle = "";
  // void _saveTitleInput(String inputValue) {
  //   _enteredTitle = inputValue;
  // }
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Categaory _selctedCategory = Categaory.work;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(2015, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
    //this line only excuted after date is picked await waits :)
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _sumbitExpenseData() {
    final enteredAmout = int.tryParse(_amountController.text);
    final amountIsIvalid = enteredAmout == null || enteredAmout <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsIvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Input..."),
          content: const Text(
              "Please recheck if you have entered all the required details correctly!!!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text("Okay!"),
            ),
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(
      Expense(
          amount: int.parse(enteredAmout.toString()),
          title: _titleController.text,
          date: _selectedDate!,
          categaory: _selctedCategory),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final KeyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, KeyboardSpace + 16),
          child: Column(
            children: [
              TextField(
                // onChanged: _saveTitleInput,
                controller: _titleController,
                maxLength: 100,
                decoration: const InputDecoration(
                  label: Text("Title"),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        prefixText: '₹',
                        label: Text("Amount"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          _selectedDate == null
                              ? "No date selected"
                              : formatter.format(_selectedDate!),
                        ),
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(
                            Icons.calendar_month,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  DropdownButton(
                    value: _selctedCategory,
                    items: Categaory.values
                        .map(
                          (categaory) => DropdownMenuItem(
                            value: categaory,
                            child: Text(
                              categaory.name.toUpperCase(),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (values) {
                      if (values == null) {
                        return;
                      }
                      setState(() {
                        _selctedCategory = values;
                      });
                    },
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: _sumbitExpenseData,
                    child: const Text("Save"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
