class MSiswa {
  int? id;
  String? nis;
  String? nama;
  String? tplahir;
  String? tglahir;
  String? kelamin;
  String? agama;
  String? alamat;

  MSiswa({
    this.id,
    this.nis,
    this.nama,
    this.tplahir,
    this.tglahir,
    this.kelamin,
    this.agama,
    this.alamat,
  });

  factory MSiswa.fromJson(Map<String, dynamic> json) {
    return MSiswa(
      id: int.parse(json['id'].toString()),
      nis: json['nis'],
      nama: json['nama'],
      tplahir: json['tplahir'],
      tglahir: json['tglahir'],
      kelamin: json['kelamin'],
      agama: json['agama'],
      alamat: json['alamat'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nis': nis,
        'nama': nama,
        'tplahir': tplahir,
        'tglahir': tglahir,
        'kelamin': kelamin,
        'agama': agama,
        'alamat': alamat,
      };
}
