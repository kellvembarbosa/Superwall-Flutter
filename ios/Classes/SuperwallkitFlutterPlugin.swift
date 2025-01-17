import Flutter
import UIKit
import SuperwallKit


public class SuperwallkitFlutterPlugin: NSObject, FlutterPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {
    BridgingCreator.register(with: registrar)

    // TODO: REMOVE THIS

    // Define the list of plugin types that conform to FlutterPlugin.
    // Make sure each plugin type conforms to `FlutterPlugin`.
    // Add additional classes using Xcode, not Android Studio.
    let pluginTypes: [FlutterPlugin.Type] = [
      SubscriptionStatusBridge.self,
      LogLevelBridge.self,
      PaywallInfoBridge.self,
      PurchaseResultBridge.self,
      RestorationResultBridge.self
    ]

    // Iterate over the plugin types and call the `register(with:)` method on each one.
    pluginTypes.forEach { pluginType in
      pluginType.register(with: registrar)
    }
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result(FlutterMethodNotImplemented)
  }
}

extension FlutterMethodCall {
  func argument<T>(for key: String) -> T? {
    return (arguments as? [String: Any])?[key] as? T
  }

  // Make sure to provide the key here.
  func bridge<T>(for key: String) -> T? {
    guard let channelName: String = argument(for: key) else {
      print("WARNING: Unable to find bridge argument for \(key)")
      return nil
    }
    return BridgingCreator.shared.bridge(for: channelName)
  }
}

extension FlutterMethodCall {
  var badArgs: FlutterError {
    return FlutterError(code: "BAD_ARGS", message: "Missing or invalid arguments for '\(method)'", details: nil)
  }
}

extension FlutterMethodChannel {
  func invokeMethod(_ method: String, arguments: Any? = nil) async -> Any? {
    return await withCheckedContinuation { continuation in
      invokeMethod(method, arguments: arguments) { result in
        continuation.resume(returning: result)
      }
    }
  }
}

// TODO: Remove
extension FlutterError {
  static func badArgs(for method: String) -> FlutterError {
    return FlutterError(code: "BAD_ARGS", message: "Missing or invalid arguments for '\(method)'", details: nil)
  }
}
