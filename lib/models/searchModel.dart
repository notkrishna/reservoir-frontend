class SearchModel {
  final String movieName;
  final String description;
  final String movieId;
  final String coverImgUrl;

  SearchModel({
    required this.movieName,
    required this.description,
    required this.movieId,
    required this.coverImgUrl,
  });
  factory SearchModel.fromJson(Map<String,dynamic> json) {
    return SearchModel(
      movieName: json['movie_name'], 
      movieId: json['id'], 
      description: json['description'],
      coverImgUrl: json['coverImgUrl'] as String? ?? "",
    );
  }
}