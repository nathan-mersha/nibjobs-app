part of 'nav_bloc.dart';

abstract class NavEvent extends Equatable {
  const NavEvent();
}

class NavStatusEvent extends NavEvent {
  final Category category;
  final Map<String, dynamic> amCategories;
  final List<Category> categories;
  final List<dynamic> subCategories;
  final List<Ad> adList;
  const NavStatusEvent(
      {required this.category,
      required this.amCategories,
      required this.categories,
      required this.subCategories,
      required this.adList});

  @override
  // TODO: implement props
  List<Object?> get props =>
      [category, amCategories, categories, subCategories, adList];
}
