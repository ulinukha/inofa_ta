
class BaseUrl {
  //User
  static String signUp = "http://192.168.20.102:8000/api/signUp";  //post
  static String dataUser = "http://192.168.20.102:8000/api/login/"; //get
  static String updateUser = "http://192.168.20.102:8000/api/pengguna/"; //post
  

  //List Pengguna
  static String listPengguna = "http://192.168.20.102:8000/api/pengguna"; //get

  //data spesific
  static String noTelp = "http://192.168.20.102:8000/api/noTelp/"; //post
  static String setLocation = "http://192.168.20.102:8000/api/setLocation/";  //post
  static String getLocation = "http://192.168.20.102:8000/api/getLocation/";  //get
  static String getKemampuan = "http://192.168.20.102:8000/api/kemampuan/";  //get

  //inovasi
  static String getInovasi = "http://192.168.20.102:8000/api/inovasi"; //get
  static String getInovasiBySkill = "http://192.168.20.102:8000/api/inovasiByKemampuan/"; //get
  static String getInovasiInJoin = "http://192.168.20.102:8000/api/subscription/"; //get
  static String getInovasiInCreate = "http://192.168.20.102:8000/api/dibuat/";
  static String createInovasi = "http://192.168.20.102:8000/api/createInovasi"; //post
  static String deleteInovasi = "http://192.168.20.102:8000/api/deleteInovasi/"; //delete + id_inofasi
  static String updateInovasi = "http://192.168.20.102:8000/api/updateInovasi/"; //post + id_inofasi
  static String addKemampuanInovasi = "http://192.168.20.102:8000/api/addKemampuan/"; //post

  //Request
  static String listMember = "http://192.168.20.102:8000/api/member/"; //get
  static String inviteUserApi = "http://192.168.20.102:8000/api/invite/"; //post
  static String joinInovasiApi = "http://192.168.20.102:8000/api/join/"; //post
  static String grandJoinApi = "http://192.168.20.102:8000/api/grantJoin/"; //post
  static String acceptApi = "http://192.168.20.102:8000/api/accept/";
  static String listInvitedInovasi = "http://192.168.20.102:8000/api/invited/"; //get
  static String listRequestJoin = "http://192.168.20.102:8000/api/requestMember/";

  //chat
  static String getChat = "http://192.168.20.102:8000/api/allChat/"; //get
  static String postChat = "http://192.168.20.102:8000/api/send"; //post
  static String deleteChat = "http://192.168.20.102:8000/api/chat/";  //delete + id_chat

  //list option
  static String listSkill = "http://192.168.20.102:8000/api/kemampuan"; //get
  static String listKategori = "http://192.168.20.102:8000/api/kategori"; //get
  static String listPendidikan = "http://192.168.20.102:8000/api/pendidikan"; //get
  static String wilayahApi = "http://192.168.20.102:8000/api/allWilayah"; //get
}

