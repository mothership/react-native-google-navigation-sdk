import Foundation
import UIKit
import GoogleMaps
import GoogleNavigation

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
            if let view = self?.bridge.uiManager.view(forReactTag: reactTag), let view = view as? GoogleNavigationView {
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
            if let view = self?.bridge.uiManager.view(forReactTag: reactTag), let view = view as? GoogleNavigationView {
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
            if let view = self?.bridge.uiManager.view(forReactTag: reactTag), let view = view as? GoogleNavigationView {
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

    var gmsMapView: GMSMapView?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public required init(frame:CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white

        let mapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.gmsMapView = mapView

        self.addSubview(mapView)

    }

    // Frame

    override var frame: CGRect {
        didSet {
            self.gmsMapView?.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        }
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
        print("Lat \(self.reactFromLatitude) Lng \(self.reactFromLongitude) Lat \(self.reactToLatitude) Lng \(self.reactToLongitude)")
        if (self.reactFromLatitude != 0 && self.reactFromLongitude != 0 && self.reactToLatitude != 0 && self.reactToLongitude != 0) {


            let camera = GMSCameraPosition.camera(withLatitude: reactFromLatitude, longitude: reactFromLongitude, zoom: 14)
            self.gmsMapView?.camera = camera
            GMSNavigationServices.showTermsAndConditionsDialogIfNeeded(
                withCompanyName: "Mothership") { termsAccepted in
                    if termsAccepted {
                        // Enable navigation if the user accepts the terms.
                        self.gmsMapView?.isNavigationEnabled = true
                        self.gmsMapView?.settings.compassButton = true
                        self.gmsMapView?.travelMode = .driving

                        var destinations = [GMSNavigationWaypoint]()
//                        destinations.append(GMSNavigationWaypoint(location: CLLocationCoordinate2D(latitude: self.reactFromLatitude, longitude: self.reactFromLongitude), title: "")!)
                        destinations.append(GMSNavigationWaypoint(location: CLLocationCoordinate2D(latitude: self.reactToLatitude, longitude: self.reactToLongitude), title: "")!)

                        self.gmsMapView?.navigator?.setDestinations(destinations) { routeStatus in
                            self.gmsMapView?.navigator?.isGuidanceActive = true
                            self.gmsMapView?.locationSimulator?.simulateLocationsAlongExistingRoute()
                            self.gmsMapView?.cameraMode = .following
                        }
                    } else {
                        // Handle the case when the user rejects the terms and conditions.
                    }
                }
        }
    }
}
