class SqliteSchema {
  final String tableName;
  final Map<String, String> fields;

  SqliteSchema({required this.tableName, required this.fields});

  // SQL 타입을 자동으로 생성하는 메서드
  String generateCreateTableSQL() {
    final fieldsSQL =
        fields.entries.map((entry) => '${entry.key} ${entry.value}').join(', ');

    return '''
    CREATE TABLE IF NOT EXISTS $tableName (
      $fieldsSQL
    )
    ''';
  }
}
