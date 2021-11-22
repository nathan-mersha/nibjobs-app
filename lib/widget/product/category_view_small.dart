import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nibjobs/db/k_shared_preference.dart';
import 'package:nibjobs/global.dart' as global;
import 'package:nibjobs/model/config/global.dart';
import 'package:nibjobs/rsr/theme/color.dart';

class CategoryViewSmall extends StatefulWidget {
  final String _job;
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
    if (proFavList.contains(widget._job)) {
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
    proFavList.add(widget._job);

    await hSharedPreference.set(
        HSharedPreference.LIST_OF_FAV_CATEGORY, proFavList);
  }

  Future<void> removeInList() async {
    List<String> proFavList =
        await hSharedPreference.get(HSharedPreference.LIST_OF_FAV_CATEGORY) ??
            [];
    proFavList.remove(widget._job);

    await hSharedPreference.set(
        HSharedPreference.LIST_OF_FAV_CATEGORY, proFavList);
    // BlocProvider.of<CategoryBloc>(context)
    //     .add(CategoryNumber(categoryNumber: 5 - proFavList.length));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            isSelected ? CustomColor.RAD_DARK : CustomColor.GRAY_VERY_LIGHT),
      ),
      onPressed: () async {
        isSelected = !isSelected;
        if (isSelected) {
          List<String> number = await hSharedPreference
                  .get(HSharedPreference.LIST_OF_FAV_CATEGORY) ??
              [];

          addToList();
          // BlocProvider.of<CategoryBloc>(context)
          //     .add(CategoryNumber(categoryNumber: 5 - (number.length + 1)));

        } else {
          removeInList();
        }
        setState(() {});
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
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.black54,
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
}
