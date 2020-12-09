import UIKit
import Flutter

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
    
  lazy var flutterEngine = FlutterEngine(name:"my flutter engine")
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    flutterEngine.run(withEntrypoint: "otherEntrypoint", libraryURI: "app_main.dart")
    GeneratedPluginRegistrant.register(with: self);
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
