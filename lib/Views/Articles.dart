import 'dart:async';
import 'dart:convert';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:recipy/CustomWidgets/ArticlesList.dart';
import 'package:recipy/CustomWidgets/CustomTextbox.dart';
import 'package:recipy/CustomWidgets/NavigationButtons.dart';
import 'package:recipy/CustomWidgets/Waves.dart';
import 'package:recipy/CustomWidgets/rNavBar.dart';
import 'package:recipy/Entities/Article.dart';
import 'package:recipy/Utilities/Constants.dart';
import 'package:recipy/Utilities/CustomRoute.dart';
import 'package:recipy/Utilities/CustomTheme.dart';
import 'package:recipy/Utilities/Requests.dart';
import 'package:recipy/Utilities/Utilities.dart';
import 'package:recipy/Views/AddArticle.dart';

class Articles extends StatefulWidget {
  final bool myArticles;
  const Articles({this.myArticles = false, Key? key}) : super(key: key);

  @override
  _ArticlesState createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  StreamController<bool> articlesStreamController = StreamController<bool>();
  StreamController<bool> categoriesStreamController = StreamController<bool>();
  bool isSearchButtonDisabled = false;
  List<Article> articles = [];
  List<String> categories = ["Brak"];
  String? sortBy = "newest";
  String? category;
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  String? search_title;
  String? search_author;
  int? numberOfPages;
  int currentPage = 1;
  final _searchFormKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();

  Future<void> getCategories() async {
    String response = await Requests.getCategories();
    for (Map<String, dynamic> category in jsonDecode(response)["data"]) {
      categories.add(category["name"]);
    }
    categoriesStreamController.add(true);
  }
  Future<void> getArticles(int currentPage) async {
    articles.clear();
    articlesStreamController.add(false);
    //print("Sort by: $sortBy, Category: ${category ?? "None"}, Search title: ${search_title == null || search_title!.isEmpty ? "None" : search_title}, Search author: ${search_author == null || search_author!.isEmpty ? "None" : search_author}");
    String response = !widget.myArticles ? await Requests.getArticles(
        sort: sortBy,
        category: category == "Brak" ? null : category,
        filter: "search",
        start: ((currentPage - 1) * 12),
        amount: 12,
        search_title: search_title,
        search_author: search_author

    ) : await Requests.getArticles(
        filter: "my",
        start: ((currentPage - 1) * 12),
        amount: 12,
        sort: "newest"
    );
    dynamic decodedString = jsonDecode(response);
    for (Map<String, dynamic> article in decodedString["data"]) {
      Article parsedArticle = Article.fromGeneric(article);
      articles.add(parsedArticle);
    }
    setState(() {
      numberOfPages = decodedString["length"];
      this.currentPage = currentPage;
      isSearchButtonDisabled = false;
    });
    articlesStreamController.add(true);
  }

  Future<void> deleteArticle(Article article) async {
    articlesStreamController.add(false);
    await Requests.deleteArticle(article.id);
    await getArticles(currentPage);
    articlesStreamController.add(true);
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      await getCategories();
      await getArticles(1);
    });
    super.initState();
  }

  @override
  void dispose() {
    articlesStreamController.close();
    categoriesStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SearchBars searchBars = SearchBars(_searchFormKey, categories, setState, titleController, authorController);
    final mediaSize = Utilities.getDimensions(context);
    return Scaffold(
      backgroundColor: CustomTheme.background,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: AdaptiveScrollbar(
                  underColor: CustomTheme.secondaryBackground,
                  underDecoration: BoxDecoration(
                      color: CustomTheme.secondaryBackground,
                      border: Border.all(
                          color: CustomTheme.iconSelectedFill,
                          width: 1
                      )
                  ),
                  sliderSpacing: EdgeInsets.zero,
                  sliderDefaultColor: CustomTheme.iconSelectedFill,
                  sliderActiveColor: CustomTheme.buttonPrimary,
                  controller: scrollController,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 110, 0, 0),
                          child: Column(
                            children: [
                              SizedBox(
                                  child: Text(widget.myArticles ? "Moje artykuły" : "Artykuły",
                                    style: Constants.textStyle(
                                        textStyle: TextStyle(
                                            fontSize: 60,
                                            fontWeight: FontWeight.bold,
                                            color: CustomTheme.text,
                                            height: 2
                                        )
                                    ),
                                  )
                              ),
                              Stack(
                                children: [
                                  SizedBox(
                                      height: 100,
                                      child: Waves(color1: CustomTheme.background, color2: CustomTheme.accent1,)
                                  ),
                                  Positioned(
                                    left: mediaSize.width * 0.18,
                                    bottom: 15,
                                    child: Image.asset('assets/images/tree.png', height: 65,),
                                  ),
                                  Positioned(
                                    left: mediaSize.width * 0.207,
                                    bottom: 15,
                                    child: Image.asset('assets/images/tree.png', height: 35,),
                                  ),
                                  Positioned(
                                    left: mediaSize.width * 0.227,
                                    bottom: 18,
                                    child: Image.asset('assets/images/tree.png', height: 45,),
                                  ),
                                  Positioned(
                                    right: mediaSize.width * 0.195,
                                    bottom: 0,
                                    child: Image.asset('assets/images/tree.png', height: 90,),
                                  ),
                                ],
                              ),
                              Waves(color1: CustomTheme.accent1, color2: CustomTheme.secondaryBackground,),
                              Container(
                                width: mediaSize.width,
                                height: 1100,
                                color: CustomTheme.secondaryBackground,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 32,),
                                    !widget.myArticles ? StreamBuilder(
                                      stream: categoriesStreamController.stream,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData){
                                          return const SizedBox(
                                            height: 80,
                                            width: 1000,
                                            child: Center(
                                              child: SpinKitFadingCircle(
                                                size: 50,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          );
                                        } else {
                                          titleController.text = search_title ?? "";
                                          authorController.text = search_author ?? "";
                                          return SizedBox(
                                            width: 932,
                                            height: 80,
                                            child: Form(
                                                key: _searchFormKey,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    searchBars._buildTitle(),
                                                    searchBars._buildAuthor(),
                                                    searchBars._buildCategories(),
                                                    searchBars._buildSorts(),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: isSearchButtonDisabled ? Colors.grey : CustomTheme.buttonPrimary,
                                                        border: Border.all(color: CustomTheme.textDark, width: 1)
                                                      ),
                                                      height: 42,
                                                      width: 42,
                                                      child: IconButton(
                                                        icon: const Icon(Icons.search, color: Colors.white),
                                                        onPressed: isSearchButtonDisabled ? null : () async {
                                                          if (_searchFormKey.currentState!.validate()) {

                                                            setState(() {
                                                              isSearchButtonDisabled = true;
                                                            });
                                                            _searchFormKey.currentState!.save();
                                                            setState(() {
                                                              sortBy = SearchBars._sortBy == "Najnowsze" ? "newest" : "oldest";
                                                              category = SearchBars._category;
                                                              search_title = SearchBars._search_title;
                                                              search_author = SearchBars._search_author;
                                                              getArticles(1);
                                                            });
                                                          }
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                )
                                            ),
                                          );
                                        }
                                      }
                                    ) : Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                                      child: SizedBox(
                                        width: 200,
                                        height: 45,
                                        child: TextButton(
                                          onPressed: () => Navigator.of(context).push(CustomRoute(AddArticle())),
                                          style: TextButton.styleFrom(
                                              backgroundColor: CustomTheme.buttonPrimary
                                          ),
                                          child: Center(
                                            child: Text(
                                                "Dodaj nowy artykuł",
                                                style: Constants.textStyle(
                                                    textStyle: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.white
                                                    )
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                    ) ,
                                    Container(
                                      height: mediaSize.width * 0.45,
                                      width: mediaSize.width * 0.55,
                                      color: CustomTheme.art1,
                                      child: Column(
                                        children: [
                                          SizedBox(height: 20,),
                                          StreamBuilder(
                                              stream: articlesStreamController.stream,
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return SizedBox(
                                                    height: mediaSize.width * 0.38,
                                                    width: mediaSize.width * 0.50,
                                                    child: const Center(
                                                      child: SpinKitFadingCircle(
                                                        size: 80,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  if (snapshot.data == false){
                                                    return SizedBox(
                                                      height: mediaSize.width * 0.38,
                                                      width: mediaSize.width * 0.50,
                                                      child: const Center(
                                                        child: SpinKitFadingCircle(
                                                          size: 80,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        NavigationButtons(currentPage: currentPage, listLength: numberOfPages!, amountPerPage: 12, getPage: getArticles),
                                                        SizedBox(height: 20,),
                                                        ArticlesList(mediaSize, articles, deleteArticle),
                                                        NavigationButtons(currentPage: currentPage, listLength: numberOfPages!, amountPerPage: 12, getPage: getArticles)
                                                      ],
                                                    );
                                                  }
                                                }
                                              }
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 60,
                                child: Card(
                                  color: CustomTheme.background,
                                  elevation: 20,
                                  margin: EdgeInsets.zero,
                                  child: Center(
                                    child: Text("© 2021. Reci.py. All Rights Reserved",
                                      style: Constants.textStyle(
                                          textStyle: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: CustomTheme.footerText
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              )
            ],
          ),
          rNavBar(),
        ],
      ),
    );
  }
}

class SearchBars {
  SearchBars(this.formKey, this.categories, this.setState, this.titleController, this.authorController);
  Function setState;
  GlobalKey<FormState> formKey;
  List<String> categories;
  static String? _sortBy = "Najnowsze";
  static String? _category = "Brak";
  static String? _search_title;
  static String? _search_author;
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();

  Widget _buildTitle(){
    return CustomTextbox(
        controller: titleController,
        padding: const EdgeInsets.fromLTRB(0, 0, 32, 0),
        width: 300,
        labelText: "Tytuł artykułu",
        maxLength: 64,
        validator: (value) {
          if(value == null || value.isEmpty) {
            return null;
          }
          if(!RegExp(r"^[a-zA-ZąćęłńóśźżĄĆĘŁŃÓŚŹŻ0-9]*$").hasMatch(value)) {
            return 'Tylko litery i cyfry';
          }
          return null;
        },
        onSaved: (value) {
          _search_title = value;
        },
        formKey: formKey
    );
  }
  Widget _buildAuthor(){
    return CustomTextbox(
        controller: authorController,
        padding: const EdgeInsets.fromLTRB(0, 0, 32, 0),
        width: 140,
        labelText: "Autor artykułu",
        maxLength: 12,
        validator: (value) {
          if(value == null || value.isEmpty) {
            return null;
          }
          if(!RegExp(r"^[a-zA-ZąćęłńóśźżĄĆĘŁŃÓŚŹŻ0-9]*$").hasMatch(value)) {
            return 'Tylko litery i cyfry';
          }
          return null;
        },
        onSaved: (value) {
          _search_author = value;
        },
        formKey: formKey
    );
  }

  Widget _buildSorts(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 32, 0),
      child: Container(
        height: 42,
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 1))
        ),
        child: Row(
          children: [
            Text("Sortuj po:  ", style: TextStyle(color: CustomTheme.text, fontSize: 16),),
            DropdownButton<String>(
              value: _sortBy,
              onChanged: (value) => setState(() => _sortBy = value!),
              items: ["Najnowsze", "Najstarsze"].map((value){
                return DropdownMenuItem(
                  child: Text(value, style: TextStyle(color: CustomTheme.textDark, fontSize: 16, fontWeight: FontWeight.w600),),
                  value: value,
                );
              }).toList(),
              dropdownColor: CustomTheme.secondaryBackground,
              iconSize: 12,
              underline: Container(color: Colors.transparent, height: 0,),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey,),
              hint: const SizedBox(
                width: 60,
                height: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildCategories(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 32, 0),
      child: Container(
        height: 42,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1))
        ),
        child: Row(
          children: [
            Text("Kategoria:  ", style: TextStyle(color: CustomTheme.text, fontSize: 16),),
            DropdownButton<String>(
              value: _category,
              onChanged: (value) => setState(() => _category = value!),
              items: categories.map((value){
                return DropdownMenuItem(
                  child: Text(value, style: TextStyle(color: CustomTheme.textDark, fontSize: 16, fontWeight: FontWeight.w600),),
                  value: value,
                );
              }).toList(),
              dropdownColor: CustomTheme.secondaryBackground,
              iconSize: 12,
              underline: Container(color: Colors.transparent, height: 0,),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey,),
              hint: const SizedBox(
                width: 60,
                height: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

}


