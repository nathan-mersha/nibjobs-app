import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nibjobs/api/flutterfire.dart';
import 'package:nibjobs/bloc/button/button_bloc.dart';
import 'package:nibjobs/db/k_shared_preference.dart';
import 'package:nibjobs/global.dart' as global;
import 'package:nibjobs/model/config/global.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';

class CategoryViewSmall extends StatefulWidget {
  final String _job;
  final String size;
  final Category? category;
  final bool pageAdmin;
  static const String SIZE_SMALL = "SIZE_SMALL";
  static const String SIZE_MEDIUM = "SIZE_MEDIUM";
  static const String SIZE_LARGE = "SIZE_LARGE";
  CategoryViewSmall(this._job, this.category,
      {this.size = SIZE_MEDIUM, this.pageAdmin = false});

  static Widget getThumbnailView(Category job,
      {bool expand = true, String size = SIZE_MEDIUM}) {
    return job.icon == null || job.icon!.isEmpty
        ? Container()
        : CachedNetworkImage(
            imageUrl: job.icon!,
            useOldImageOnUrlChange: true,
            imageBuilder: (context, imagePath) {
              return Image(
                image: imagePath,
                // fit: BoxFit.fitHeight,
                height: 40,
              );
            },
            placeholderFadeInDuration: const Duration(seconds: 1),
            placeholder: (BuildContext context, String imageURL) {
              return Container();
            },
            errorWidget: (BuildContext context, String imageURL, dynamic) {
              return Container();
            },
          );
  }

  @override
  CategoryViewSmallState createState() => CategoryViewSmallState();
}

class CategoryViewSmallState extends State<CategoryViewSmall> {
  bool isSelected = false;
  HSharedPreference hSharedPreference = HSharedPreference();
  Map<String, dynamic>? amCategories;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amCategories = global.localConfig.amCategory;
    seeInList();
  }

  Future<void> seeInList() async {
    List<String> proFavList =
        await hSharedPreference.get(HSharedPreference.LIST_OF_FAV_CATEGORY) ??
            [];
    if (proFavList.contains(widget._job)) {
      setState(() {
        isSelected = true;
      });
    } else {
      isSelected = false;
    }
  }

  Future<void> addToList() async {
    List<String> proFavList =
        await hSharedPreference.get(HSharedPreference.LIST_OF_FAV_CATEGORY) ??
            [];
    List<String> proOrderList =
        await hSharedPreference.get(HSharedPreference.LIST_OF_CATEGORY_ORDER) ??
            [];

    proFavList.add(widget._job);
    if (!proOrderList.contains(widget.category!.name!)) {
      proOrderList.add(widget.category!.name!);
      await hSharedPreference.set(
          HSharedPreference.LIST_OF_CATEGORY_ORDER, proOrderList);
    }
    await hSharedPreference.set(
        HSharedPreference.LIST_OF_FAV_CATEGORY, proFavList);

    BlocProvider.of<ButtonBloc>(context)
        .add(ButtonSet(categoryList: proFavList));
  }

  Future<void> removeInList() async {
    List<String> proFavList =
        await hSharedPreference.get(HSharedPreference.LIST_OF_FAV_CATEGORY) ??
            [];
    proFavList.remove(widget._job);

    await hSharedPreference.set(
        HSharedPreference.LIST_OF_FAV_CATEGORY, proFavList);
    BlocProvider.of<ButtonBloc>(context)
        .add(ButtonSet(categoryList: proFavList));
    // BlocProvider.of<CategoryBloc>(context)
    //     .add(CategoryNumber(categoryNumber: 5 - proFavList.length));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonBloc, ButtonState>(
      builder: (context, state) {
        if (state is ButtonInitial) {
          //seeInList();
          return ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(isSelected
                  ? CustomColor.RAD_DARK
                  : CustomColor.GRAY_VERY_LIGHT),
            ),
            onPressed: () async {
              List<String> number = await hSharedPreference
                      .get(HSharedPreference.LIST_OF_FAV_CATEGORY) ??
                  [];
              if (number.length < 10) {
                isSelected = !isSelected;
                if (isSelected) {
                  addToList();
                  // BlocProvider.of<CategoryBloc>(context)
                  //     .add(CategoryNumber(categoryNumber: 5 - (number.length + 1)));
                } else {
                  removeInList();
                }
                setState(() {});
              } else {
                BlocProvider.of<ButtonBloc>(context)
                    .add(ButtonSet(categoryList: number));
                showInfoToUser(
                  context,
                  DialogType.ERROR,
                  StringRsr.get(LanguageKey.LIMIT_REACHED, firstCap: true),
                  StringRsr.get(LanguageKey.YOU_CANT_SELECT_MORE_THAN_TEN,
                      firstCap: true),
                  onOk: () {},
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Image thumbnail or image place holder

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Category name
                    Text(
                      // StringRsr.locale != "et_am"
                      //     ? widget._job.name!
                      //     : amCategories!["am"][widget._job.name],
                      widget._job,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      softWrap: false,
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            color: isSelected ? Colors.white : Colors.black54,
                          ),
                      // style: const TextStyle(
                      //     color: Colors.black54,
                      //     fontSize: AppTheme.fullWidth(context) < 330 ? 12 : 19),
                    ),

                    // Category price and regular price
                  ],
                )
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}

class ListForCategory extends StatefulWidget {
  final Category? category;
  final bool? viewJob;
  const ListForCategory({Key? key, this.category, this.viewJob})
      : super(key: key);

  @override
  _ListForCategoryState createState() => _ListForCategoryState();
}

class _ListForCategoryState extends State<ListForCategory> {
  bool isSelectedCategory = false;
  HSharedPreference hSharedPreference = HSharedPreference();
  Map<String, dynamic>? amCategories;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amCategories = global.localConfig.amCategory;
    global.localConfig.addListener(() {
      if (mounted) {
        setState(() {
          amCategories = global.localConfig.amCategory;
        });
      }
    });

    seeInList();
  }

  Future<void> seeInList() async {
    List<String> proOrderList =
        await hSharedPreference.get(HSharedPreference.LIST_OF_CATEGORY_ORDER) ??
            [];
    if (proOrderList.contains(widget.category!.name)) {
      setState(() {
        isSelectedCategory = true;
      });
    } else {
      setState(() {
        isSelectedCategory = false;
      });
    }
  }

  Future<void> addToList() async {
    List<String> proFavList =
        await hSharedPreference.get(HSharedPreference.LIST_OF_FAV_CATEGORY) ??
            [];
    List<String> proOrderList =
        await hSharedPreference.get(HSharedPreference.LIST_OF_CATEGORY_ORDER) ??
            [];
    proOrderList.remove(widget.category!.name!);
    proOrderList.add(widget.category!.name!);
    //proFavList.addAll(widget.category!.tags! as List<String>);
    for (var element in widget.category!.tags!) {
      proFavList.remove(element);
    }
    proFavList.addAll(widget.category!.tags!.map((e) => e));

    await hSharedPreference.set(
        HSharedPreference.LIST_OF_FAV_CATEGORY, proFavList);
    await hSharedPreference.set(
        HSharedPreference.LIST_OF_CATEGORY_ORDER, proOrderList);

    BlocProvider.of<ButtonBloc>(context)
        .add(ButtonSet(categoryList: proFavList));
  }

  Future<void> removeInList() async {
    List<String> proFavList =
        await hSharedPreference.get(HSharedPreference.LIST_OF_FAV_CATEGORY) ??
            [];
    List<String> proOrderList =
        await hSharedPreference.get(HSharedPreference.LIST_OF_CATEGORY_ORDER) ??
            [];
    proOrderList.remove(widget.category!.name!);
    //proFavList.removeAll(widget.category!.tags! as List<String>);
    for (var element in widget.category!.tags!) {
      proFavList.remove(element);
    }
    await hSharedPreference.set(
        HSharedPreference.LIST_OF_FAV_CATEGORY, proFavList);
    await hSharedPreference.set(
        HSharedPreference.LIST_OF_CATEGORY_ORDER, proOrderList);
    BlocProvider.of<ButtonBloc>(context)
        .add(ButtonSet(categoryList: proFavList));

    // BlocProvider.of<CategoryBloc>(context)
    //     .add(CategoryNumber(categoryNumber: 5 - proFavList.length));
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      backgroundColor: Theme.of(context).backgroundColor,
      // leading: Checkbox(
      //   value: isSelectedCategory,
      //   onChanged: (bool? value) {
      //     setState(() {
      //       isSelectedCategory = value!;
      //       if (isSelectedCategory) {
      //         addToList();
      //       } else {
      //         removeInList();
      //       }
      //     });
      //   },
      // ),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          // widget.category!.name!,
          StringRsr.locale != "et_am"
              ? widget.category!.name!.toString()
              : amCategories!["am"][widget.category!.name!.toString()] ??
                  widget.category!.name!.toString(),
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
        ),
      ),
      initiallyExpanded: widget.viewJob!,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            alignment: WrapAlignment.start,
            runSpacing: 4,
            spacing: 3,
            children: widget.category!.tags!
                .map((e) => CategoryViewSmall(e, widget.category!))
                .toSet()
                .toList(),
          ),
        ),
      ],
    );
  }
}
