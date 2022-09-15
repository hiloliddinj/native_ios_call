import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        
        let batteryChannel = FlutterMethodChannel(
            name: "hilo/battery",
            binaryMessenger: controller.binaryMessenger)
        
        //      batteryChannel.setMethodCallHandler { FlutterMethodCall, @escaping FlutterResult in
        //
        //      }
        batteryChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            switch call.method {
            case "getBatteryLevel":
                let args = call.arguments as? [String: String]
                let name = args?["name"]
                print("NAME: \(name ?? "")")
                result(self.receiveBatteryLevel())
                
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func receiveBatteryLevel() -> Int {
      let device = UIDevice.current
      device.isBatteryMonitoringEnabled = true
      if device.batteryState == UIDevice.BatteryState.unknown {
          print("Battery is not available")
          return -1
      } else {
          return Int(device.batteryLevel * 100)
      }
    }
}
