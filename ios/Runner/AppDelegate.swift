import Flutter
import UIKit
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let audioChannel = FlutterMethodChannel(name: "com.example.audio",
                                            binaryMessenger: controller.binaryMessenger)
    
    audioChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "setVoiceChatMode" {
        self.setVoiceChatMode(result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func setVoiceChatMode(result: FlutterResult) {
    do {
      let session = AVAudioSession.sharedInstance()
      try session.setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetooth])
      try session.setMode(.voiceChat)
      try session.setActive(true)
      result(nil) // Indicate success
    } catch {
      result(FlutterError(code: "AUDIO_SESSION_ERROR",
                          message: "Failed to set audio session mode",
                          details: error.localizedDescription))
    }
  }
}
