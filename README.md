[17:30, 09/07/2025] Egun: # 📱 EuyMoney - Aplikasi Mobile Pencatat Keuangan

![Flutter](https://img.shields.io/badge/Flutter-3.22-blue?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.3-blue?logo=dart&logoColor=white)
![Drift](https://img.shields.io/badge/Drift-LocalDB-informational?logo=sqlite&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Auth-yellow?logo=firebase&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

> Dibuat menggunakan Flutter & Dart  
> Project Mata Kuliah *Pemrograman Mobile*  
> Oleh: Ryandra & Erlangga

---

## ✨ Ringkasan Singkat

EuyMoney adalah aplikasi mobile untuk mencatat pemasukan dan pengeluaran harian, dengan fitur utama seperti tambah transaksi, filter tanggal, dan ringkasan keuangan bulanan. Aplikasi juga telah terintegrasi dengan Firebase Authentication untuk proses login/register pengguna. Semua data transaksi disimpan *lokal* tanpa koneksi internet.

---

## 🧠 Latar Belakang

Manajemen keuangan pribadi menjadi tantangan, terutama bagi anak muda yang sering melakukan pembelian impulsif — yaitu membeli sesuatu secara tiba-tiba tanpa perencanaan. Aplikasi ini dikembangkan sebagai solusi praktis untuk melacak arus kas harian secara cepat dan sederhana, sekaligus mempersiapkan fondasi personalisasi lewat login pengguna.

---

## 🎯 Tujuan Aplikasi

- Mencatat transaksi (income/expense)
- Menyediakan ringkasan keuangan bulanan
- Menyimpan data secara lokal tanpa internet
- Memberikan UI yang simpel dan efisien
- Mendukung login/register pengguna dengan Firebase Authentication

---

## 🛠️ Teknologi yang Digunakan

- Flutter & Dart
- Drift (Local Database berbasis SQLite)
- Firebase Authentication
- Flutter Material Widgets (tampilan modern dan responsif)

---

## 📱 Tampilan Aplikasi

| Home Page | Add Transaction | Add Category |
|-----------|-----------------|---------|
| ![Home](screenshots/home.png) | ![Add](screenshots/insert.png) | ![Summary](screenshots/income.png) |

---

## 🧩 Fitur Utama

- [x] Login & Register dengan Firebase Authentication
- [x] Tambah/Edit/Hapus Transaksi
- [x] Filter transaksi berdasarkan tanggal (kalender/date picker)
- [x] Ringkasan total pemasukan dan pengeluaran
- [x] UI adaptif, responsif, dan clean

---

## 🧪 Alur Penggunaan

1. Login atau register menggunakan akun Firebase
2. Tambahkan kategori baru (jika diperlukan)
3. Masukkan transaksi keuangan harian
4. Gunakan filter untuk melihat transaksi pada tanggal tertentu
5. Lihat ringkasan bulanan
6. Done 💸

---

## 🤝 Pembagian Tugas

| Nama     | Tanggung Jawab                                                                 |
|----------|---------------------------------------------------------------------------------|
| Ryandra  | Homepage, UI Category & Transaction, Integrasi Drift, Final Debug & Integration |
| Erlangga | CRUD Category, Insert & Show Transaction, Update & Delete Transaction, Firebase Auth |

---

## 🧠 Pembelajaran & Tantangan

- Implementasi database lokal dengan Drift
- Integrasi Firebase Authentication untuk login/register pengguna
- Modularisasi UI agar reusable & maintainable
- Debugging perbedaan perilaku UI antara emulator dan device asli

---

## 📌 Catatan Tambahan

- Data transaksi disimpan *lokal* (tidak memerlukan koneksi internet)
- Firebase hanya digunakan untuk proses login/register pengguna
- Kompatibel dari Android SDK 21+

---

## 🔮 Rencana Pengembangan (Opsional)

- Sinkronisasi data transaksi ke Firebase Firestore atau Realtime Database
- State management menggunakan Provider atau Riverpod
- Fitur dark mode
- Visualisasi data keuangan dengan chart
- Export data ke PDF/Excel
[17:31, 09/07/2025] Egun: ---

## 🙌 Terima Kasih

Proyek ini disusun sebagai bagian dari tugas akhir mata kuliah *Pemrograman Mobile*.  
Terima kasih untuk dosen pengampu, rekan satu tim, dan semua pihak yang telah mendukung proses pengembangan aplikasi ini.

---

> © 2025 Ryandra & Erlangga — All rights reserved.  
> Dibuat dengan ❤️ menggunakan Flutter + Firebase + Drift
