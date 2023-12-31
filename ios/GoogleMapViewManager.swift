//import Foundation
//import UIKit
//import GoogleMaps
//
//@objc(GoogleMapViewManager)
//class GoogleMapViewManager: RCTViewManager {
//
//    @objc override static func requiresMainQueueSetup() -> Bool {
//        return true
//    }
//
//    func defaultFrame() -> CGRect {
//        return UIScreen.main.bounds
//    }
//
//    override func view() -> (GoogleMapView) {
//        return GoogleMapView(frame: self.defaultFrame())
//    }
//
//    @objc
//    func updateCamera(_ reactTag: NSNumber,
//                animated: Bool,
//                  resolver: @escaping RCTPromiseResolveBlock,
//                  rejecter: @escaping RCTPromiseRejectBlock
//    ) -> Void {
//        DispatchQueue.main.async { [weak self] in
//            if let view = self?.bridge.uiManager.view(forReactTag: reactTag), let view = view as? GoogleMapView {
//                view.updateCamera(animated)
//                resolver(nil)
//            }
//        }
//    }
//
//    @objc
//    func updateBearing(_ reactTag: NSNumber,
//                  resolver: @escaping RCTPromiseResolveBlock,
//                  rejecter: @escaping RCTPromiseRejectBlock
//    ) -> Void {
//        DispatchQueue.main.async { [weak self] in
//            if let view = self?.bridge.uiManager.view(forReactTag: reactTag), let view = view as? GoogleMapView {
//                view.updateBearing()
//                resolver(nil)
//            }
//        }
//    }
//}
//
//// MARK: - view
//
//class GoogleMapView : UIView {
//
//    var reactScrollEnabled: NSNumber = NSNumber(true)
//
//    var reactMarkers: NSArray?
//
//    var reactMarkersPaddingTop: Int = 0
//    var reactMarkersPaddingBottom: Int = 0
//    var reactMarkersPaddingLeft: Int = 0
//    var reactMarkersPaddingRight: Int = 0
//
//    var reactZoom : Int = 0
//    var reactCenterLatitude : Double = 0
//    var reactCenterLongitude : Double = 0
//
//    var reactIncludeUserLocationInMapBounds: NSNumber = NSNumber(false)
//    var reactInitialUserLocationLatitude : Double = 0
//    var reactInitialUserLocationLongitude : Double = 0
//
//    var reactPolyline: NSString?
//    var reactConnectMarkers: NSNumber = NSNumber(false)
//
//    var reactOnCenterChange : RCTBubblingEventBlock?
//    var reactOnBearingChange : RCTBubblingEventBlock?
//
//    var gmsMapView: GMSMapView?
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override public required init(frame:CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = UIColor.white
//
//        let mapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
//        self.gmsMapView = mapView
//
//        self.addSubview(mapView)
//
//    }
//
//    // Frame
//
//    override var frame: CGRect {
//        didSet {
//            self.gmsMapView?.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
//        }
//    }
//
//    // Properties
//
//    @objc func setReactScrollEnabled(_ value: NSNumber) {
//        reactScrollEnabled = value
//    }
//
//    @objc func setReactMarkers(_ value: NSArray?) {
//        reactMarkers = value
//        updateCameraIfCenterCoordinateAndZoomSet()
//    }
//
//    @objc func setReactMarkersPaddingTop(_ value: Int) {
//        reactMarkersPaddingTop = value
//        updateCameraIfCenterCoordinateAndZoomSet()
//    }
//
//    @objc func setReactMarkersPaddingBottom(_ value: Int) {
//        reactMarkersPaddingBottom = value
//        updateCameraIfCenterCoordinateAndZoomSet()
//    }
//
//    @objc func setReactMarkersPaddingLeft(_ value: Int) {
//        reactMarkersPaddingLeft = value
//        updateCameraIfCenterCoordinateAndZoomSet()
//    }
//
//    @objc func setReactMarkersPaddingRight(_ value: Int) {
//        reactMarkersPaddingRight = value
//        updateCameraIfCenterCoordinateAndZoomSet()
//    }
//
//    @objc func setReactZoom(_ value: Int) {
//        reactZoom = value
//        updateCameraIfCenterCoordinateAndZoomSet()
//    }
//
//    @objc func setReactCenterLatitude(_ value: Double) {
//        reactCenterLatitude = value
//        updateCameraIfCenterCoordinateAndZoomSet()
//    }
//
//    @objc func setReactCenterLongitude(_ value: Double) {
//        reactCenterLongitude = value
//        updateCameraIfCenterCoordinateAndZoomSet()
//    }
//
//    @objc func setReactIncludeUserLocationInMapBounds(_ value: NSNumber) {
//        reactIncludeUserLocationInMapBounds = value
//        updateCameraIfCenterCoordinateAndZoomSet()
//    }
//
//    @objc func setReactInitialUserLocationLatitude(_ value: Double) {
//        reactInitialUserLocationLatitude = value
//        updateCameraIfCenterCoordinateAndZoomSet()
//    }
//
//    @objc func setReactInitialUserLocationLongitude(_ value: Double) {
//        reactInitialUserLocationLongitude = value
//        updateCameraIfCenterCoordinateAndZoomSet()
//    }
//
//    @objc func setReactPolyline(_ value: NSString?) {
//        reactPolyline = value
//        updateCameraIfCenterCoordinateAndZoomSet()
//    }
//
//    @objc func setReactConnectMarkers(_ value: NSNumber) {
//        reactConnectMarkers = value
//        updateCameraIfCenterCoordinateAndZoomSet()
//    }
//
//    @objc func setReactOnCenterChange(_ value: @escaping RCTBubblingEventBlock) {
//        self.reactOnCenterChange = value
//        // Call it like this
////        self.reactOnCenterChange?()
//    }
//
//    @objc func setReactOnBearingChange(_ value: @escaping RCTBubblingEventBlock) {
//        self.reactOnBearingChange = value
//        // Call it like this
////        self.reactOnBearingChange?()
//    }
//
//    // Methods
//
//    @objc func updateCamera(_ animated: Bool) -> Void {
//        // TODO
//    }
//
//    @objc func updateBearing() -> Void {
//        // TODO
//    }
//
//    // Helpers
//
//    private func updateCameraIfCenterCoordinateAndZoomSet() {
//        if (self.reactCenterLatitude != 0 && self.reactCenterLongitude != 0 && self.reactZoom != 0) {
//            //zoom the map to a place that contains all the markers already set to the view props
//            let camera = GMSCameraPosition.camera(withLatitude: self.reactCenterLatitude, longitude: self.reactCenterLongitude, zoom: Float(self.reactZoom))
//            self.gmsMapView?.camera = camera
//        }
//    }
//}
