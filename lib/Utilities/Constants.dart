import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipy/Entities/Article.dart';
import 'package:recipy/Entities/Recipe.dart';

class Constants {
  static const int timeoutTime = 10;
  static const String apiRoot = "https://recipython.herokuapp.com";
  static const String loginAPI =  "$apiRoot/login";
  static const String userAPI =  "$apiRoot/user";
  static const String myDataAPI =  "$apiRoot/me";
  static const String articleAPI = "$apiRoot/article";
  static const String getArticlesAPI = "$apiRoot/articles";
  static TextStyle textStyle({TextStyle? textStyle}){
    return GoogleFonts.ptSans(textStyle: textStyle);
  }

  List<Article> articles =
  [
    Article(id: 1, author_id: 1, author: "Banan69", category: "Obiady", title: "Testowy artykuł2", date: "2022-02-02", recipe: Recipe(rating: 5.0, content: 'Content przepisu tralalal buraki', title: 'Testowy przepis', user_id: 1, id: 1),
      content: "[{\"insert\":\"Lorem ipsum dolor sit amet\",\"attributes\":{\"bold\":true,\"underline\":true}},"
          "{\"insert\":\"\\n\",\"attributes\":{\"header\":1,\"indent\":22}},{\"insert\":\"Consectetur adipiscing elit. "
          "Pellentesque congue odio vitae aliquet elementum. Nullam posuere nibh sapien, in suscipit lorem pellentesque at. Aliquam scelerisque nisi ex,"
          " efficitur tempus mauris fermentum sed. Nulla facilisi. Praesent urna tortor, fermentum id dolor in, cursus gravida urna. Maecenas in pretium massa."
          " Donec in malesuada ligula. Donec faucibus libero ac arcu ultricies pulvinar. Nunc lobortis, odio sed consequat vulputate, velit tellus elementum justo,"
          " a varius velit est a sem. Sed nec scelerisque massa. In volutpat sollicitudin nibh. Proin pharetra\",\"attributes\":{\"color\":\"#004d40\"}},{\"insert\":\""
          " congue tempus. Curabitur facilisis eli\",\"attributes\":{\"color\":\"#004d40\",\"background\":\"#f44336\",\"strike\":true}},{\"insert\":\"t vel hendrerit "
          "elementum. Praesent ultrices consequat luctus. Etiam mattis est nec enim facilisis ornare. Cras elementum, neque quis commodo condimentum, lacus erat bibendum "
          "massa, ac viverra ante sapien nec lorem.\",\"attributes\":{\"color\":\"#004d40\"}},{\"insert\":\"\\n\"}]", rating: 3.40),
    Article(id: 2, author_id: 2, author: "Jabłko1998", category: "Obiady", title: "Artykuł5", date: "2022-01-15", recipe: Recipe(rating: 4.5, content: 'Przepisu tralalal buraki', title: 'BURAKI SMAŻONE NA TWARDO Z DODATKIEM JĘCZMIENIA I TRUSKAWEK', user_id: 2, id: 2),
        content: "[{\"insert\":\"Lorem ipsum dolor sit amet\",\"attributes\":{\"bold\":true,\"underline\":true}},"
            "{\"insert\":\"\\n\",\"attributes\":{\"header\":1,\"indent\":22}},{\"insert\":\"Consectetur adipiscing elit. "
            "Pellentesque congue odio vitae aliquet elementum. Nullam posuere nibh sapien, in suscipit lorem pellentesque at. Aliquam scelerisque nisi ex,"
            " efficitur tempus mauris fermentum sed. Nulla facilisi. Praesent urna tortor, fermentum id dolor in, cursus gravida urna. Maecenas in pretium massa."
            " Donec in malesuada ligula. Donec faucibus libero ac arcu ultricies pulvinar. Nunc lobortis, odio sed consequat vulputate, velit tellus elementum justo,"
            " a varius velit est a sem. Sed nec scelerisque massa. In volutpat sollicitudin nibh. Proin pharetra\",\"attributes\":{\"color\":\"#004d40\"}},{\"insert\":\""
            " congue tempus. Curabitur facilisis eli\",\"attributes\":{\"color\":\"#004d40\",\"background\":\"#f44336\",\"strike\":true}},{\"insert\":\"t vel hendrerit "
            "elementum. Praesent ultrices consequat luctus. Etiam mattis est nec enim facilisis ornare. Cras elementum, neque quis commodo condimentum, lacus erat bibendum "
            "massa, ac viverra ante sapien nec lorem.\",\"attributes\":{\"color\":\"#004d40\"}},{\"insert\":\"\\n\"}]", rating: 4.5),
  ];

}