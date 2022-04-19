class BookModel {
  String? kind;

  List<Items>? items;

  BookModel.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];

    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }
}

class Items {
  String? selfLink;
  VolumeInfo? volumeInfo;
  SaleInfo? saleInfo;
  SearchInfo? searchInfo;

  Items.fromJson(Map<String, dynamic> json) {
    selfLink = json['selfLink'];
    volumeInfo = json['volumeInfo'] != null
        ? VolumeInfo.fromJson(json['volumeInfo'])
        : null;
    saleInfo =
        json['saleInfo'] != null ? SaleInfo.fromJson(json['saleInfo']) : null;

    searchInfo = json['searchInfo'] != null
        ? SearchInfo.fromJson(json['searchInfo'])
        : null;
  }
}

class VolumeInfo {
  String? title;
  String? subtitle;
  List<dynamic>? authors;
  String? publisher;

  String? publishedDate;
  String? description;

  int? pageCount;
  List<dynamic>? categories;
  dynamic averageRating;
  dynamic ratingsCount;

  ImageLinks? imageLinks;
  String? language;
  String? previewLink;
  String? infoLink;

  VolumeInfo.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle = json['subtitle'];
    authors = json['authors'];
    publisher = json['publisher'];
    publishedDate = json['publishedDate'];
    description = json['description'];

    pageCount = json['pageCount'];

    categories = json['categories'];
    averageRating = json['averageRating'];
    ratingsCount = json['ratingsCount'];

    imageLinks = json['imageLinks'] != null
        ? ImageLinks.fromJson(json['imageLinks'])
        : null;
    language = json['language'];
    previewLink = json['previewLink'];
    infoLink = json['infoLink'];
  }
}

class ImageLinks {
  String? smallThumbnail;
  String? thumbnail;

  ImageLinks({this.smallThumbnail, this.thumbnail});

  ImageLinks.fromJson(Map<String, dynamic> json) {
    smallThumbnail = json['smallThumbnail'];
    thumbnail = json['thumbnail'];
  }
}

class SearchInfo {
  String? textSnippet;

  SearchInfo.fromJson(Map<String, dynamic> json) {
    textSnippet = json['textSnippet'];
  }
}

class SaleInfo {
  String? country;
  ListPrice? listPrice;
  ListPrice? retailPrice;
  String? buyLink;

  SaleInfo.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    listPrice = json['listPrice'] != null
        ? ListPrice.fromJson(json['listPrice'])
        : null;
    retailPrice = json['retailPrice'] != null
        ? ListPrice.fromJson(json['retailPrice'])
        : null;
    buyLink = json['buyLink'];
  }
}

class ListPrice {
  dynamic amount;
  String? currencyCode;

  ListPrice({this.amount, this.currencyCode});

  ListPrice.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    currencyCode = json['currencyCode'];
  }
}
