
typealias RCTBubblingEventBlock = (Dictionary<String, Any>) -> Void

@objc(GoogleNavigationSdkViewManager)
class GoogleNavigationSdkViewManager: RCTViewManager {
    
    @objc override static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    func defaultFrame() -> CGRect {
        return UIScreen.main.bounds
    }
    
    override func view() -> (GoogleNavigationSdkView) {
        return GoogleNavigationSdkView(frame: self.defaultFrame())
    }
    
    @objc func takePicture(_ reactTag: NSNumber) -> Void {
        DispatchQueue.main.async { [weak self] in
            if let view = self?.bridge.uiManager.view(forReactTag: reactTag), let view = view as? GoogleNavigationSdkView {
                view.takePicture()
            }
        }
    }
    
    //  @objc func testMethod(_ tag: Int, _ value: String) {
    //    print("testMethod: tag -> \(tag), value -> \(value)")
    //  }
}

class GoogleNavigationSdkView : UIView {
    
    override public required init(frame:CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    func hexStringToUIColor(hexColor: String) -> UIColor {
        let stringScanner = Scanner(string: hexColor)
        
        if(hexColor.hasPrefix("#")) {
            stringScanner.scanLocation = 1
        }
        var color: UInt32 = 0
        stringScanner.scanHexInt32(&color)
        
        let r = CGFloat(Int(color >> 16) & 0x000000FF)
        let g = CGFloat(Int(color >> 8) & 0x000000FF)
        let b = CGFloat(Int(color) & 0x000000FF)
        
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
    }
    
    // Properties
    
    @objc var reactColor: String = "" {
        didSet {
            self.backgroundColor = hexStringToUIColor(hexColor: color)
        }
    }
    
    var reactOnImageCaptured: RCTBubblingEventBlock?
    
    @objc func setReactOnImageCaptured(_ value: @escaping RCTBubblingEventBlock) {
        self.reactOnImageCaptured = value
        self.controller?.reactOnImageCaptured = value
    }
    
    var reactOnEnableTakePicture: RCTBubblingEventBlock?
    
    @objc func setReactOnEnableTakePicture(_ value: @escaping RCTBubblingEventBlock) {
        self.reactOnEnableTakePicture = value
        self.controller?.reactOnImageCaptured = value
    }
    
    // Methods
    
    @objc func takePicture() {
        self.controller?.takePhoto()
    }
}
