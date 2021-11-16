part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
}

class CategoryNumber extends CategoryEvent {
  final int categoryNumber;

  CategoryNumber({required this.categoryNumber});

  @override
  // TODO: implement props
  List<Object> get props => [categoryNumber];
}
