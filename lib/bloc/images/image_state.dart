part of 'image_cubit.dart';

abstract class ImageState extends Equatable {
  const ImageState();
}

class ImageInitial extends ImageState {
  final int currentIndex;

  ImageInitial({required this.currentIndex});
  @override
  List<Object> get props => [currentIndex];
}
