import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nibjobs/bloc/search/search_bloc.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/themes/light_color.dart';

class SearchView extends StatefulWidget {
  final String? query;
  final Function? onComplete;

  SearchView({this.query, this.onComplete});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchState();
  }
}

class SearchState extends State<SearchView> {
  TextEditingController? searchController;
  String? search;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController!.dispose();
  }

  Widget _icon(IconData icon, {Color color = LightColor.iconColor}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color: LightColor.background,
      ),
      child: Icon(
        icon,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: LightColor.background,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextField(
                controller: searchController,
                onSubmitted: (v) {
                  widget.onComplete!(v);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.query != null
                      ? StringRsr.get(LanguageKey.SEARCH_SHOP, firstCap: true)
                      : StringRsr.get(LanguageKey.SEARCH_JOBS, firstCap: true),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Colors.black54),
                  contentPadding: const EdgeInsets.only(
                      left: 10, right: 10, bottom: 0, top: 3),
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  suffixIcon: BlocBuilder<SearchBloc, SearchViewState>(
                    builder: (context, state) {
                      if (state is SearchLoaded || state is SearchLoading) {
                        return GestureDetector(
                            onTap: () {
                              searchController!.text = "";
                              BlocProvider.of<SearchBloc>(context)
                                  .add(SearchViewEvent(searchInView: true));
                            },
                            child: Icon(Icons.close, color: Colors.black54));
                      }
                      return const Visibility(
                          visible: false,
                          child: Icon(Icons.close, color: Colors.black54));
                    },
                  ),
                ),
              ),
            ),
          ),
          // const SizedBox(width: 20),
          // BlocBuilder<SortBloc, SortState>(
          //   builder: (context, state) {
          //     if (state is SortInitial) {
          //       return GestureDetector(
          //           onTap: () {
          //             BlocProvider.of<SortBloc>(context)
          //                 .add(SortPriceType(sortUp: !state.sortUp));
          //           },
          //           child: _icon(Icons.filter_list, color: Colors.black54));
          //     } else {
          //       return Container();
          //     }
          //   },
          // )
        ],
      ),
    );
  }
}
