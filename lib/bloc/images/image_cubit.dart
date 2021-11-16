import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'image_state.dart';

class ImageCubit extends Cubit<ImageState> {
  int index = 0;

  ImageCubit() : super(ImageInitial(currentIndex: 0));

  void emitNextImage(int imageLength) {
    if (index < imageLength - 1) {
      index = index + 1;
      emit(ImageInitial(currentIndex: index));
    }
  }

  void emitPreviceImage(int imageLength) {
    if (index > 0) {
      index = index - 1;
      emit(ImageInitial(currentIndex: index));
    }
  }
}
