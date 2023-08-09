// import GoogleMaps
// import GoogleNavigation

typealias RCTBubblingEventBlock = (Dictionary<String, Any>) -> Void

@objc(GoogleNavigationSdk)
class GoogleNavigationSdk: NSObject {

    @objc(provideAPIKey:withResolver:withRejecter:)
    func provideAPIKey(apiKey: String, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
//         GMSServices.provideAPIKey(apiKey)
        resolve()

    }
}
