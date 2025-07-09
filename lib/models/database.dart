import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:tugas_mobile_money_tracker_login_register/models/category.dart';
import 'package:tugas_mobile_money_tracker_login_register/models/transaction.dart';
import 'package:tugas_mobile_money_tracker_login_register/models/transaction_with_category.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [Categories, Transactions],
)
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // ============================
  // CATEGORY CRUD
  // ============================
  Future<List<Category>> getAllCategoryRepo(int type) {
    return (select(categories)..where((tbl) => tbl.type.equals(type))).get();
  }

  Future updateCategoryRepo(int id, String name) {
    return (update(categories)..where((tbl) => tbl.id.equals(id)))
        .write(CategoriesCompanion(name: Value(name)));
  }

  Future deleteCategoryRepo(int id) {
    return (delete(categories)..where((tbl) => tbl.id.equals(id))).go();
  }

  // ============================
  // TRANSACTION CRUD
  // ============================
  Stream<List<TransactionWithCategory>> getTransactionByDateRepo(DateTime date) {
    final query = (select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.category_id)),
    ])..where(transactions.transaction_date.equals(date)));

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithCategory(
          row.readTable(transactions),
          row.readTable(categories),
        );
      }).toList();
    });
  }

  Stream<List<TransactionWithCategory>> getTransactionByMonthRepo(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);

    final query = (select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.category_id)),
    ])
      ..where(transactions.transaction_date.isBetweenValues(firstDay, lastDay)));

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithCategory(
          row.readTable(transactions),
          row.readTable(categories),
        );
      }).toList();
    });
  }

  Future updateTransactionRepo(
      int id,
      int amount,
      int categoryId,
      DateTime transactionDate,
      String nameDetail,
      ) {
    return (update(transactions)..where((tbl) => tbl.id.equals(id)))
        .write(TransactionsCompanion(
      name: Value(nameDetail),
      amount: Value(amount),
      category_id: Value(categoryId),
      transaction_date: Value(transactionDate),
    ));
  }

  Future deleteTransactionRepo(int id) {
    return (delete(transactions)..where((tbl) => tbl.id.equals(id))).go();
  }
}

// koneksi database
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
