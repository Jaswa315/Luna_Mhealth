import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        
        //let btPlugin = btPlugin()
        let flutterViewController = window?.rootViewController as! FlutterViewController
        
        let flutterEngine = FlutterEngine(name: "uw_luna")
        flutterEngine.run()
        
        
        if let flutterEngine = flutterViewController.engine {
                    BtPlugin.register(with: flutterEngine.registrar(forPlugin: "uw_luna")!)
        }
        
        GeneratedPluginRegistrant.register(with: self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
