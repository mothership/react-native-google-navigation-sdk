import Foundation
import UIKit

@objc(GoogleNavigationViewManager)
class GoogleNavigationViewManager: RCTViewManager {
    
    @objc override static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    func defaultFrame() -> CGRect {
        return UIScreen.main.bounds
    }
    
    override func view() -> (GoogleNavigationView) {
        return GoogleNavigationView(frame: self.defaultFrame())
    }
    
    @objc
    func setVoiceMuted(_ reactTag: NSNumber,
                voiceMuted: Bool,
                  resolver: @escaping RCTPromiseResolveBlock,
                  rejecter: @escaping RCTPromiseRejectBlock
    ) -> Void {
        DispatchQueue.main.async { [weak self] in
            if let view = self?.bridge.uiManager.view(forReactTag: reactTag), let view = view as? GoogleNavigatioView {
                view.setVoiceMuted(voiceMuted)
                resolver(nil)
            }
        }
    }
    
    @objc
    func recenter(_ reactTag: NSNumber,
                  resolver: @escaping RCTPromiseResolveBlock,
                  rejecter: @escaping RCTPromiseRejectBlock
    ) -> Void {
        DispatchQueue.main.async { [weak self] in
            if let view = self?.bridge.uiManager.view(forReactTag: reactTag), let view = view as? GoogleNavigatioView {
                view.recenter()
                resolver(nil)
            }
        }
    }
    
    @objc
    func isVoiceMuted(_ reactTag: NSNumber,
                  resolver: @escaping RCTPromiseResolveBlock,
                  rejecter: @escaping RCTPromiseRejectBlock
    ) -> Void {
        DispatchQueue.main.async { [weak self] in
            if let view = self?.bridge.uiManager.view(forReactTag: reactTag), let view = view as? GoogleNavigatioView {
                resolver(["isVoiceMuted": view.isVoiceMuted()])
            }
        }
    }
}

// MARK: - view

class GoogleNavigationView : UIView {
    
    var reactOnShowResumeButton : RCTBubblingEventBlock?
    var reactOnDidArrive : RCTBubblingEventBlock?
    var reactOnUpdateNavigationInfo : RCTBubblingEventBlock?
    
    var reactFromLatitude : Double = 0
    var reactFromLongitude : Double = 0
    var reactToLatitude : Double = 0
    var reactToLongitude : Double = 0
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public required init(frame:CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.green
    }
    
    // Properties
    
    @objc func setReactFromLatitude(_ value: Double) {
        reactFromLatitude = value
        startNavigationIfAllCoordinatesSet()
    }
    
    @objc func setReactFromLongitude(_ value: Double) {
        reactFromLongitude = value
        startNavigationIfAllCoordinatesSet()
    }
    
    @objc func setReactToLatitude(_ value: Double) {
        reactToLatitude = value
        startNavigationIfAllCoordinatesSet()
    }
    
    @objc func setReactToLongitude(_ value: Double) {
        reactToLongitude = value
        startNavigationIfAllCoordinatesSet()
    }
    
    @objc func setReactOnShowResumeButton(_ value: @escaping RCTBubblingEventBlock) {
        self.reactOnShowResumeButton = value
        // Call it like this
//        self.reactOnShowResumeButton?([
//            "showResumeButton": false
//        ])
    }

    @objc func setReactOnDidArrive(_ value: @escaping RCTBubblingEventBlock) {
        self.reactOnDidArrive = value
        // Call it like this
//        self.reactOnDidArrive?()
    }

    @objc func setReactOnUpdateNavigationInfo(_ value: @escaping RCTBubblingEventBlock) {
        self.reactOnUpdateNavigationInfo = value
        // Call it like this
//        self.reactOnUpdateNavigationInfo?([
//            "distanceRemaining": 0,
//            "durationRemaining": 0,
//        ])
    }
    
    // Methods
    
    @objc func recenter() -> Void {
        // TODO
    }
    
    @objc func setVoiceMuted(_ muted: Bool) -> Void {
        // TODO
    }
    
    @objc func isVoiceMuted() -> Bool {
        // TODO
        return false
    }
    
    // Helpers
    
    private func startNavigationIfAllCoordinatesSet() {
        if (reactFromLatitude != 0 && reactFromLongitude != 0 && reactToLatitude != 0 && reactToLongitude != 0) {
            //get directions
//            setNeedsLayout()
            // TODO
        }
    }
}
