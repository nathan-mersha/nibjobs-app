import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nibjobs/api/kelem_api.dart';
import 'package:nibjobs/model/commerce/job.dart';

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
            Job(name: "googleAdsKelem"),
          );
          debugPrint("here must be ads 3");
        }
        yield SearchLoaded(searchInData: searchData);
      } else {
        yield SearchError();
      }
    }
  }
}
