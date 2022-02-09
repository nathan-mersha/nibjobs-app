import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nibjobs/api/kelem_api.dart';
import 'package:nibjobs/global.dart' as global;
import 'package:nibjobs/model/commerce/job.dart';
import 'package:nibjobs/model/config/global.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchViewState> {
  SearchBloc() : super(SearchInitial(searchInView: false));

  @override
  Stream<SearchViewState> mapEventToState(
    SearchEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is SearchViewEvent) {
      yield SearchInitial(searchInView: event.searchInView);
    } else if (event is SearchJobEvent) {
      yield SearchLoading();
      List searchData = await SearchAPI.getSearchData(
          document: event.document,
          fields: event.fields,
          query: event.searchData);
      if (searchData.isNotEmpty) {
        for (var i = searchData.length - 4; i >= 1; i -= 4) {
          debugPrint("here serch must be ads 2");

          searchData.insert(
            i,
            Job(title: "googleAdsKelem"),
          );
          debugPrint("here must be ads 3");
        }
        yield SearchLoaded(searchInData: searchData);
      } else {
        yield SearchError();
      }
    } else if (event is SearchCategoryEvent) {
      yield SearchLoading();

      String search = event.searchData.replaceAll(" ", "");
      if (search == "") {
        yield SearchInitial(searchInView: false);
        return;
      }
      List<Category> categories = global.localConfig.categories;
      List<Category> categoriesSorted = [];
      List categoriesData = [];
      for (var e in categories) {
        Category category = Category(
          categoryId: e.categoryId,
          name: e.name,
          icon: e.icon,
          tags: e.tags,
          keys: e.keys,
          firstModified: e.firstModified,
          lastModified: e.lastModified,
        );

        for (var l in e.tags!) {
          if (l!.contains(search)) {
            if (l.startsWith(search)) {
              categoriesData.insert(0, l);
            } else {
              categoriesData.add(l);
            }
          }
        }
        if (categoriesData.isNotEmpty) {
          category.tags = categoriesData;
          categoriesData = [];
          categoriesSorted.add(category);
        }
      }
      yield SearchLoaded(
          searchInData: categoriesSorted, search: event.searchData);
    } else {
      yield SearchError();
    }
  }
}
