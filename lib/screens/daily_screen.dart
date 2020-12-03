import 'dart:convert';

import 'package:Daily_Quote/helpers/database_helper.dart';
import 'package:Daily_Quote/models/quote_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:scratcher/scratcher.dart';

class DailyScreen extends StatefulWidget {
  @override
  _DailyScreenState createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen>
    with SingleTickerProviderStateMixin {
  String _quoteURL = "https://type.fit/api/quotes";
  Future<Quote> futureQuote;
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    futureQuote = fetchQuote();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      upperBound: 1,
      vsync: this,
    );
    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCubic);
    _animationController.forward();
    _animationController.addListener(() {
      setState(() {});
    });
  }

  Future<Quote> fetchQuote() async {
    final response = await http.get(_quoteURL);
    if (response.statusCode == 200) {
      return Quote.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load quote');
    }
  }

  _unlockedQuote(Quote quote) {
    DatabaseHelper.instance.insertQuote(quote);
  }

  _buildQuoteCard(Quote quote) {
    return Material(
      elevation: _animation.value * 40,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.15,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Scratcher(
            onThreshold: () => _unlockedQuote(quote),
            brushSize: 30,
            threshold: 40,
            color: Colors.red,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              // elevation: _animation.value * 80,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  quote.quoteText,
                  style: GoogleFonts.quicksand(
                      fontSize: 35, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          "https://preview.redd.it/qwd83nc4xxf41.jpg?width=640&crop=smart&auto=webp&s=e82767fdf47158e80604f407ce4938e44afc6c25",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Daily",
              style: GoogleFonts.quicksand(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.black),
            ),
          ),
          body: Center(
            child: Column(
              children: [
                FutureBuilder<Quote>(
                  future: futureQuote,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return _buildQuoteCard(snapshot.data);
                    } else if (snapshot.hasError) {
                      return Text("NULL");
                    }
                    return CircularProgressIndicator();
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Divider(
                  height: 5,
                  color: Colors.black,
                  indent: 15,
                  endIndent: 15,
                  thickness: .4,
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.15,
                    child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (BuildContext context, index) {
                          return Container(
                            child: Card(
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Mon",
                                            textAlign: TextAlign.center,
                                          ),
                                          Text("14")
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text("hello")
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
