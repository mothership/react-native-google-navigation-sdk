"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.NavigationView = exports.GoogleNavigationSdk = void 0;
exports.provideGoogleNavigationAPIKey = provideGoogleNavigationAPIKey;
var _reactNative = require("react-native");
var _react = require("react");
const LINKING_ERROR = `The package 'react-native-google-navigation-sdk' doesn't seem to be linked. Make sure: \n\n` + _reactNative.Platform.select({
  ios: "- You have run 'pod install'\n",
  default: ''
}) + '- You rebuilt the app after installing the package\n' + '- You are not using Expo Go\n';

// Module functions

const GoogleNavigationSdk = _reactNative.NativeModules.GoogleNavigationSdk ? _reactNative.NativeModules.GoogleNavigationSdk : new Proxy({}, {
  get() {
    throw new Error(LINKING_ERROR);
  }
});
exports.GoogleNavigationSdk = GoogleNavigationSdk;
function provideGoogleNavigationAPIKey(apiKey) {
  return GoogleNavigationSdk.provideAPIKey(apiKey);
}

// // Markers
//
// export interface WaypointMapPin {
//   coordinate: [number, number];
//   stopNumber: number;
//   style: 'complete' | 'issue' | 'next' | 'first';
// }
//
// // MapView component
//
// type GoogleMapViewProps = {
//   style?: ViewStyle;
//   // User interaction
//   scrollEnabled?: boolean;
//   // Add markers (and center map to contain all of them)
//   includeUserLocationInMapBounds?: boolean;
//   initialUserLocation?: [number, number];
//   markers?: Array<WaypointMapPin>;
//   // Padding
//   markersPaddingTop?: number;
//   markersPaddingBottom?: number;
//   markersPaddingLeft?: number;
//   markersPaddingRight?: number;
//   // Set map center manually (overriding markers bounds)
//   center?: [number, number];
//   zoom?: number;
//   // Lines
//   polyline?: string;
//   /** Whether markers should be connected by a straight line */
//   connectMarkers?: boolean;
//   // Callbacks
//   onCenterChange?: () => void;
//   onBearingChange?: () => void;
// };
//
// const GoogleMapComponentName = 'GoogleMapView';
//
// const GoogleMapView =
//   UIManager.getViewManagerConfig(GoogleMapComponentName) != null
//     ? requireNativeComponent<GoogleMapViewProps>(GoogleMapComponentName)
//     : () => {
//         throw new Error(LINKING_ERROR);
//       };
//
// export interface MapViewRefType {
//   updateCamera: (animated?: boolean) => void;
//   updateBearing: () => void;
// }
//
// export const MapView = forwardRef(
//   (props: GoogleMapViewProps, ref: Ref<MapViewRefType>): JSX.Element => {
//     // Refs
//     const viewRef = useRef(null);
//
//     useImperativeHandle(ref, () => ({ updateCamera, updateBearing }));
//
//     const _onCenterChange = (_: { nativeEvent: {} }) => {
//       if (!props.onCenterChange) {
//         return;
//       }
//       // process raw event...
//       props.onCenterChange();
//     };
//
//     const _onBearingChange = (_: { nativeEvent: {} }) => {
//       if (!props.onBearingChange) {
//         return;
//       }
//       // process raw event...
//       props.onBearingChange();
//     };
//
//     // Exposed public functions
//     const updateCamera = (animated?: boolean): void => {
//       NativeModules.GoogleMapView.updateCamera(
//         findNodeHandle(viewRef.current),
//         animated === undefined ? true : animated
//       );
//     };
//     const updateBearing = (): void => {
//       NativeModules.GoogleMapView.updateBearing(
//         findNodeHandle(viewRef.current)
//       );
//     };
//
//     return (
//       // @ts-ignore
//       <GoogleMapView
//         ref={viewRef}
//         style={props.style}
//         scrollEnabled={
//           props.scrollEnabled === undefined ? true : props.scrollEnabled
//         }
//         includeUserLocationInMapBounds={
//           props.includeUserLocationInMapBounds === undefined
//             ? false
//             : props.includeUserLocationInMapBounds
//         }
//         initialUserLocationLatitude={
//           props.initialUserLocation ? props.initialUserLocation[0] : 0
//         }
//         initialUserLocationLongitude={
//           props.initialUserLocation ? props.initialUserLocation[1] : 0
//         }
//         markers={props.markers}
//         markersPaddingTop={props.markersPaddingTop ?? 0}
//         markersPaddingBottom={props.markersPaddingBottom ?? 0}
//         markersPaddingLeft={props.markersPaddingLeft ?? 0}
//         markersPaddingRight={props.markersPaddingRight ?? 0}
//         zoom={props.zoom ? props.zoom : 0}
//         centerLatitude={props.center ? props.center[0] : 0}
//         centerLongitude={props.center ? props.center[1] : 0}
//         polyline={props.polyline}
//         connectMarkers={
//           props.connectMarkers === undefined ? false : props.connectMarkers
//         }
//         // @ts-ignore
//         onCenterChange={_onCenterChange}
//         // @ts-ignore
//         onBearingChange={_onBearingChange}
//       />
//     );
//   }
// );

// NavigationView component

const GoogleNavigationComponentName = 'GoogleNavigationView';
const GoogleNavigationView = _reactNative.UIManager.getViewManagerConfig(GoogleNavigationComponentName) != null ? (0, _reactNative.requireNativeComponent)(GoogleNavigationComponentName) : () => {
  throw new Error(LINKING_ERROR);
};
const NavigationView = /*#__PURE__*/(0, _react.forwardRef)((props, ref) => {
  // Refs
  const viewRef = (0, _react.useRef)(null);
  (0, _react.useImperativeHandle)(ref, () => ({
    isVoiceMuted,
    setVoiceMuted,
    recenter
  }));
  const _onShowResumeButton = event => {
    if (!props.onShowResumeButton) {
      return;
    }
    // process raw event...
    props.onShowResumeButton(event.nativeEvent.showResumeButton);
  };
  const _onUpdateNavigationInfo = event => {
    if (!props.onUpdateNavigationInfo) {
      return;
    }
    // process raw event...
    props.onUpdateNavigationInfo(event.nativeEvent.distanceRemaining, event.nativeEvent.durationRemaining);
  };
  const _onDidArrive = _ => {
    if (!props.onDidArrive) {
      return;
    }
    // process raw event...
    props.onDidArrive();
  };

  // Exposed public functions
  const setVoiceMuted = muted => {
    _reactNative.NativeModules.GoogleNavigationView.setVoiceMuted((0, _reactNative.findNodeHandle)(viewRef.current), muted);
  };
  const recenter = () => {
    _reactNative.NativeModules.GoogleNavigationView.recenter((0, _reactNative.findNodeHandle)(viewRef.current));
  };
  const isVoiceMuted = () => {
    return _reactNative.NativeModules.GoogleNavigationView.isVoiceMuted((0, _reactNative.findNodeHandle)(viewRef.current));
  };
  return (
    /*#__PURE__*/
    // @ts-ignore
    React.createElement(GoogleNavigationView, {
      ref: viewRef,
      style: props.style,
      fromLatitude: props.from ? props.from[0] : 0,
      fromLongitude: props.from ? props.from[1] : 0,
      toLatitude: props.to ? props.to[0] : 0,
      toLongitude: props.to ? props.to[1] : 0
      // @ts-ignore
      ,
      onShowResumeButton: _onShowResumeButton
      // @ts-ignore
      ,
      onUpdateNavigationInfo: _onUpdateNavigationInfo
      // @ts-ignore
      ,
      onDidArrive: _onDidArrive
    })
  );
});
exports.NavigationView = NavigationView;
//# sourceMappingURL=index.js.map