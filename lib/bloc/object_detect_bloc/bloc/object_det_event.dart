part of 'object_det_bloc.dart';

sealed class ObjectDetEvent extends Equatable {
  const ObjectDetEvent();

  @override
  List<Object> get props => [];
}

class DetectObjectEvent extends ObjectDetEvent {
  const DetectObjectEvent({required this.isState});

  final bool isState;

  @override
  List<Object> get props => [isState];
}
