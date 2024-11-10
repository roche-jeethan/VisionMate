import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'object_det_event.dart';
part 'object_det_state.dart';

class ObjectDetBloc extends Bloc<ObjectDetEvent, ObjectDetState> {
  ObjectDetBloc() : super(ObjectDetInitial()) {
    on<DetectObjectEvent>(_onDetectObject);
  }

  Future<void> _onDetectObject(
      DetectObjectEvent event, Emitter<ObjectDetState> emit) async {
    // Toggle between states based on the event's isState flag
    if (event.isState) {
      emit(const DetectObjectState());
    } else {
      emit(ObjectDetInitial());
    }
  }
}
