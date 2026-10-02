class Api {
  static const String baseUrl = 'http://192.168.137.1/biodata';

  static String list() => '$baseUrl/list.php';
  static String create() => '$baseUrl/create.php';
  static String update() => '$baseUrl/update.php';
  static String delete() => '$baseUrl/delete.php';
}
