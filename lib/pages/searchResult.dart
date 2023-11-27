import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttert/models/movieModel.dart';
import 'package:fluttert/models/searchModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/movie/movieCard.dart';
import 'package:fluttert/pages/movie/movieCardMini.dart';
import 'package:fluttert/pages/movie/moviePage.dart';
import 'package:fluttert/providers/searchProvider.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>{
  final fieldText = TextEditingController();
  int _hintIndex = 0;
  List<String> _hintList = ['movies','shows','genres'];
  void clearText(){
    fieldText.clear();
    fieldText.dispose();
    super.dispose();
  }

  final _scrollController = ScrollController();

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final provider = Provider.of<SearchProvider>(context,listen:false);
  //   // provider.fetchPosts(context);
  //   _scrollController.addListener(() {
  //     if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
  //       provider.fetchPosts(context);
  //       }
  //     });
  //   }

  // Future<List<MovieCardModel>> fetchSearchResult(String ftext) async{
  //     String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //     final response = await http.get(
  //       Uri.parse('${Globals().url}movieSearch/?search=$ftext'),
  //       headers: {
  //           HttpHeaders.authorizationHeader: 'Bearer ${id_token}',
  //       },
  //     );
  //     if (response.statusCode == 200){
  //       final List result = json.decode(response.body);
  //       return result.map((e) => MovieCardModel.fromJson(e)).toList();
  //     } else {
  //       throw Exception(response.body);
  //     }
  // }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SearchProvider>(context,listen:false);

    return Scaffold(
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification){
            if (notification is ScrollEndNotification && notification.metrics.extentAfter == 0){
              provider.fetchPosts(context, fieldText.text, false);
            }
            return false;
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:10.0, vertical: 15),
            child: Column(
              children: [
                TextField(
                  // autofocus: true,
                  onSubmitted: (value) {
                      provider.fetchPosts(context,fieldText.text, true);
                  },
                  style: TextStyle(
                    //color: Colors.white,
                    fontFamily: 'Outfit',
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    //fillColor: Color.fromARGB(255, 35, 35, 35),
                    border: InputBorder.none,
                    // prefixIcon: Icon(
                    //   Icons.search,
                    //   color: Colors.grey,
                    //   ),
                    // suffixIcon: IconButton(
                    //   onPressed: clearText,
                    //   icon: const Icon(Icons.close),
                    //   color: Color.fromARGB(255, 112, 112, 112),
                    //   ),
                    filled: true,
                    //fillColor: Color.fromARGB(255, 25, 25, 25),
                    hintStyle: TextStyle(
                      color: Colors.grey, 
                      fontFamily: 'Outfit', 
                      fontSize: 25
                      ),
                    hintText: 'Search movies, lists',
                ),
                controller: fieldText,
                ),
                SizedBox(height: 2,),
                Expanded(
                  child: Consumer<SearchProvider>(
                   builder: (context, provider, _) {
                      if(provider.results.isEmpty){
                        return SizedBox.shrink();
                      } else {
                        return ListView.builder(
                                controller: _scrollController,
                                itemCount: provider.results.length+1,
                                padding: EdgeInsets.only(bottom: 10),
                                itemBuilder: (context, index) {
                                  if (index<provider.results.length){
                                    SearchModel item = provider.results[index];
                                    return ListTile(
                                      leading: item.coverImgUrl==""?SizedBox.shrink():
                                      Image.network(
                                        item.coverImgUrl,
                                        height: 60,
                                        width: 40,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (BuildContext context, Object exception, StackTrace? stackTrace) {
                                          // Appropriate logging or analytics, e.g.
                                          // myAnalytics.recordError(
                                          //   'An error occurred loading "https://example.does.not.exist/image.jpg"',
                                          //   exception,
                                          //   stackTrace,
                                          // );
                                          return const SizedBox.shrink();
                                        },
                                      ),
                                      title: Text(
                                        item.movieName,
                                        style: TextStyle(
                                          fontFamily: 'Lexend',
                                          fontSize: 26,
                                          fontWeight: FontWeight.w300
                                        ),
                                        ),
                                      subtitle: Text(item.description),
                                      trailing: Icon(Icons.arrow_forward_ios, size: 10,),
                                      onTap: () {
                                        Navigator.push(
                                          context, 
                                          MaterialPageRoute(
                                            builder: (context) => MoviePage(id: item.movieId)
                                          )
                                        );
                                      },
                                    );
                                    // MovieCard(
                                    //       movieName: item.movieName,
                                    //       id: item.movieId,
                                    //       coverImgUrl: "",
                                    //       height: 50,
                                    //     );
                                    } else {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(vertical: 10),
                                        child: provider.nextPageUrl =='null'?
                                              SizedBox(height: 0,):Loading(),
                                      );
                                    }
                                },
                              );}
                    }
                  ),
                  // child: 
                  //        Consumer<SearchProvider>(
                  //          builder: (context,pvdr,_) {
                  //            return ListView.builder(
                  //             itemCount: pvdr.results.length,
                  //             itemBuilder: (context,index) {
                  //               return ListTile(
                  //                 title: Text(pvdr.results[index].movieName),
                  //                 onTap: (){
                  //                   Navigator.push(
                  //                   context, 
                  //                   MaterialPageRoute(
                  //                     builder: (context) => MoviePage(id: pvdr.results[index].movieId)
                  //                     )
                  //                   );
                  //                 }
                  //               );
                  //               // return MovieCard(id: dt[index].id, height: 200,); 
                                
                  //             },
                  //       );
                  //          }
                  //        );
                      
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}