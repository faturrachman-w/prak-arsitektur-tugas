import '../data/repositori_tugas.dart';
import '../model/tugas.dart';
class PengendaliTugas {
  PengendaliTugas(this._repo);
  final RepositoriTugas _repo;
  String? _galat;
  bool  _hanyaBelumSelesai = false;

  // Daftar yang ditampilkan di UI sesuai status filter
  List<Tugas> get daftar => _repo.daftar;
  String? get galat => _galat;
  bool get hanyaBelumSelesai => _hanyaBelumSelesai;

  List<Tugas> get daftarTampil {
    if (_hanyaBelumSelesai) {
      return _repo.daftar.where((tugas) => !tugas.selesai).toList();
    }
    return _repo.daftar;
  }
  
  // Total Seluruh tugas untuk teks ringkasan
  int get totalTugas => _repo.daftar.length;
  
  // dihitung dari seluruh tugas (_repo.daftra), bkn dari daftarTampil
  int get jumlahSelesai => _repo.daftar.where((tugas) => tugas.selesai).length;
  
  bool tambah (String input) {
    _galat = validasiJudul(input);
    if (_galat !=null) return false;
    _repo.tambah(input.trim());
    return true;
  }
  void ubahStatus(int id) => _repo.ubahStatus(id);

  // Mengubah status filter saat filterchip diketuk
  void ubahFilter(bool nilai) {
    _hanyaBelumSelesai = nilai;
  }
}