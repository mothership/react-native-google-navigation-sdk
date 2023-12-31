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
    var reactOnDidLoadRoute : RCTBubblingEventBlock?
    var reactOnUpdateNavigationInfo : RCTBubblingEventBlock?

    var reactFromLatitude : Double = 0
    var reactFromLongitude : Double = 0
    var reactToLatitude : Double = 0
    var reactToLongitude : Double = 0
    var reactToPlaceId : String? = nil

    var reactShowTripProgressBar : Int = 0
    var reactShowCompassButton : Int = 0
    var reactShowTrafficLights : Int = 0
    var reactShowStopSigns : Int = 0
    var reactShowSpeedometer : Int = 0
    var reactShowSpeedLimit : Int = 0

    var navigationAlreadyStarted: Bool = false

    var gmsMapView: GMSMapView?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public required init(frame:CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white

        let mapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.gmsMapView = mapView
        mapView.delegate = self

        self.addSubview(mapView)

    }

    // React Frame

    override func reactSetFrame(_ frame: CGRect) {
        self.gmsMapView?.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        super.reactSetFrame(frame)
    }

    // Frame

    override var frame: CGRect {
        didSet {
            self.gmsMapView?.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        }
    }

    // Was added to superview

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        startNavigationIfAllCoordinatesSet()
    }

    // Properties

    @objc func setReactFromLatitude(_ value: Double) {
        reactFromLatitude = value
    }

    @objc func setReactFromLongitude(_ value: Double) {
        reactFromLongitude = value
    }

    @objc func setReactToLatitude(_ value: Double) {
        reactToLatitude = value
    }

    @objc func setReactToLongitude(_ value: Double) {
        reactToLongitude = value
    }

    @objc func setReactToPlaceId(_ value: String?) {
        reactToPlaceId = value
    }

    @objc func setReactShowTripProgressBar(_ value: Int) {
        reactShowTripProgressBar = value
        self.gmsMapView?.settings.isNavigationTripProgressBarEnabled = value != 0
    }

    @objc func setReactShowCompassButton(_ value: Int) {
        reactShowCompassButton = value
        self.gmsMapView?.settings.compassButton = value != 0
    }

    @objc func setReactShowTrafficLights(_ value: Int) {
        reactShowTrafficLights = value
        self.gmsMapView?.settings.showsTrafficLights = value != 0
    }

    @objc func setReactShowStopSigns(_ value: Int) {
        reactShowStopSigns = value
        self.gmsMapView?.settings.showsStopSigns = value != 0
    }

    @objc func setReactShowSpeedometer(_ value: Int) {
        reactShowSpeedometer = value
        self.gmsMapView?.shouldDisplaySpeedometer = value != 0
    }

    @objc func setReactShowSpeedLimit(_ value: Int) {
        reactShowSpeedLimit = value
        self.gmsMapView?.shouldDisplaySpeedLimit = value != 0
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

    @objc func setReactOnDidLoadRoute(_ value: @escaping RCTBubblingEventBlock) {
        self.reactOnDidLoadRoute = value
        // Call it like this
        //        self.reactOnDidLoadRoute?()
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
        if self.gmsMapView?.navigator?.isGuidanceActive == true {
            self.gmsMapView?.cameraMode = .following
        }

        self.reactOnShowResumeButton?([
            "showResumeButton": false
        ])
    }

    @objc func setVoiceMuted(_ muted: Bool) -> Void {
        self.gmsMapView?.navigator?.voiceGuidance = muted ? .silent : .alertsAndGuidance
    }

    @objc func isVoiceMuted() -> Bool {
        return self.gmsMapView?.navigator?.voiceGuidance == .silent
    }

    // Helpers

    private func startNavigationIfAllCoordinatesSet() {
        if (!self.navigationAlreadyStarted && self.reactFromLatitude != 0 && self.reactFromLongitude != 0 && ((self.reactToLatitude != 0 && self.reactToLongitude != 0) || self.reactToPlaceId != nil)) {
            self.navigationAlreadyStarted = true

            let camera = GMSCameraPosition.camera(withLatitude: reactFromLatitude, longitude: reactFromLongitude, zoom: 14)
            self.gmsMapView?.camera = camera
            GMSNavigationServices.showTermsAndConditionsDialogIfNeeded(
                withCompanyName: "Mothership") { termsAccepted in
                    if termsAccepted {
                        // Setup destination
                        var destinations = [GMSNavigationWaypoint]()
                        if let placeId = self.reactToPlaceId {
                            destinations.append(GMSNavigationWaypoint(placeID: placeId, title: "")!)
                        } else if self.reactToLatitude != 0 && self.reactToLongitude != 0 {
                            destinations.append(GMSNavigationWaypoint(location: CLLocationCoordinate2D(latitude: self.reactToLatitude, longitude: self.reactToLongitude), title: "")!)
                        }
                        if destinations.count == 0 {
                          return
                        }

                        // Enable navigation if the user accepts the terms.
                        self.gmsMapView?.isNavigationEnabled = true
                        self.gmsMapView?.isTrafficEnabled = true
                        self.gmsMapView?.shouldDisplaySpeedLimit = self.reactShowSpeedLimit != 0
                        self.gmsMapView?.travelMode = .driving
                        self.gmsMapView?.shouldDisplaySpeedometer = self.reactShowSpeedometer != 0

                        // UI Settings
                        self.gmsMapView?.settings.compassButton = self.reactShowCompassButton != 0
                        self.gmsMapView?.settings.isRecenterButtonEnabled = false
                        self.gmsMapView?.settings.isNavigationTripProgressBarEnabled = self.reactShowTripProgressBar != 0
                        self.gmsMapView?.settings.navigationHeaderPrimaryBackgroundColor = UIColor.black
                        self.gmsMapView?.settings.navigationHeaderSecondaryBackgroundColor = UIColor.black
                        self.gmsMapView?.settings.isNavigationFooterEnabled = false
                        self.gmsMapView?.settings.showsTrafficLights = self.reactShowTrafficLights != 0
                        self.gmsMapView?.settings.showsStopSigns = self.reactShowStopSigns != 0

                        // Configure SpeedAlertOptions
                        let minorSpeedAlertThresholdPercentage: CGFloat = 0.05
                        let majorSpeedAlertThresholdPercentage: CGFloat = 0.1
                        let severityUpgradeDurationSeconds: TimeInterval = 5
                        let mutableSpeedAlertOptions: GMSNavigationMutableSpeedAlertOptions  = GMSNavigationMutableSpeedAlertOptions()
                        mutableSpeedAlertOptions.setSpeedAlertThresholdPercentage(minorSpeedAlertThresholdPercentage, for: .minor)
                        mutableSpeedAlertOptions.setSpeedAlertThresholdPercentage(majorSpeedAlertThresholdPercentage, for: .major)
                        mutableSpeedAlertOptions.severityUpgradeDurationSeconds = severityUpgradeDurationSeconds
                        // Set SpeedAlertOptions to Navigator
                        self.gmsMapView?.navigator?.speedAlertOptions = mutableSpeedAlertOptions

                        // Navigator listener
                        self.gmsMapView?.navigator?.timeUpdateThreshold = 10
                        self.gmsMapView?.navigator?.distanceUpdateThreshold = 100
                        self.gmsMapView?.navigator?.add(self)

                        // Start navigation
                        self.gmsMapView?.navigator?.setDestinations(destinations) { routeStatus in
                            switch routeStatus {
                            case .OK:
                                self.reactOnDidLoadRoute?(nil)
                                self.gmsMapView?.navigator?.isGuidanceActive = true
                                // TODO: if you want to simulate navigation uncomment this line
                                //self.gmsMapView?.locationSimulator?.simulateLocationsAlongExistingRoute()
                                self.gmsMapView?.cameraMode = .following
                                break
                            default:
                                //error
                                break
                            }

                        }
                    }
                }
        }
    }
}

extension GoogleNavigationView: GMSNavigatorListener {

    func navigator(_ navigator: GMSNavigator, didArriveAt waypoint: GMSNavigationWaypoint) {
        self.reactOnDidArrive?(nil)
        // TODO: if you want to simulate navigation uncomment this line
        //self.gmsMapView?.locationSimulator?.stopSimulation()
    }

    func navigator(_ navigator: GMSNavigator, didUpdate navInfo: GMSNavigationNavInfo) {
        self.reactOnUpdateNavigationInfo?([
            "distanceRemaining": navInfo.distanceToFinalDestinationMeters,
            "durationRemaining": navInfo.timeToFinalDestinationSeconds,
        ])
    }
}

extension GoogleNavigationView: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if mapView.navigator?.isGuidanceActive == false { return }
        if !gesture { return }

        self.reactOnShowResumeButton?([
            "showResumeButton": true
        ])

    }
}
