class ListSkill{
  final int id_kemampuan;
  final String kemampuan;

  ListSkill({
    this.id_kemampuan, 
    this.kemampuan
  });

  factory ListSkill.fromJson(Map<String, dynamic> json) {
    return new ListSkill(
      id_kemampuan: json['id_kemampuan'],
      kemampuan: json['kemampuan'],
    );
  }
}