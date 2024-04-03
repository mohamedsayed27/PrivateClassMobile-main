part of 'notification_cubit.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class GetGroupState extends NotificationState {}

class NotificationLoadingState extends NotificationState {}

class NotificationSuccessState extends NotificationState {}

class NotificationFailureState extends NotificationState {}

class DeletingOneNotificationSuccessState extends NotificationState {}
