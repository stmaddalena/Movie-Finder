import 'package:flutter/material.dart';
import '../models/entertainment.dart';

class EntertainmentDetailsScreen extends StatefulWidget {
  final Entertainment entertainment;

  EntertainmentDetailsScreen({required this.entertainment});

  @override
  _EntertainmentDetailsScreenState createState() =>
      _EntertainmentDetailsScreenState();
}

class _EntertainmentDetailsScreenState
    extends State<EntertainmentDetailsScreen> {
  List<bool> showFullReview = [];
  String? selectedStars;

  @override
  void initState() {
    super.initState();
    showFullReview =
        List.generate(widget.entertainment.reviews.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    List<Reviews> filteredReviews =
        widget.entertainment.reviews.where((review) {
      if (selectedStars == null) return true;
      return review.stars == selectedStars;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 20, 20, 20),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[50]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color.fromARGB(255, 20, 20, 20),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  width: 250, 
                  height: 375, 
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      widget.entertainment.poster,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 32.0),
              Text(
                widget.entertainment.title,
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.grey[50],
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '[ ',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[50],
                              fontWeight: FontWeight.w300),
                        ),
                        TextSpan(
                          text: widget.entertainment.rating,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[50],
                          ),
                        ),
                        TextSpan(
                          text: ' ]',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[50],
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.0),
                  Text(
                    widget.entertainment.genres.join(' • '),
                    style: TextStyle(fontSize: 16, color: Colors.blue[200]),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(widget.entertainment.synopsis,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[350],
                      fontWeight: FontWeight.w300)),
              SizedBox(height: 32.0),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Where to watch :  ',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[200],
                          fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: widget.entertainment.streaming.join(' • '),
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[50],
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Duration :  ',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[200],
                          fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: widget.entertainment.duration,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[50],
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Score :  ',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[200],
                          fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: widget.entertainment.score,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[50],
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Release date :  ',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[200],
                          fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: widget.entertainment.releaseDate,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[50],
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Original language :  ',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[200],
                          fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: widget.entertainment.originalLanguage,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[50],
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Production co :  ',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[200],
                          fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: widget.entertainment.productionCos.join(' • '),
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[50],
                          fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.0),
                  Container(
                    padding: EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stars',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue[200],
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 2 / 3,
                          ),
                          itemCount: widget.entertainment.cast.length,
                          itemBuilder: (context, index) {
                            final castMember = widget.entertainment.cast[index];
                            return Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    castMember.photo,
                                    width: 80,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  castMember.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[50],
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    padding: EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Directed by',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue[200],
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 2 / 3,
                          ),
                          itemCount: widget.entertainment.directors.length,
                          itemBuilder: (context, index) {
                            final directorsMember =
                                widget.entertainment.directors[index];
                            return Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    directorsMember.photo,
                                    width: 80,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  directorsMember.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[50],
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 36.0),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, 
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0),
                    child: Row(
                      children: [
                        Text(
                          '[ ${widget.entertainment.reviews.length} ]',
                          style: TextStyle(
                            color:
                                Colors.grey[50],
                            fontSize: 16, 
                          ),
                        ),
                        SizedBox(
                            width: 8), 
                        Text(
                          'Reviews', 
                          style: TextStyle(
                            color: Colors.blue[200], 
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent, 
                      border: Border.all(
                          color: Colors.grey[50]!, width: 0.6), 
                      borderRadius:
                          BorderRadius.circular(4.0), 
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 0), 
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Text('Filter by stars',
                              style: TextStyle(
                                  color: Colors.grey[50],
                                  fontSize: 15)),
                          value: selectedStars,
                          items: [
                            DropdownMenuItem(
                                value: null,
                                child: Text('Filter by All',
                                    style: TextStyle(
                                        color: Colors.grey[50],
                                        fontSize: 15))), 
                            DropdownMenuItem(
                                value: '★★★★★',
                                child: Text('Filter by 5 stars',
                                    style: TextStyle(
                                        color: Colors.grey[50],
                                        fontSize: 15))), 
                            DropdownMenuItem(
                                value: '★★★★',
                                child: Text('Filter by 4 stars',
                                    style: TextStyle(
                                        color: Colors.grey[50],
                                        fontSize: 15))), 
                            DropdownMenuItem(
                                value: '★★★',
                                child: Text('Filter by 3 stars',
                                    style: TextStyle(
                                        color: Colors.grey[50],
                                        fontSize: 15))), 
                            DropdownMenuItem(
                                value: '★★',
                                child: Text('Filter by 2 stars',
                                    style: TextStyle(
                                        color: Colors.grey[50],
                                        fontSize: 15))), 
                            DropdownMenuItem(
                                value: '★',
                                child: Text('Filter by 1 star',
                                    style: TextStyle(
                                        color: Colors.grey[50],
                                        fontSize: 15))), 
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedStars = value;
                            });
                          },
                          dropdownColor: Colors
                              .grey[800], 
                          style: TextStyle(
                              color: Colors.grey[50],
                              fontSize: 15), 
                          icon: Icon(Icons.arrow_drop_down,
                              color: Colors.grey[50]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.0),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredReviews.length,
                itemBuilder: (context, index) {
                  final review = filteredReviews[index];
                  final isExpanded = showFullReview[index];
                  final textSpan = TextSpan(
                    text: review.review,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[50],
                      fontWeight: FontWeight.w300,
                    ),
                  );
                  final textPainter = TextPainter(
                    text: textSpan,
                    maxLines: 5,
                    textDirection: TextDirection.ltr,
                  );
                  textPainter.layout(
                    minWidth: 0,
                    maxWidth: MediaQuery.of(context).size.width,
                  );

                  final isOverflowing = textPainter.didExceedMaxLines;

                  return Container(
                    padding: EdgeInsets.all(12.0),
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.0),
                        Text(
                          '${review.name}   ${review.stars}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blue[200],
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          review.review,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[50],
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: isExpanded ? null : 5,
                          overflow: isExpanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                        ),
                        if (isOverflowing) 
                          SizedBox(height: 8.0),
                        if (isOverflowing)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showFullReview[index] = !isExpanded;
                                  });
                                },
                                child: Text(
                                  isExpanded ? 'show less' : 'show more',
                                  style: TextStyle(
                                    color: Colors.blue[200],
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),

              SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}
