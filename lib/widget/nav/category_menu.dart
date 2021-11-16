import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nibjobs/bloc/search/search_bloc.dart';
import 'package:nibjobs/bloc/user/user_bloc.dart';
import 'package:nibjobs/global.dart' as global;
import 'package:nibjobs/model/config/global.dart';
import 'package:nibjobs/route/route.dart';
import 'package:nibjobs/themes/light_color.dart';

class CategoryMenu extends StatefulWidget {
  final bool search;
  final bool notification;
  final bool menu;

  const CategoryMenu(
      {Key? key,
      this.search = true,
      this.notification = true,
      this.menu = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CategoryMenuState();
  }
}

class CategoryMenuState extends State<CategoryMenu> {
  bool search = true;
  @override
  void initState() {
    super.initState();
    global.globalConfig.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return global.globalConfig.categories == null
        ? IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          )
        : Row(
            children: [
              Visibility(
                visible: widget.search,
                child: IconButton(
                    onPressed: () {
                      if (search) {
                        search = !search;
                        BlocProvider.of<SearchBloc>(context)
                            .add(SearchViewEvent(searchInView: !search));
                      } else {
                        search = !search;
                        BlocProvider.of<SearchBloc>(context)
                            .add(SearchViewEvent(searchInView: !search));
                      }
                    },
                    icon: const Icon(Icons.find_replace)),
              ),
              Visibility(
                visible: widget.notification,
                child:
                    BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                  if (state is UserSignedInState) {
                    return Visibility(
                        visible: FirebaseAuth.instance.currentUser != null,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, RouteTo.PROFILE_WISH_LIST);
                            },
                            icon: const Icon(Icons.notification_add)));
                  }
                  return Container();
                }),
              ),
              Visibility(
                visible: widget.menu,
                child: PopupMenuButton<Category>(
                  onSelected: (Category result) {
                    /// setting selected category to a global scope.
                    global.localConfig.selectedCategory = result;
                  },
                  itemBuilder: (BuildContext buildContext) {
                    List<PopupMenuEntry<Category>> menu = [];

                    List<Category> categories =
                        global.globalConfig.categories as List<Category>;
                    for (var category in categories) {
                      menu.add(PopupMenuItem(
                        value: category,
                        child: Text(
                          category.name!,
                          style: TextStyle(
                              color: category.name ==
                                      global.localConfig.selectedCategory.name
                                  ? LightColor.orange
                                  : Colors.black),
                        ),
                      ));
                    }
                    return menu;
                  },
                ),
              ),
            ],
          );
  }
}
