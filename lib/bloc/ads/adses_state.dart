part of 'adses_cubit.dart';

abstract class AdsesState extends Equatable {
  const AdsesState();
}

class AdsesInitial extends AdsesState {
  final AdHelper adState;
  AdsesInitial({required this.adState});
  @override
  List<Object> get props => [];
}
