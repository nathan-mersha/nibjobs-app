part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
}

class CategoryInitial extends CategoryState {
  final int categoryNumber;

  CategoryInitial({required this.categoryNumber});

  @override
  List<Object> get props => [categoryNumber];
}
