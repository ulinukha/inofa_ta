
class BaseUrl {
  //User
  static String signUp = "http://10.0.2.2:8000/api/signUp";  //post
  static String dataUser = "http://10.0.2.2:8000/api/login/"; //get

  //List Pengguna
  static String listPengguna = "http://10.0.2.2:8000/api/pengguna"; //get

  //data spesific
  static String noTelp = "http://10.0.2.2:8000/api/noTelp/"; //post
  static String setLocation = "http://10.0.2.2:8000/api/setLocation/";  //post
  static String getLocation = "http://10.0.2.2:8000/api/getLocation/";  //get

  //inovasi
  static String getInovasi = "http://10.0.2.2:8000/api/inovasi"; //get
  static String createInovasi = "http://10.0.2.2:8000/api/createInovasi"; //post
  static String deleteInovasi = "http://10.0.2.2:8000/api/deleteInovasi/"; //delete + id_inofasi
  static String updateInovasi = "http://10.0.2.2:8000/api/updateInovasi/"; //post + id_inofasi

  //chat
  static String postChat = "http://10.0.2.2:8000/api/send"; //post
  static String deleteChat = "http://10.0.2.2:8000/api/chat/";  //delete + id_chat

  //list option
  static String listSkill = "http://10.0.2.2:8000/api/kemampuan"; //get
  static String listKategori = "http://10.0.2.2:8000/api/kategori"; //get
  static String listPendidikan = "http://10.0.2.2:8000/api/pendidikan"; //get
}

