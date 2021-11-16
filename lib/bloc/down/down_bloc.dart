import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nibjobs/model/commerce/job.dart';

part 'down_event.dart';
part 'down_state.dart';

class DownBloc extends Bloc<DownEvent, DownState> {
  DownBloc() : super(DownInitial());

  @override
  Stream<DownState> mapEventToState(
    DownEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is DownSelectedEvent) {
      yield DownSelected(job: event.job, context: event.context);
    } else if (event is DownUnSelectedEvent) {
      yield DownInitial();
    }
  }
}
