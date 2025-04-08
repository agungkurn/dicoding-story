part of 'details_bloc.dart';

@freezed
class DetailsState with _$DetailsState {
  const factory DetailsState.idle() = _Idle;

  const factory DetailsState.loading() = DetailsLoading;

  const factory DetailsState.success(Story story) = DetailsSuccess;

  const factory DetailsState.error(String? message) = DetailsError;
}
