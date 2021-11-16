import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nibjobs/bloc/ads/ad_helper.dart';

part 'adses_state.dart';

class AdsesCubit extends Cubit<AdsesState> {
  final AdHelper adState;
  AdsesCubit({required this.adState}) : super(AdsesInitial(adState: adState));
}
