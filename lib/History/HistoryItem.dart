class HistoryItem {
  final int? id;
  final String originalText;
  final String translatedText;
  final String fromLanguage;
  final String toLanguage;
  final String? fromFlag;
  final String? toFlag;

  HistoryItem({
    this.id,
    required this.originalText,
    required this.translatedText,
    required this.fromLanguage,
    required this.toLanguage,
    this.fromFlag,
    this.toFlag,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'originalText': originalText,
      'translatedText': translatedText,
      'fromLanguage': fromLanguage,
      'toLanguage': toLanguage,
      'fromFlag': fromFlag,
      'toFlag': toFlag,
    };
  }
}
