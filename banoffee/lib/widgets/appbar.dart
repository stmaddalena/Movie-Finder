import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String searchQuery;
  final String selectedGenre;
  final String selectedStreaming;
  final String? selectedType;
  final List<String> genres;
  final List<String> streaming;
  final List<String> suggestions;
  final List<Map<String, String>> castMembers;
  final ValueChanged<String?> onGenreSelected;
  final ValueChanged<String?> onStreamingSelected;
  final ValueChanged<String?> onTypeSelected;
  final ValueChanged<String> onSearchChanged;
  final Color borderColor = Colors.grey[50]!;

  final String selectedSort;
  final ValueChanged<String?> onSortSelected;

  CustomAppBar({
    required this.title,
    required this.searchQuery,
    required this.selectedGenre,
    required this.selectedStreaming,
    required this.selectedType,
    required this.genres,
    required this.streaming,
    required this.suggestions,
    required this.castMembers,
    required this.onGenreSelected,
    required this.onStreamingSelected,
    required this.onTypeSelected,
    required this.onSearchChanged,
    required this.selectedSort, 
    required this.onSortSelected, 
  });

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            color: Colors.transparent,
            child: Material(
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 16, 16, 16),
                ),
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }

                    final suggestionsOptions =
                        suggestions.where((String option) {
                      return option
                          .toLowerCase()
                          .startsWith(textEditingValue.text.toLowerCase());
                    }).take(6);

                    final firstNameMatches = castMembers
                        .where((Map<String, String> member) {
                          final names =
                              member['name']!.toLowerCase().split(' ');
                          return names.first
                              .startsWith(textEditingValue.text.toLowerCase());
                        })
                        .map((member) => member['name']!)
                        .toList();

                    final lastNameMatches = castMembers
                        .where((Map<String, String> member) {
                          final names =
                              member['name']!.toLowerCase().split(' ');
                          return names.length > 1 &&
                              names.last.startsWith(
                                  textEditingValue.text.toLowerCase());
                        })
                        .map((member) => member['name']!)
                        .toList();

                    final castMembersOptions = [
                      ...firstNameMatches,
                      ...lastNameMatches
                    ].toSet().take(6).toList();

                    return suggestionsOptions.followedBy(castMembersOptions);
                  },
                  onSelected: (String selection) {
                    onSearchChanged(selection);
                    Navigator.pop(context);
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    return TextField(
                      controller: textEditingController,
                      autofocus: true,
                      focusNode: focusNode,
                      style: TextStyle(
                        color: Colors.grey[50],
                      ),
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                            color: Colors.grey[300],
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.close, color: Colors.grey[300]),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      onSubmitted: (String value) {
                        onSearchChanged(value);
                        Navigator.pop(context);
                      },
                    );
                  },
                  optionsViewBuilder: (BuildContext context,
                      AutocompleteOnSelected<String> onSelected,
                      Iterable<String> options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 32,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 16, 16, 16),
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            final member = castMembers.firstWhere(
                              (m) => m['name'] == option,
                              orElse: () => {'name': '', 'photo': ''},
                            );

                            return ListTile(
                              leading: member['photo'] != ''
                                  ? ClipOval(
                                      child: Image.network(
                                        member['photo']!,
                                        width: 38,
                                        height: 38,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.topCenter,
                                      ),
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(
                                          left: 9.0, right: 9.0),
                                      child: Icon(
                                        Icons.search,
                                        color: Colors.grey[300],
                                        size: 20,
                                      ),
                                    ),
                              title: Text(
                                option,
                                style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: 16,
                                ),
                              ),
                              contentPadding:
                                  EdgeInsets.only(top: 0, bottom: 6.0),
                              dense: true,
                              onTap: () {
                                onSelected(option);
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showGenreDialog(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final double itemHeight = 50.0;
    final double dialogHeight = 450.0;

    showDialog(
      context: context,
      barrierColor: Color.fromARGB(204, 0, 0, 0),
      builder: (BuildContext context) {
        return Center(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: dialogHeight,
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: AlertDialog(
              backgroundColor: Color.fromARGB(0, 0, 0, 0),
              contentPadding: EdgeInsets.zero,
              content: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (notification is ScrollUpdateNotification) {
                    (context as Element).markNeedsBuild();
                  }
                  return true;
                },
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: genres
                            .asMap()
                            .entries
                            .map((MapEntry<int, String> entry) {
                          int index = entry.key;
                          String genre = entry.value;
                          double itemOffset = index * itemHeight;
                          double scrollOffset = scrollController.hasClients
                              ? scrollController.offset
                              : 0.0;
                          double viewportHeight = dialogHeight;
                          double maxDistance = viewportHeight;
                          double itemPosition = itemOffset - scrollOffset;
                          double opacity = 1.0 - (itemPosition / maxDistance);
                          opacity = opacity.clamp(0.0, 1.0);

                          return ListTile(
                            title: Center(
                              child: Text(
                                genre.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.grey[50]?.withOpacity(opacity),
                                  fontSize: 22.0,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              onGenreSelected(genre);
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showStreamingDialog(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final double dialogHeight = 450.0;
    showDialog(
      context: context,
      barrierColor: Color.fromARGB(204, 0, 0, 0),
      builder: (BuildContext context) {
        return Center(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: dialogHeight,
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: AlertDialog(
              backgroundColor: Color.fromARGB(0, 0, 0, 0),
              contentPadding: EdgeInsets.zero,
              content: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (notification is ScrollUpdateNotification) {
                    (context as Element).markNeedsBuild();
                  }
                  return true;
                },
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: streaming
                            .asMap()
                            .entries
                            .map((MapEntry<int, String> entry) {
                          String streaming = entry.value;
                          return ListTile(
                            title: Center(
                              child: Text(
                                streaming.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.grey[50],
                                  fontSize: 22.0,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              onStreamingSelected(streaming);
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSortDialog(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final double dialogHeight = 450.0; 

    showDialog(
      context: context,
      barrierColor: Color.fromARGB(204, 0, 0, 0),
      builder: (BuildContext context) {
        return Center(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: dialogHeight,
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: AlertDialog(
              backgroundColor:
                  Color.fromARGB(0, 0, 0, 0), 
              contentPadding: EdgeInsets.zero,
              content: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (notification is ScrollUpdateNotification) {
                    (context as Element).markNeedsBuild();
                  }
                  return true;
                },
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Center(
                              child: Text(
                                'ALPHABET',
                                style: TextStyle(
                                  color: Colors.grey[50],
                                  fontSize: 22.0,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              onSortSelected(
                                  'alphabet'); 
                            },
                          ),
                          ListTile(
                            title: Center(
                              child: Text(
                                'NEWEST',
                                style: TextStyle(
                                  color: Colors.grey[50],
                                  fontSize: 22.0,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              onSortSelected(
                                  'newest');
                            },
                          ),
                          ListTile(
                            title: Center(
                              child: Text(
                                'MOST SCORE',
                                style: TextStyle(
                                  color: Colors.grey[50],
                                  fontSize: 22.0,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              onSortSelected(
                                  'most score'); 
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: EdgeInsets.zero,
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[50]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      titleSpacing: 0,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.grey[50],
          fontWeight: FontWeight.bold,
          fontSize: 19.5,
        ),
      ),

      backgroundColor: Color.fromARGB(255, 16, 16, 16),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: Colors.grey[50]),
          onPressed: () => _showSearchDialog(context),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0)
              .copyWith(bottom: 14.0),
          child: Column(
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () => _showSortDialog(context),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: borderColor, width: 0.6),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 14.0),
                      backgroundColor: Colors.transparent,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedSort == 'None'
                              ? 'SORT BY DEFAULT'
                              : 'SORT BY ${selectedSort}'
                                  .toUpperCase(),
                          style: TextStyle(
                              color: borderColor, fontWeight: FontWeight.w300),
                        ),
                        SizedBox(width: 6.0),
                        Icon(Icons.sort, color: borderColor, size: 18),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.0),
                  if (selectedType == null) ...[
                    TextButton(
                      onPressed: () {
                        onTypeSelected('Movie');
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(color: borderColor, width: 0.6),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 14.0),
                        backgroundColor: Colors.transparent,
                      ),
                      child: Text(
                        'MOVIE',
                        style: TextStyle(
                          color: selectedType == 'Movie'
                              ? Colors.red
                              : borderColor,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    TextButton(
                      onPressed: () {
                        onTypeSelected('Series');
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(color: borderColor, width: 0.6),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 14.0),
                        backgroundColor: Colors.transparent,
                      ),
                      child: Text(
                        'SERIES',
                        style: TextStyle(
                          color: selectedType == 'Series'
                              ? Colors.red
                              : borderColor,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ] else ...[
                    TextButton.icon(
                      onPressed: () => onTypeSelected(null),
                      icon: Icon(Icons.cancel, color: borderColor),
                      label: Text(
                        selectedType!.toUpperCase(),
                        style: TextStyle(
                            color: borderColor, fontWeight: FontWeight.w300),
                      ),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(color: borderColor, width: 0.6),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 14.0),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  if (selectedGenre != 'All') ...[
                    TextButton.icon(
                      onPressed: () {
                        onGenreSelected('All');
                      },
                      icon: Icon(Icons.cancel, color: borderColor),
                      label: Text(
                        selectedGenre.toUpperCase(),
                        style: TextStyle(
                            color: borderColor, fontWeight: FontWeight.w300),
                      ),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(color: borderColor, width: 0.6),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 14.0),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ] else ...[
                    TextButton(
                      onPressed: () => _showGenreDialog(context),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(color: borderColor, width: 0.6),
                        ),
                        padding: EdgeInsets.only(left: 14.0, right: 8),
                        backgroundColor: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'GENRES',
                            style: TextStyle(
                                color: borderColor,
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(width: 2.0),
                          Icon(Icons.arrow_drop_down, color: borderColor),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(width: 8.0),
                  if (selectedStreaming != 'All') ...[
                    TextButton.icon(
                      onPressed: () {
                        onStreamingSelected('All');
                      },
                      icon: Icon(Icons.cancel, color: borderColor),
                      label: Text(
                        selectedStreaming.toUpperCase(),
                        style: TextStyle(
                            color: borderColor, fontWeight: FontWeight.w300),
                      ),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(color: borderColor, width: 0.6),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 14.0),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ] else ...[
                    TextButton(
                      onPressed: () => _showStreamingDialog(context),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(color: borderColor, width: 0.6),
                        ),
                        padding: EdgeInsets.only(left: 14.0, right: 8),
                        backgroundColor: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'STREAMING',
                            style: TextStyle(
                                color: borderColor,
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(width: 2.0),
                          Icon(Icons.arrow_drop_down, color: borderColor),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(180);
}
