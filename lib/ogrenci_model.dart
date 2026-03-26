class Ogrenci {
  final int? id;
  final String ad;
  final String soyad;
  final int numara;

  Ogrenci({this.id, required this.ad, required this.soyad, required this.numara});

  factory Ogrenci.fromJson(Map<String, dynamic> json) => Ogrenci(
    id: json['id'],
    ad: json['ad'],
    soyad: json['soyad'],
    numara: json['numara'],
  );

  Map<String, dynamic> toJson() => {
    "ad": ad,
    "soyad": soyad,
    "numara": numara,
  };
}