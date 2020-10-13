class DocumentListModel {
  final List<Folder> items;

  DocumentListModel({this.items});

  factory DocumentListModel.fromJson(List<dynamic> json) {
    return DocumentListModel(items: List<Folder>.from(json.map((each) {
      return Folder.fromJson(each);
    })));
  }
}

class Folder {
  final String name;
  final String date;
  final List<Document> documents;

  Folder({this.name, this.documents, this.date});

  factory Folder.fromJson(Map<String, dynamic> json) {
    List<dynamic> documents = json['documents'];

    return Folder(
        name: json['folder_name'],
        date: json['date'],
        documents: List<Document>.from(documents.map((each) {
          return Document.fromJson(each);
        })));
  }
}

class Document {
  final String name;
  final String url;
  final String date;
  final String thumbnailURL;

  Document({this.name, this.url, this.date, this.thumbnailURL});

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
        name: json['name'],
        url: json['url'],
        date: json['date'],
        thumbnailURL: json['thumbnail_url']);
  }
}
