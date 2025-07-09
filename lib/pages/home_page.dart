import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tugas_mobile_money_tracker_login_register/models/db_instance.dart'; // Pakai dbInstance global
import 'package:tugas_mobile_money_tracker_login_register/models/transaction_with_category.dart';
import 'package:tugas_mobile_money_tracker_login_register/pages/transaction_page.dart';

final database = dbInstance;

class HomePage extends StatefulWidget {
  final DateTime selectedDate;

  const HomePage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ❌ HAPUS INI: final AppDb database = AppDb(); ❌

  Future<void> _navigateToEditTransaction(TransactionWithCategory trx) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionPage(transactionWithCategory: trx),
      ),
    );
    if (result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TransactionWithCategory>>(
      stream: database.getTransactionByMonthRepo(widget.selectedDate),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: Text("Data Transaksi Masih Kosong")),
          );
        }

        final filteredTransactions = snapshot.data!
            .where((trx) =>
        DateFormat('yyyy-MM-dd')
            .format(trx.transaction.transaction_date) ==
            DateFormat('yyyy-MM-dd').format(widget.selectedDate))
            .toList();

        int totalIncome = 0;
        int totalExpense = 0;
        for (var trx in snapshot.data!) {
          if (trx.category.type == 1) {
            totalIncome += trx.transaction.amount;
          } else {
            totalExpense += trx.transaction.amount;
          }
        }

        int dailyIncome = 0;
        int dailyExpense = 0;
        for (var trx in filteredTransactions) {
          if (trx.category.type == 1) {
            dailyIncome += trx.transaction.amount;
          } else {
            dailyExpense += trx.transaction.amount;
          }
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard total income & expense
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(221, 72, 70, 70),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Income
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.download, color: Colors.green),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Income",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Rp. $totalIncome",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Expense
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.upload, color: Colors.red),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Expense",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Rp. $totalExpense",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Transactions (${DateFormat('dd MMM yyyy').format(widget.selectedDate)})",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Text(
                  "(+Rp. $dailyIncome / -Rp. $dailyExpense)",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              ...filteredTransactions.map((trx) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor:
                        trx.category.type == 1 ? Colors.green : Colors.red,
                        child: Icon(
                          trx.category.type == 1
                              ? Icons.download
                              : Icons.upload,
                          color: Colors.white,
                        ),
                      ),
                      title: Text("Rp. ${trx.transaction.amount}"),
                      subtitle:
                      Text("${trx.category.name} (${trx.transaction.name})"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _navigateToEditTransaction(trx),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await database.deleteTransactionRepo(
                                  trx.transaction.id);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              if (filteredTransactions.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text("Tidak ada transaksi di tanggal ini"),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
