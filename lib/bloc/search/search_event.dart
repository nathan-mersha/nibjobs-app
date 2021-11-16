part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchViewEvent extends SearchEvent {
  final bool searchInView;
  SearchViewEvent({required this.searchInView});
  @override
  // TODO: implement props
  List<Object> get props => [searchInView];
}

class SearchJobEvent extends SearchEvent {
  final String searchData;
  final String fields;
  final String document;
  SearchJobEvent(
      {required this.searchData, required this.fields, required this.document});
  @override
  // TODO: implement props
  List<Object> get props => [searchData, fields, document];
}
