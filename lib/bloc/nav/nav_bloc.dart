import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nibjobs/global.dart' as global;
import 'package:nibjobs/model/ad_model.dart';
import 'package:nibjobs/model/config/global.dart';

part 'nav_event.dart';
part 'nav_state.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(NavInitial());

  @override
  Stream<NavState> mapEventToState(
    NavEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is NavStatusEvent) {
      yield NavLoaded(
        adList: global.globalConfig.ad!,
        amCategories: global.localConfig.amCategory,
        categories: global.localConfig.categories,
        category: global.localConfig.selectedCategory,
        subCategories: global.localConfig.selectedCategory.tags!,
      );
    }
  }
}
