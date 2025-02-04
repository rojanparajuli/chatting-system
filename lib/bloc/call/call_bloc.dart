import 'package:flutter_bloc/flutter_bloc.dart';
import 'call_event.dart';
import 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  CallBloc() : super(CallInitial()) {
    on<StartCall>((event, emit) {
      emit(CallInProgress(
          chatId: event.chatId,
          callerId: event.callerId,
          receiverId: event.receiverId));
    });

    on<EndCall>((event, emit) {
      emit(CallEnded());
      emit(CallInitial());
    });
  }
}
