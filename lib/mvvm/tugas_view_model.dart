import 'package:flutter/foundation.dart';
import '../data/repositori_tugas.dart';
import '../model/tugas.dart';

class TugasViewModel extends ChangeNotifier {
  TugasViewModel(this._repo);
  final RepositoriTugas _repo;
  String? _galat;
  bool _hanyaBelumSelesai = false; //ditambah

  List<Tugas> get daftar => _repo.daftar;
  String? get galat => _galat;
  bool get hanyaBelumSelesai => _hanyaBelumSelesai; //ditambah

  List<Tugas> get daftarTampil { //ditambah
    if (_hanyaBelumSelesai) {
      return _repo.daftar.where((tugas) => !tugas.selesai).toList();
    }
    return _repo.daftar;
  }

  int get totalTugas => _repo.daftar.length; //ditambah
  int get jumlahSelesai => _repo.daftar.where((tugas) => tugas.selesai).length; //diubh pakai _repo.daftar

  bool tambah(String input) {
    _galat = validasiJudul(input);
    final berhasil = _galat == null;
    if (berhasil) _repo.tambah(input.trim());
    notifyListeners();
    return berhasil;
  }

  void ubahStatus(int id) {
    _repo.ubahStatus(id);
    notifyListeners();
  }

  void ubahFilter(bool nilai) { //ditambah
    _hanyaBelumSelesai = nilai;
    notifyListeners();
  }
}