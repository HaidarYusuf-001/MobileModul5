// To parse this JSON data, do
//
//     final buku = bukuFromJson(jsonString);

import 'dart:convert';

Buku bukuFromJson(String str) => Buku.fromJson(json.decode(str));

String bukuToJson(Buku data) => json.encode(data.toJson());

class Buku {
  String status;
  String copyright;
  int numResults;
  List<Result> results;

  Buku({
    required this.status,
    required this.copyright,
    required this.numResults,
    required this.results,
  });

  factory Buku.fromJson(Map<String, dynamic> json) => Buku(
        status: json["status"],
        copyright: json["copyright"],
        numResults: json["num_results"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "copyright": copyright,
        "num_results": numResults,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  String title;
  String? description;
  String? contributor;
  String author;
  String? contributorNote;
  String price;
  String? ageGroup;
  String? publisher;
  List<Isbn> isbns;
  List<RanksHistory> ranksHistory;
  List<Review> reviews;

  Result({
    required this.title,
    required this.description,
    required this.contributor,
    required this.author,
    required this.contributorNote,
    required this.price,
    required this.ageGroup,
    required this.publisher,
    required this.isbns,
    required this.ranksHistory,
    required this.reviews,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        title: json["title"],
        description: json["description"],
        contributor: json["contributor"],
        author: json["author"],
        contributorNote: json["contributor_note"],
        price: json["price"],
        ageGroup: json["age_group"],
        publisher: json["publisher"],
        isbns: List<Isbn>.from(json["isbns"].map((x) => Isbn.fromJson(x))),
        ranksHistory: List<RanksHistory>.from(
            json["ranks_history"].map((x) => RanksHistory.fromJson(x))),
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "contributor": contributor,
        "author": author,
        "contributor_note": contributorNote,
        "price": price,
        "age_group": ageGroup,
        "publisher": publisher,
        "isbns": List<dynamic>.from(isbns.map((x) => x.toJson())),
        "ranks_history":
            List<dynamic>.from(ranksHistory.map((x) => x.toJson())),
        "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
      };
}

class Isbn {
  String isbn10;
  String isbn13;

  Isbn({
    required this.isbn10,
    required this.isbn13,
  });

  factory Isbn.fromJson(Map<String, dynamic> json) => Isbn(
        isbn10: json["isbn10"],
        isbn13: json["isbn13"],
      );

  Map<String, dynamic> toJson() => {
        "isbn10": isbn10,
        "isbn13": isbn13,
      };
}

class RanksHistory {
  String primaryIsbn10;
  String primaryIsbn13;
  int rank;
  String listName;
  String displayName;
  DateTime publishedDate;
  DateTime bestsellersDate;
  int weeksOnList;
  int rankLastWeek;
  int asterisk;
  int dagger;

  RanksHistory({
    required this.primaryIsbn10,
    required this.primaryIsbn13,
    required this.rank,
    required this.listName,
    required this.displayName,
    required this.publishedDate,
    required this.bestsellersDate,
    required this.weeksOnList,
    required this.rankLastWeek,
    required this.asterisk,
    required this.dagger,
  });

  factory RanksHistory.fromJson(Map<String, dynamic> json) => RanksHistory(
        primaryIsbn10: json["primary_isbn10"],
        primaryIsbn13: json["primary_isbn13"],
        rank: json["rank"],
        listName: json["list_name"],
        displayName: json["display_name"],
        publishedDate: DateTime.parse(json["published_date"]),
        bestsellersDate: DateTime.parse(json["bestsellers_date"]),
        weeksOnList: json["weeks_on_list"],
        rankLastWeek: json["rank_last_week"],
        asterisk: json["asterisk"],
        dagger: json["dagger"],
      );

  Map<String, dynamic> toJson() => {
        "primary_isbn10": primaryIsbn10,
        "primary_isbn13": primaryIsbn13,
        "rank": rank,
        "list_name": listName,
        "display_name": displayName,
        "published_date":
            "${publishedDate.year.toString().padLeft(4, '0')}-${publishedDate.month.toString().padLeft(2, '0')}-${publishedDate.day.toString().padLeft(2, '0')}",
        "bestsellers_date":
            "${bestsellersDate.year.toString().padLeft(4, '0')}-${bestsellersDate.month.toString().padLeft(2, '0')}-${bestsellersDate.day.toString().padLeft(2, '0')}",
        "weeks_on_list": weeksOnList,
        "rank_last_week": rankLastWeek,
        "asterisk": asterisk,
        "dagger": dagger,
      };
}

class Review {
  String bookReviewLink;
  String? firstChapterLink;
  String sundayReviewLink;
  String? articleChapterLink;

  Review({
    required this.bookReviewLink,
    required this.firstChapterLink,
    required this.sundayReviewLink,
    required this.articleChapterLink,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        bookReviewLink: json["book_review_link"],
        firstChapterLink: json["first_chapter_link"],
        sundayReviewLink: json["sunday_review_link"],
        articleChapterLink: json["article_chapter_link"],
      );

  Map<String, dynamic> toJson() => {
        "book_review_link": bookReviewLink,
        "first_chapter_link": firstChapterLink,
        "sunday_review_link": sundayReviewLink,
        "article_chapter_link": articleChapterLink,
      };
}
