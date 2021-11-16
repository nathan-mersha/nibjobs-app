import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nibjobs/bloc/category/category_bloc.dart';
import 'package:nibjobs/db/k_shared_preference.dart';
import 'package:nibjobs/global.dart' as global;
import 'package:nibjobs/model/config/global.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/themes/light_color.dart';
import 'package:nibjobs/themes/theme.dart';

class CategoryViewSmall extends StatefulWidget {
  final Category _job;
  final String size;
  final bool pageAdmin;
  static const String SIZE_SMALL = "SIZE_SMALL";
  static const String SIZE_MEDIUM = "SIZE_MEDIUM";
  static const String SIZE_LARGE = "SIZE_LARGE";
  CategoryViewSmall(this._job,
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
            placeholderFadeInDuration: Duration(seconds: 1),
            placeholder: (BuildContext context, String imageURL) {
              return Container();
            },
            errorWidget: (BuildContext context, String imageURL, dynamic) {
              return Container();
            },
          );
  }

  @override
  _CategoryViewSmallState createState() => _CategoryViewSmallState();
}

class _CategoryViewSmallState extends State<CategoryViewSmall> {
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
    if (proFavList.contains(widget._job.name)) {
      setState(() {
        isSelected = true;
      });
    } else {
      setState(() {
        isSelected = false;
      });
    }
  }

  Future<void> addToList() async {
    List<String> proFavList =
        await hSharedPreference.get(HSharedPreference.LIST_OF_FAV_CATEGORY) ??
            [];
    proFavList.add(widget._job.name!);

    await hSharedPreference.set(
        HSharedPreference.LIST_OF_FAV_CATEGORY, proFavList);
  }

  Future<void> removeInList() async {
    List<String> proFavList =
        await hSharedPreference.get(HSharedPreference.LIST_OF_FAV_CATEGORY) ??
            [];
    proFavList.remove(widget._job.name);

    await hSharedPreference.set(
        HSharedPreference.LIST_OF_FAV_CATEGORY, proFavList);
    BlocProvider.of<CategoryBloc>(context)
        .add(CategoryNumber(categoryNumber: 5 - proFavList.length));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        ///here

        isSelected = !isSelected;
        if (isSelected) {
          List<String> number = await hSharedPreference
                  .get(HSharedPreference.LIST_OF_FAV_CATEGORY) ??
              [];
          if (number.length < 5) {
            addToList();
            BlocProvider.of<CategoryBloc>(context)
                .add(CategoryNumber(categoryNumber: 5 - (number.length + 1)));
          } else {
            isSelected = false;
          }
        } else {
          removeInList();
        }
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          border:
              Border.all(color: LightColor.iconColor, style: BorderStyle.none),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          // color:
          // isOutLine ? Colors.transparent : Theme.of(context).backgroundColor,
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Image thumbnail or image place holder
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    height: AppTheme.fullWidth(context) < 330 ? 40 : 40,
                    width: AppTheme.fullWidth(context) < 330 ? 40 : 40,
                    decoration: BoxDecoration(
                        color: CustomColor.RAD_DARK,
                        borderRadius: BorderRadius.circular(40)),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CategoryViewSmall.getThumbnailView(widget._job,
                          size: CategoryViewSmall.SIZE_MEDIUM),
                    ),
                  ),

                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Category name
                        Text(
                          StringRsr.locale != "et_am"
                              ? widget._job.name
                              : amCategories!["am"][widget._job.name],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          softWrap: false,
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(
                                    color: Colors.black54,
                                  ),
                          // style: const TextStyle(
                          //     color: Colors.black54,
                          //     fontSize: AppTheme.fullWidth(context) < 330 ? 12 : 19),
                        ),

                        // Category price and regular price
                      ],
                    ),
                  )
                ],
              ),
              Visibility(
                visible: !isSelected,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: CustomColor.GRAY_LIGHT.withOpacity(0.7)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
