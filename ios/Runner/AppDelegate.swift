import UIKit
import Flutter
import Firebase
import GoogleMaps
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
    [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // if #available(iOS 10.0, *) {
    //   // For iOS 10 and later, use UNUserNotificationCenter to handle notifications
    //   UNUserNotificationCenter.current().delegate = self
    //   let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    //   UNUserNotificationCenter.current().requestAuthorization(
    //     options: authOptions,
    //     completionHandler: { granted, _ in
    //       if granted {
    //         DispatchQueue.main.async {
    //           UIApplication.shared.registerForRemoteNotifications()
    //         }
    //       }
    //     }
    //   )
    // } else {
    //   // For iOS 9 and earlier, use UIUserNotificationSettings
    //   let settings: UIUserNotificationSettings =
    //     UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
    //   application.registerUserNotificationSettings(settings)
    //   application.registerForRemoteNotifications()
    // }

    GMSServices.provideAPIKey("AIzaSyAgUhHU8wSJgO5MVNy95tMT07NEjzMOfz0")
    FirebaseApp.configure()

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - UNUserNotificationCenterDelegate

  // Receive displayed notifications for iOS 10 and later
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
      _ = notification.request.content.userInfo
    // Handle the notification here

    completionHandler([.alert, .badge, .sound])
  }

  // Handle tap on notification for iOS 10 and later
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
      _ = response.notification.request.content.userInfo
    // Handle the notification response here

    completionHandler()
  }

  // MARK: - MessagingDelegate

   //override func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    // Receive Firebase Cloud Messaging registration token
    // You can send this token to your server to send push notifications to this device
  //}
}
