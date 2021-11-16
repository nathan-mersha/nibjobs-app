import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nibjobs/model/commerce/job.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/widget/product/product_view.dart';

Widget buildJobViewSectionBottomSheet(Job job, BuildContext context) {
  return Container(
    height: 250,
    child: Stack(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Center(
                                      child: AutoSizeText(
                                        job.company!.name!,
                                        style: const TextStyle(
                                          fontSize: 25,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            job.company!.primaryPhone!,
                                            style: const TextStyle(
                                                color: CustomColor.GRAY_LIGHT),
                                          ),
                                          Text(
                                            job.company!.primaryPhone!,
                                            style: const TextStyle(
                                                color: CustomColor.GRAY_LIGHT),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Center(
                                      child: AutoSizeText(
                                        job.company!.website! == ""
                                            ? job.company!.name!
                                            : job.company!.website!,
                                        style: const TextStyle(
                                            color: CustomColor.GRAY_LIGHT),
                                        maxLines: 3,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            job.company!.physicalAddress!,
                                            style: const TextStyle(
                                                color: CustomColor.GRAY_LIGHT),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 60,
            width: 60,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.all(15),
            child: CachedNetworkImage(
              imageUrl: job.company!.logo!,
              imageBuilder: (context, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20)),
                );
              },
              useOldImageOnUrlChange: true,
              fit: BoxFit.cover,
              placeholderFadeInDuration: Duration(microseconds: 200),
              placeholder: (BuildContext context, String imageURL) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.withOpacity(0.0)),
                  ),
                );
              },
            ),
          ),
        )
      ],
    ),
  );
}

Expanded buildJobViewCart(Job job, BuildContext context, int index) {
  return Expanded(
    child: Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Center(
                  child:
                      JobView.getThumbnailView(job, size: JobView.SIZE_SMALL),
                )),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AutoSizeText(
                            job.name!,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.fade,
                          ),
                          AutoSizeText(
                            job.authorOrManufacturer!,
                            style:
                                const TextStyle(color: CustomColor.GRAY_LIGHT),
                          ),
                          AutoSizeText(
                            "${job.price.toString()} br",
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 0, 10),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              if (num.parse(job.quantity!) <= 1) return;
                              job.quantity =
                                  (num.parse(job.quantity!) - 1).toString();
                              // BlocProvider.of<CartBloc>(context).add(
                              //     ReplaceCartDetails(
                              //         cartItem: job, index: index));
                            },
                            icon: const Icon(Icons.remove)),
                        // Container(
                        //     width: 20,
                        //     child: TextFormField(
                        //       initialValue: job.quantity,
                        //       onChanged: (value) {
                        //
                        //         if (value != "" && value != "0") {
                        //           job.quantity = value;
                        //           BlocProvider.of<CartBloc>(context).add(
                        //               ReplaceCartDetails(
                        //                   cartItem: job, index: index));
                        //         }
                        //       },
                        //     )),
                        TextButton(
                          onPressed: () {},
                          child: Text(job.quantity!),
                        ),
                        IconButton(
                            onPressed: () {
                              job.quantity =
                                  (num.parse(job.quantity!) + 1).toString();
                              // BlocProvider.of<CartBloc>(context).add(
                              //     ReplaceCartDetails(
                              //         cartItem: job, index: index));
                            },
                            icon: const Icon(Icons.add)),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                // BlocProvider.of<CartBloc>(context)
                //     .add(CardRemoveItem(cartItem: job));
              },
              child: const Icon(
                Icons.close,
                size: 15,
                color: CustomColor.GRAY_LIGHT,
              ),
            )),
      ],
    ),
  );
}

Widget cardButton(Job job) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      // BlocBuilder<CartBloc, CartState>(
      //   builder: (context, state) {
      //     if (state is CartGetItemState) {
      //       return Text("len ${state.cartItem.jobs.length}");
      //     }
      //     return Text(" ");
      //   },
      // ),
      // const SizedBox(
      //   width: 2,
      // ),   // BlocBuilder<CartBloc, CartState>(
      //   builder: (context, state) {
      //     if (state is CartGetItemState) {
      //       return Text("len ${state.cartItem.jobs.length}");
      //     }
      //     return Text(" ");
      //   },
      // ),
      // const SizedBox(
      //   width: 2,
      // ),
      // BlocBuilder<CartBloc, CartState>(
      //   builder: (context, state) {
      //     if (state is CartGetItemState) {
      //       if (state.cartItem.jobs != null) {
      //         for (int i = 0; i < state.cartItem.jobs.length; i++) {
      //           if (state.cartItem.jobs[i].jobId == job.jobId) {
      //             return ElevatedButton(
      //               child: Text("Remove from cart"),
      //               onPressed: () {
      //                 BlocProvider.of<CartBloc>(context)
      //                     .add(CardRemoveItem(cartItem: job));
      //               },
      //             );
      //           } else {}
      //         }
      //       }
      //     }
      //     return ElevatedButton(
      //       child: Text("Add to cart"),
      //       onPressed: () {
      //         // int add = cart != null ? int.parse(cart) : 0;
      //         // setState(() {
      //         //   cart = (add + 1).toString();
      //         // });
      //
      //         BlocProvider.of<CartBloc>(context)
      //             .add(CardAddItem(cartItem: job));
      //       },
      //     );
      //   },
      // )
    ],
  );
}
