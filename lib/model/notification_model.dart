import 'package:nibjobs/dal/notification_dal.dart';

class NotificationModel {
  final String? id; // Unique
  final String? notificationServiceName;
  final String? notificationServiceMessage;
  final String? notificationServiceAmount;
  final String? notificationType;
  final String? notificationServiceDate;
  final String? notificationServicePaymentMethodName;

  NotificationModel(
      {this.id,
      this.notificationServiceName,
      this.notificationServiceMessage,
      this.notificationServiceAmount,
      this.notificationType,
      this.notificationServiceDate,
      this.notificationServicePaymentMethodName});

  Map<String, dynamic> toMap() {
    return {
      NotificationDAL.ID: id,
      NotificationDAL.NOTIFICATION_SERVICE_NAME: notificationServiceName,
      NotificationDAL.NOTIFICATION_SERVICE_MESSAGE: notificationServiceMessage,
      NotificationDAL.NOTIFICATION_SERVICE_AMOUNT: notificationServiceAmount,
      NotificationDAL.NOTIFICATION_TYPE: notificationType,
      NotificationDAL.NOTIFICATION_SERVICE_DATE: notificationServiceDate,
      NotificationDAL.NOTIFICATION_SERVICE_PAYMENT_METHOD_NAME:
          notificationServicePaymentMethodName,
    };
  }
}
