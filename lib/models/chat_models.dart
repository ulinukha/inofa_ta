class ListChat{
  int id_chat;
  int pengguna_id;
  int inovasi_id;
  String profile_picture;
  String content;
  String display_name;
  String media;

  ListChat({
    this.id_chat,
    this.pengguna_id,
    this.inovasi_id,
    this.profile_picture,
    this.content,
    this.display_name,
    this.media
  });

  factory ListChat.fromJson(Map<String, dynamic> json){
    return new ListChat(
      id_chat : json['id_chat'],
      pengguna_id : json['pengguna_id'],
      inovasi_id : json['inovasi_id'],
      profile_picture : json['profile_picture'],
      content: json['content'],
      display_name: json['display_name'],
      media: json['media']
    );
  }
}