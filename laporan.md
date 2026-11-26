# Laporan Praktikum Mandiri: Arsitektur MVC, MVVM, dan Pengujian Flutter

## Identitas Mahasiswa
* **Nama:** Faturrachman Wiguna
* **Nim:** 362558302078
* **Program Studi:** Teknologi Rekayasa Perangkat Lunak (TRPL) — Politeknik Negeri Banyuwangi
* **Kelas:** 2RPLE
* **Mata Kuliah:** Pemrograman Perangkat Bergerak

---

## Cara Menjalankan Aplikasi dan Pengujian

1. Buka terminal pada direktori root proyek (`prak_arsitektur_tugas/`).
2. Unduh dependensi proyek:
   ```bash
   flutter pub get
   ```
3. Jalankan aplikasi di browser Chrome:
   ```bash
   flutter run -d chrome
   ```
4. Jalankan analisis kode dan seluruh pengujian otomatis:
   ```bash
   flutter analyze
   flutter test
   ```

---

## Perbandingan Arsitektur MVC dan MVVM

### 1. Penerima Aksi & Penyimpan Pilihan Filter
* **Versi MVC:** Aksi diterima oleh method `_ubahFilter(bool nilai)` pada class `_LayarMvcState` (`lib/mvc/layar_mvc.dart`), lalu diteruskan ke method `ubahFilter(bool nilai)` pada class `PengendaliTugas` (`lib/mvc/pengendali_tugas.dart`) yang menyimpan state `_hanyaBelumSelesai`.
* **Versi MVVM:** Callback `onSelected` pada `FilterChip` langsung terhubung ke method `ubahFilter(bool nilai)` pada class `TugasViewModel` (`lib/mvvm/tugas_view_model.dart`), yang menerima aksi sekaligus menyimpan state `_hanyaBelumSelesai`.

### 2. Pemicu Rebuild & Dampak Jika Pemicu Dihapus
* **Versi MVC:**
  * **Pemicu rebuild:** Pemanggilan `setState(() => _pengendali.ubahFilter(nilai))` di dalam `_LayarMvcState`.
  * **Percobaan saat pemicu dihapus:** Ketika `setState` dihapus sementara, mengetuk chip *Belum selesai* tetap mengubah nilai `_hanyaBelumSelesai` di dalam Controller, tetapi UI tidak membangun ulang layar. Akibatnya status chip tidak berubah menjadi terpilih, tugas yang sudah selesai tetap tampil, dan `flutter test test/filter_test.dart` gagal pada tahap aktivasi filter. Setelah `setState` dikembalikan, UI dan pengujian kembali lulus.
* **Versi MVVM:**
  * **Pemicu rebuild:** Pemanggilan `notifyListeners()` di akhir method `ubahFilter(bool nilai)` pada `TugasViewModel` yang didengarkan oleh `ListenableBuilder` di `LayarMvvm`.
  * **Percobaan saat pemicu dihapus:** Ketika `notifyListeners()` dihapus sementara, state filter di ViewModel berubah secara internal, tetapi `ListenableBuilder` tidak menerima notifikasi pembaruan. Akibatnya daftar tugas tidak tersaring dan widget test filter gagal. Setelah `notifyListeners()` dikembalikan, UI dan pengujian kembali lulus.

### 3. Pemilihan Pola Berdasarkan Kebutuhan
* **Versi MVC:**
  * **Skenario cocok:** Layar tunggal sederhana dengan interaksi langsung dan state tampilan yang minimal.
  * **Kelebihan:** Alur dari interaksi pengguna hingga pembaruan tampilan mudah ditelusuri dalam satu file layar (`LayarMvc`) tanpa kode listener tambahan.
  * **Biaya / Risiko:** Pengembang wajib membungkus setiap aksi pengubah data (`_tambah`, `_ubahStatus`, `_ubahFilter`) dengan `setState()`. Jika terlewat satu saja, data di model berubah tanpa pembaruan pada layar.
* **Versi MVVM:**
  * **Skenario cocok:** Layar kompleks dengan banyak state saling bergantung (seperti daftar tersaring, ringkasan total, dan pesan validasi) yang perlu diuji terpisah dari UI.
  * **Kelebihan:** Seluruh state UI terpusat pada satu sumber (`TugasViewModel`) dan notifikasi perubahannya dapat diuji langsung melalui unit test (`addListener`) tanpa merender widget.
  * **Biaya / Risiko:** Memerlukan pengelolaan lifecycle (`dispose()`) pada `State` layar serta kedisiplinan memanggil `notifyListeners()` setiap kali terjadi mutasi state.

---

## Keluaran Terminal Setelah Pemulihan Kode

```text
> flutter analyze
PS D:\kuliah\Sem_3\mobileFlutter\Starter-Praktikum-MVC-MVVM-Flutter\prak_arsitektur_tugas> 
                                                                                           flutter analyze
Analyzing prak_arsitektur_tugas...                                      
No issues found! (ran in 25.2s)

> flutter test
PS D:\kuliah\Sem_3\mobileFlutter\Starter-Praktikum-MVC-MVVM-Flutter\prak_arsitektur_tugas> flutter test test/filter_test.dart
00:02 +2: All tests passed!    

---

## Bukti Tangkapan Layar
* `bukti/mvc-filter-mati.png` — Tampilan MVC dengan 2 tugas (ringkasan `1 dari 2 selesai`) saat filter mati.
   ![alt text](<Screenshot 2026-11-26 110454.png>)
* `bukti/mvc-filter-aktif.png` — Tampilan MVC dengan 2 tugas yang sama (ringkasan `1 dari 2 selesai`) saat filter aktif.
   ![alt text](<Screenshot 2026-11-26 110506.png>)
* `bukti/mvvm-filter-mati.png` — Tampilan MVVM dengan 2 tugas (ringkasan `1 dari 2 selesai`) saat filter mati.
   ![alt text](<Screenshot 2026-11-26 110757.png>)
* `bukti/mvvm-filter-aktif.png` — Tampilan MVVM dengan 2 tugas yang sama (ringkasan `1 dari 2 selesai`) saat filter aktif.
  ![alt text](<Screenshot 2026-11-26 110826.png>)