class WallpaperModel {
  late dynamic id;

  late String link;

  WallpaperModel({
    required this.id,
    required this.link,
  });

  factory WallpaperModel.fromMap(Map<String, dynamic> jsonData) {
    return WallpaperModel(
      id: jsonData['id'],
      link: jsonData['link'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'link': link,
    };
  }

  @override
  String toString() {
    return '{id: $id, link: $link}';
  }
}
