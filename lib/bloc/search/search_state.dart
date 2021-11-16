part of 'search_bloc.dart';

abstract class SearchViewState extends Equatable {
  const SearchViewState();
}

class SearchInitial extends SearchViewState {
  final bool searchInView;

  SearchInitial({this.searchInView = true});
  @override
  List<Object> get props => [searchInView];
}

class SearchLoaded extends SearchViewState {
  final List<dynamic> searchInData;

  SearchLoaded({required this.searchInData});
  @override
  List<Object> get props => [searchInData];
}

class SearchLoading extends SearchViewState {
  SearchLoading();
  @override
  List<Object> get props => [];
}

class SearchError extends SearchViewState {
  SearchError();
  @override
  List<Object> get props => [];
}
