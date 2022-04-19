class AddHeighLight {
  String? text;
  String? bookname;
  String? bookimage;
  String? date;
  String? bookauthor;

  AddHeighLight(
      {this.text, this.bookname, this.bookimage, this.bookauthor, this.date});

  AddHeighLight.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    bookname = json['bookname'];
    bookimage = json['bookimage'];
    date = json['date'];

    bookauthor = json['bookauthor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['bookname'] = bookname;
    data['date'] = date;
    data['bookimage'] = bookimage;

    data['bookauthor'] = bookauthor;
    return data;
  }
}
