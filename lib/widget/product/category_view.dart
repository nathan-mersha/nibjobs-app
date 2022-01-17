import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nibjobs/db/k_shared_preference.dart';
import 'package:nibjobs/global.dart' as global;
import 'package:nibjobs/model/config/global.dart';
import 'package:nibjobs/route/route.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/themes/light_color.dart';
import 'package:nibjobs/themes/theme.dart';

class CategoryView extends StatefulWidget {
  final Category _job;
  final String size;
  bool pageAdmin;
  static const String SIZE_SMALL = "SIZE_SMALL";
  static const String SIZE_MEDIUM = "SIZE_MEDIUM";
  static const String SIZE_LARGE = "SIZE_LARGE";
  CategoryView(this._job, {this.size = SIZE_MEDIUM, this.pageAdmin = false});

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
                fit: BoxFit.fitHeight,
              );
            },
            placeholderFadeInDuration: const Duration(seconds: 1),
            placeholder: (BuildContext context, String imageURL) {
              return Center(
                child: Text(
                  "${job.name![0].toUpperCase()}${job.name![1].toUpperCase()}",
                  // style: const TextStyle(
                  //   fontSize: 12,
                  //   color: CustomColor.PRIM_DARK,
                  // ),
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontSize: 12,
                      ),
                ),
              );
            },
            errorWidget: (BuildContext context, String imageURL, dynamic) {
              return Center(
                child: Text(
                  "${job.name![0].toUpperCase()}${job.name![1].toUpperCase()}",
                  // style: const TextStyle(
                  //   fontSize: 12,
                  //   color: CustomColor.PRIM_DARK,
                  // ),
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontSize: 12,
                      ),
                ),
              );
            },
          );
  }

  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  bool isSelected = false;
  HSharedPreference hSharedPreference = HSharedPreference();
  Map<String, dynamic>? amCategories;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amCategories = global.localConfig.amCategory;
    //seeInList();
  }

  // Future<void> seeInList() async {
  //   List<String> proFavList =
  //       await hSharedPreference.get(HSharedPreference.LIST_OF_FAV) ?? [];
  //   if (proFavList.contains(widget._job.jobId)) {
  //     setState(() {
  //       isSelected = true;
  //     });
  //   } else {
  //     setState(() {
  //       isSelected = false;
  //     });
  //   }
  // }
  //
  // Future<void> addToList() async {
  //   List<String> proFavList =
  //       await hSharedPreference.get(HSharedPreference.LIST_OF_FAV) ?? [];
  //   proFavList.add(widget._job.jobId);
  //
  //   await hSharedPreference.set(HSharedPreference.LIST_OF_FAV, proFavList);
  // }
  //
  // Future<void> removeInList() async {
  //   var proFavList =
  //       await hSharedPreference.get(HSharedPreference.LIST_OF_FAV) ?? [];
  //   proFavList.remove(widget._job.jobId);
  //   await hSharedPreference.set(HSharedPreference.LIST_OF_FAV, proFavList);
  // }
  //
  // Future<void> makePhoneCall(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /// Navigating to item detail page
        if (!widget.pageAdmin) {
          // BlocProvider.of<DownBloc>(context).add(
          //     DownSelectedEvent(job: widget._job, context: context));
          Navigator.pushNamed(context, RouteTo.JOB_CATEGORY,
              arguments: widget._job);
        } else {
          // Navigator.pushNamed(context, RouteTo.SHOP_ADD_ITEM,
          //     arguments: widget._job);
        }
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Image thumbnail or image place holder
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                height: AppTheme.fullWidth(context) < 330 ? 28 : 29,
                width: AppTheme.fullWidth(context) < 330 ? 28 : 29,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(40)),
                child: CategoryView.getThumbnailView(widget._job,
                    size: CategoryView.SIZE_MEDIUM),
              ),

              Expanded(
                flex: 1,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Category name
                      Text(
                        StringRsr.locale != "et_am"
                            ? widget._job.name
                            : amCategories!["am"][widget._job.name] ??
                                widget._job.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        softWrap: false,
                        style:
                            Theme.of(context).textTheme.subtitle1!.copyWith(),
                        // style: const TextStyle(
                        //     color: Colors.black54,
                        //     fontSize: AppTheme.fullWidth(context) < 330 ? 12 : 19),
                      ),

                      // Category Author / Manufacturer
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Text(
                          "${widget._job.tags!.length} ${StringRsr.get(LanguageKey.SUBCATEGORY)}",
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.left,
                          softWrap: false,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(),
                          // style: const TextStyle(
                          //     color: Colors.black26,
                          //     fontSize:
                          //         AppTheme.fullWidth(context) < 330 ? 12 : 14),
                        ),
                      ),

                      // Category price and regular price
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
