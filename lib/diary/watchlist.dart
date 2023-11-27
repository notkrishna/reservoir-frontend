import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/api/movieAPI.dart';
import 'package:fluttert/models/movieModel.dart';
import 'package:fluttert/pages/movie/movieCard.dart';
import 'package:fluttert/tools/heading.dart';
import 'package:fluttert/tools/loading.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchSavedMovies(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<SavedMovies> items = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal:5.0),
              //   child: HeadingWidget(heading: 'Watchlist'),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:5.0, vertical: 5),
                child: Text('List of movies you want to watch.', style: TextStyle(color: Colors.grey),),
              ),
              SizedBox(height: 5,),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    SavedMovies item = items[index];
                    return MovieCard(
                      id: item.movie_name, 
                      height: 200,
                      movieName: item.movie_title,
                      coverImgUrl: item.coverImgUrl,
                    );
                  }
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('error');
        } 
        return Loading(x: 0.01, y: 0.5);
      },
    );
  }
}