import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final int length;
  //HSharedPreference hSharedPreference = HSharedPreference();
  CategoryBloc({required this.length})
      : super(CategoryInitial(categoryNumber: length));

  // Stream<CategoryState> func() async* {
  //   List<String> proFavList =
  //       await hSharedPreference.get(HSharedPreference.LIST_OF_FAV_CATEGORY) ??
  //           [];
  //   length = length - proFavList.length;
  //   debugPrint("proFavList ${proFavList.length} $length");
  //   yield CategoryInitial(categoryNumber: length);
  // }

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    // TODO: implement mapEventToState
    if (event is CategoryNumber) {
      yield CategoryInitial(categoryNumber: event.categoryNumber);
    }
  }
}
