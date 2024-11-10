part of 'object_det_bloc.dart';

sealed class ObjectDetState extends Equatable {
  const ObjectDetState();

  @override
  List<Object> get props => [];
}

final class ObjectDetInitial extends ObjectDetState {}

class DetectObjectState extends ObjectDetState {
  const DetectObjectState();
}
