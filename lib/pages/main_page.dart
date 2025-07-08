import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tugas_mobile_money_tracker_login_register/pages/home_page.dart';
import 'package:tugas_mobile_money_tracker_login_register/pages/category_page.dart';
import 'package:tugas_mobile_money_tracker_login_register/pages/transaction_page.dart';
import 'package:tugas_mobile_money_tracker_login_register/pages/login_page.dart'; // Tambahkan ini

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  late DateTime selectedDate;
  late List<Widget> _children;
  late int currentIndex = 0;

  @override
  void initState() {
    selectedDate = DateTime.now();
    _children = [HomePage(selectedDate: selectedDate), CategoryPage()];
    super.initState();
  }

  void updateView(int index, DateTime? date) {
    setState(() {
      if (date != null) {
        selectedDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(date));
      }
      currentIndex = index;
      _children = [HomePage(selectedDate: selectedDate), CategoryPage()];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (currentIndex == 0)
          ? CalendarAppBar(
              backButton: false,
              accent: Colors.purple,
              locale: 'id',
              onDateChanged: (value) {
                setState(() {
                  selectedDate = value;
                  updateView(0, selectedDate);
                });
              },
              firstDate: DateTime.now().subtract(Duration(days: 140)),
              lastDate: DateTime.now(),
            )
          : PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: Container(
                color: Colors.yellow,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Categories',
                        style: GoogleFonts.montserrat(fontSize: 20),
                      ),
                      IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                            (Route<dynamic> route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: Visibility(
        visible: (currentIndex == 0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => TransactionPage()))
                .then((value) {
              setState(() {});
            });
          },
          backgroundColor: Colors.yellow,
          shape: CircleBorder(),
          child: Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
      body: _children[currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                updateView(0, DateTime.now());
              },
              icon: Icon(Icons.home),
              iconSize: 35,
            ),
            SizedBox(width: 20),
            IconButton(
              onPressed: () {
                updateView(1, null);
              },
              icon: Icon(Icons.list),
              iconSize: 35,
            ),
            // Tolong di buatkan fitur log ounya di sini bisa?
          ],
        ),
      ),
    );
  }
}
