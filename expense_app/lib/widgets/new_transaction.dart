import 'package:expense_app/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function txHandler;
  final Transaction oldTx;

  NewTransaction(this.txHandler, [this.oldTx]);

  @override
  _NewTransactionState createState() => _NewTransactionState(oldTx);
}

class _NewTransactionState extends State<NewTransaction> {
  TextEditingController _titleController;
  TextEditingController _amountController;
  final _titleFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();

  Transaction oldTx;

  _NewTransactionState(this.oldTx) {
    if (oldTx == null) {
      oldTx = Transaction.empty();
    }

    _titleController = TextEditingController(
      text: oldTx.title,
    );
    _amountController = TextEditingController(
      text: oldTx.amount == 0 ? '' : oldTx.amount.toString(),
    );
  }

  @override
  void initState() {
    super.initState();
    _titleFocusNode.addListener(() {
      if (_titleFocusNode.hasFocus) {
        _titleController.selection = TextSelection(
            baseOffset: 0, extentOffset: _titleController.text.length);
      }
    });

    _amountFocusNode.addListener(() {
      if (_amountFocusNode.hasFocus) {
        _amountController.selection = TextSelection(
            baseOffset: 0, extentOffset: _amountController.text.length);
      }
    });
  }

  void _submitData() {
    oldTx.title = _titleController.text.trim();
    oldTx.amount = double.tryParse(_amountController.text.trim());

    if (oldTx.title.isEmpty || oldTx.amount == null || oldTx.amount <= 0) {
      return;
    }

    widget.txHandler(oldTx);

    Navigator.of(context).pop(true);
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 1),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        oldTx.date = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
                focusNode: _titleFocusNode,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                focusNode: _amountFocusNode,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => FocusScope.of(context).unfocus(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Picked Date: ${DateFormat.yMMMd().format(oldTx.date)}',
                      ),
                    ),
                    AdaptiveFlatButton(
                      'Choose date',
                      _presentDatePicker,
                    ),
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Save Transaction'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: _submitData,
              )
            ],
          ),
        ),
      ),
    );
  }
}
