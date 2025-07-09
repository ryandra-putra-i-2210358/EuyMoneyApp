import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tugas_mobile_money_tracker_login_register/models/db_instance.dart';

import 'package:tugas_mobile_money_tracker_login_register/models/database.dart';
import 'package:tugas_mobile_money_tracker_login_register/models/transaction_with_category.dart';


final database = dbInstance; // BUKAN AppDb()

class TransactionPage extends StatefulWidget {
  final TransactionWithCategory? transactionWithCategory;
  const TransactionPage({Key? key, this.transactionWithCategory})
    : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  bool isExpense = true;

  late int type;
  List<String> list = ['Makan dan jajan', 'Transportasi', 'Nonton Film'];
  late String dropDownValue = list.first;
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  Category? selectedCategory;

  Future insert(
      int amount,
      DateTime date,
      String nameDetail,
      int categoryId,
      ) async {
    DateTime now = DateTime.now();
    await database.into(database.transactions).insertReturning(
      TransactionsCompanion.insert(
        name: nameDetail,
        category_id: categoryId,
        transaction_date: date,
        amount: amount,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  Future update(
      int transactionId,
      int amount,
      int categoryId,
      DateTime transactionDate,
      String nameDetail,
      ) async {
    return await database.updateTransactionRepo(
      transactionId,
      amount,
      categoryId,
      transactionDate,
      nameDetail,
    );
  }

  @override
  void initState() {
    if (widget.transactionWithCategory != null) {
      updateTransactionView(widget.transactionWithCategory!);
    } else {
      type = 2;
    }
    super.initState();
  }

  void updateTransactionView(TransactionWithCategory trx) {
    amountController.text = trx.transaction.amount.toString();
    detailController.text = trx.transaction.name;
    dateController.text = DateFormat("yyyy-MM-dd").format(trx.transaction.transaction_date);
    type = trx.category.type;
    isExpense = type == 2;
    selectedCategory = trx.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Transaction")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 30, 20, 40),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Income/Expense Switch
              Row(
                children: [
                  Switch(
                    value: isExpense,
                    onChanged: (bool value) {
                      setState(() {
                        isExpense = value;
                        type = isExpense ? 2 : 1;
                        selectedCategory = null;
                      });
                    },
                    inactiveTrackColor: Colors.green[200],
                    inactiveThumbColor: Colors.green,
                    activeColor: Colors.red,
                  ),
                  Text(
                    isExpense ? 'Expense' : 'Income',
                    style: GoogleFonts.montserrat(fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 15, 10),
                child: TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Amount",
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 15, 15, 10),
                child: Text(
                  "Category",
                  style: GoogleFonts.montserrat(fontSize: 15),
                ),
              ),
              FutureBuilder<List<Category>>(
                future: getAllCategory(type),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    if (selectedCategory == null) {
                      selectedCategory = snapshot.data!.first;
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButton<Category>(
                        value: selectedCategory,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_downward),
                        items: snapshot.data!.map((Category item) {
                          return DropdownMenuItem<Category>(
                            value: item,
                            child: Text(item.name),
                          );
                        }).toList(),
                        onChanged: (Category? value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                    );
                  }
                  return Center(child: Text("Tidak ada kategori"));
                },
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  readOnly: true,
                  controller: dateController,
                  decoration: InputDecoration(labelText: "Enter Date"),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2099),
                    );
                    if (pickedDate != null) {
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                      dateController.text = formattedDate;
                    }
                  },
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 15, 10),
                child: TextFormField(
                  controller: detailController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Detail",
                  ),
                ),
              ),
              SizedBox(height: 25),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // Validasi input
                    if (amountController.text.isEmpty ||
                        dateController.text.isEmpty ||
                        detailController.text.isEmpty ||
                        selectedCategory == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Semua field harus diisi!')),
                      );
                      return;
                    }

                    int? amount = int.tryParse(amountController.text);
                    if (amount == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Amount harus berupa angka!')),
                      );
                      return;
                    }

                    DateTime? date;
                    try {
                      date = DateTime.parse(dateController.text);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Format tanggal salah!')),
                      );
                      return;
                    }

                    if (widget.transactionWithCategory == null) {
                      await insert(amount, date, detailController.text, selectedCategory!.id);
                    } else {
                      await update(
                        widget.transactionWithCategory!.transaction.id,
                        amount,
                        selectedCategory!.id,
                        date,
                        detailController.text,
                      );
                    }

                    Navigator.pop(context, true);
                  },
                  child: Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

