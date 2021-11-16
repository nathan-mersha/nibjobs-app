import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'description_state.dart';

class DescriptionCubit extends Cubit<DescriptionState> {
  bool showDescription = true;
  DescriptionCubit() : super(DescriptionInitial(showDescription: true));

  void emitDescription() {
    showDescription = !showDescription;
    emit(DescriptionInitial(showDescription: showDescription));
  }
}
