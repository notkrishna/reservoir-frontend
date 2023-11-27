
class Movie {
  final String id;
  // final String imgUrl;
  final String movieName;
  final String description;
  // final int year;
  // final String movieRating;
  final int duration;
  // final bool isShow;
  final String coverImgUrl;
  final double avg_rating;
  final int rating_count;
  final bool saved;
  final bool progress;
  final bool following;
  final bool userHasCover;
  // final bool isReviewed;
  
  const Movie({
    required this.id,
    // required this.imgUrl,
    required this.movieName, 
    required this.description, 
    // required this.year,
    // required this.movieRating,
    required this.duration,
    // required this.isShow,
    required this.coverImgUrl,
    required this.saved,
    required this.progress,
    required this.following,
    this.avg_rating = 0,
    this.rating_count = 0,
    required this.userHasCover,
    // required this.isReviewed,
  });
  
  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    id: json['id'],
    // imgUrl: json['imgUrl'],
    movieName: json['movie_name'],
    description: json['description'],
    // year: json['year'],
    duration: json['duration'] as int? ?? 0,
    // movieRating: json['movieRating'],
    // isShow: json['isShow'],
    coverImgUrl: json['coverImgUrl'] as String? ?? "https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=",
    avg_rating: json['avg_rating'],
    rating_count: json['rating_count'],
    saved: json['saved'],
    progress: json['progress'],
    following: json['following'],
    userHasCover:json['userHasCover'],
    // isReviewed: json['is_reviewed'],
  );
}

class MovieCardModel {
  final String id;
  // final String imgUrl;
  final String movieName;
  // final String description;
  // final int year;
  // // final String movieRating;
  // final int duration;
  // final bool isShow;
  final String coverImgUrl;

  const MovieCardModel({
    required this.id,
    // required this.imgUrl,
    required this.movieName, 
    // required this.description, 
    // required this.year,
    // // required this.movieRating,
    //  required this.duration,
    // required this.isShow,
    required this.coverImgUrl

  });
  
  factory MovieCardModel.fromJson(Map<String, dynamic> json) => MovieCardModel(
    id: json['id'],
    // imgUrl: json['imgUrl'] as String? ?? '',
    movieName: json['movie_name'] as String? ?? '',
    // description: json['description'] ?? '',
    // year: json['year'],
    // duration: json['duration'],
    // // movieRating: json['movieRating'],
    // isShow: json['isShow'],
    coverImgUrl: json['coverImgUrl'] as String? ?? ''
  );
}

class SavedMovies {
  final String movie_name;
  final String user;
  final String movie_title;
  final String coverImgUrl;

  SavedMovies({
    required this.movie_name, 
    required this.user,
    required this.movie_title,
    required this.coverImgUrl,
    });

  factory SavedMovies.fromJson(Map<String,dynamic> json){
    return SavedMovies(
      movie_name: json['movie_name'],
      user:json['user'],
      movie_title: json['movie_title'],
      coverImgUrl: json['coverImgUrl']
    );
  }
}

class ProgressMovies {
  final String id;
  final String movie;
  final String user;
  final String movieName;
  // final String usertag;
  final int lastStamp;
  final String coverImgUrl;
  final int duration;
  final bool isDone;

  ProgressMovies({
    required this.id,
    required this.movie, 
    required this.user,
    required this.movieName,
    // required this.usertag,
    required this.lastStamp,
    required this.coverImgUrl,
    required this.duration,    
    required this.isDone,
    });

  factory ProgressMovies.fromJson(Map<String,dynamic> json){
    return ProgressMovies(
      id: json['id'],
      movie: json['movie'],
      user:json['user'],
      movieName: json['movie_name'],
      // usertag: json['usertag'],
      lastStamp: json['last_stamp'] as int? ?? -1,
      coverImgUrl: json['coverImgUrl'],
      duration: json['duration'],
      isDone: json['isDone'], 
    );
  }
}

class MovieList {
  final String id;
  final List<dynamic> firstMovie;
  final String user;
  final String listName;
  final String createdAt;
  bool isInMovie;
  // final int firstMovie;

  MovieList({required this.id, required this.firstMovie, required this.user, required this.listName, required this.createdAt, required this.isInMovie});

  factory MovieList.fromJson(Map<String,dynamic> json){
    return MovieList(
      id: json['id'],
      firstMovie: json['first_movie'] as List<dynamic>? ?? [],
      user:json['user'] as String? ?? '',
      listName: json['list_name'],
      createdAt: json['created_at'] as String? ?? '',
      isInMovie: json['is_in_movie'] as bool? ?? false,
      // firstMovie: json['first_movie'] as int? ?? 0,
    );
  }
}

class MovieListContent {
  final String id;
  final String coverPageUrl;
  final String movieName;

  MovieListContent({
    required this.id,
    required this.coverPageUrl,
    required this.movieName
    });

  factory MovieListContent.fromJson(Map<String,dynamic> json){
    return MovieListContent(
      id: json['id'],
      coverPageUrl: json['coverImgUrl'],
      movieName: json['movie_name']
    );
  }
}