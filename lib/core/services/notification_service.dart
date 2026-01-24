import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<bool> _requestPermission() async {
    final ios = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final android = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final bool? iosResult = await ios?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    final bool? androidResult = await android?.requestNotificationsPermission();

    return (iosResult ?? false) || (androidResult ?? false);
  }

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          defaultPresentAlert: true,
          defaultPresentBadge: true,
          defaultPresentSound: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    if (await _requestPermission()) {
      await _notifications.initialize(settings);
    }
  }

  static Future<void> show({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'save_channel',
          'Сохранения',
          channelDescription: 'Уведомления о сохранении рисунков',
          importance: Importance.max,
          priority: Priority.high,
          largeIcon: DrawableResourceAndroidBitmap('ic_launcher_foreground'),
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      presentBanner: true,
      presentList: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    
    await _notifications.show(id, title, body, details);
  }
}
