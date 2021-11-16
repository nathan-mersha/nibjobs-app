part of 'description_cubit.dart';

abstract class DescriptionState extends Equatable {
  const DescriptionState();
}

class DescriptionInitial extends DescriptionState {
  final bool showDescription;

  DescriptionInitial({required this.showDescription});

  @override
  List<Object> get props => [showDescription];
}
