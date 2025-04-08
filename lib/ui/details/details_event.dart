part of 'details_bloc.dart';

@freezed
abstract class DetailsEvent with _$DetailsEvent {
  const factory DetailsEvent.fetchDetails(String id) = _FetchDetails;
}
