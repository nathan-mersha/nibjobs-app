import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nibjobs/db/k_shared_preference.dart';
import 'package:nibjobs/model/profile/company.dart';
import 'package:nibjobs/route/route.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/themes/light_color.dart';
import 'package:nibjobs/themes/theme.dart';

class CompanyView extends StatefulWidget {
  final Company _job;
  final String size;
  final String subCategory;
  bool pageAdmin;
  static const String SIZE_SMALL = "SIZE_SMALL";
  static const String SIZE_MEDIUM = "SIZE_MEDIUM";
  static const String SIZE_LARGE = "SIZE_LARGE";
  CompanyView(this._job, this.subCategory,
      {this.size = SIZE_MEDIUM, this.pageAdmin = false});

  static Widget getThumbnailView(Company job,
      {bool expand = true, String size = SIZE_MEDIUM}) {
    return job.logo == null || job.logo!.isEmpty
        ? CircleAvatar(
            backgroundColor: CustomColor.PRIM_DARK,
            radius: 50,
            child: Center(
              child: Text(
                job.name!.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          )
        : CachedNetworkImage(
            imageUrl: job.logo!,
            useOldImageOnUrlChange: true,
            imageBuilder: (context, imagePath) {
              return ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Image(
                  image: imagePath,
                  fit: BoxFit.cover,
                ),
              );
            },
            placeholderFadeInDuration: const Duration(seconds: 1),
            placeholder: (BuildContext context, String imageURL) {
              return CircleAvatar(
                backgroundColor: CustomColor.PRIM_DARK,
                radius: 50,
                child: Center(
                  child: Text(
                    job.name!.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              );
            },
            errorWidget: (BuildContext context, String imageURL, dynamic) {
              return CircleAvatar(
                backgroundColor: CustomColor.PRIM_DARK,
                radius: 50,
                child: Center(
                  child: Text(
                    job.name!.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              );
            },
          );
  }

  @override
  _CompanyViewState createState() => _CompanyViewState();
}

class _CompanyViewState extends State<CompanyView> {
  bool isSelected = false;
  HSharedPreference hSharedPreference = HSharedPreference();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          Navigator.pushNamed(context, RouteTo.JOB_SEARCH,
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
        child: Stack(
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Image thumbnail or image place holder
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        height: AppTheme.fullWidth(context) < 330 ? 20 : 30,
                        width: AppTheme.fullWidth(context) < 330 ? 20 : 30,
                        decoration: BoxDecoration(
                            color: LightColor.background,
                            borderRadius: BorderRadius.circular(50)),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: CompanyView.getThumbnailView(widget._job,
                              size: CompanyView.SIZE_MEDIUM),
                        ),
                      ),
                      Visibility(
                        visible: widget._job.verified!,
                        child: const Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.verified_user,
                            color: Colors.lightGreen,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // Company name
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget._job.name!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                softWrap: false,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                      color: Colors.black54,
                                    ),
                                // style: const TextStyle(
                                //     color: Colors.black54,
                                //     fontSize: AppTheme.fullWidth(context) < 330
                                //         ? 12
                                //         : 20),
                              ),
                              Text(
                                widget._job.category!,
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                textAlign: TextAlign.left,
                                softWrap: false,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: LightColor.darkgrey,
                                    ),
                                //   style: const TextStyle(
                                //       color: LightColor.darkgrey,
                                //       fontSize: AppTheme.fullWidth(context) < 330
                                //           ? 13
                                //           : 15),
                              ),
                            ],
                          ),

                          // Company Author / Manufacturer
                          Text(
                            "${widget._job.noOfEmployees} ${StringRsr.get(LanguageKey.JOBS)}",
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.left,
                            softWrap: false,
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      color: Colors.black26,
                                    ),
                            // style: const TextStyle(
                            //     color: Colors.black26,
                            //     fontSize: AppTheme.fullWidth(context) < 330
                            //         ? 13
                            //         : 15),
                          ),

                          // Company price and regular price
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
