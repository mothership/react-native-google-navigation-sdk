import {
  requireNativeComponent,
  UIManager,
  Platform,
  NativeModules,
  type ViewStyle,
  findNodeHandle,
} from 'react-native';
import { forwardRef, type Ref, useImperativeHandle, useRef } from 'react';

const LINKING_ERROR =
  `The package 'react-native-google-navigation-sdk' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

// Module functions

export const GoogleNavigationSdk = NativeModules.GoogleNavigationSdk
  ? NativeModules.GoogleNavigationSdk
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function provideGoogleNavigationAPIKey(apiKey: string): Promise<void> {
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

export type GoogleNavigationOnShowResumeButtonEvent = {
  showResumeButton: boolean;
};

export type GoogleNavigationOnUpdateNavigationInfoEvent = {
  distanceRemaining: number;
  durationRemaining: number;
};

type GoogleNavigationViewProps = {
  style?: ViewStyle;
  // Locations
  from?: [number, number];
  toCoordinate?: [number, number];
  toPlaceId?: string;
  // UI settings
  showTripProgressBar?: boolean;
  showCompassButton?: boolean;
  showTrafficLights?: boolean;
  showStopSigns?: boolean;
  showSpeedometer?: boolean;
  showSpeedLimit?: boolean;
  // Callbacks
  onShowResumeButton?: (showResumeButton: boolean) => void;
  onDidArrive?: () => void;
  onDidLoadRoute?: () => void;
  onUpdateNavigationInfo?: (
    distanceRemaining: number,
    durationRemaining: number
  ) => void;
};

const GoogleNavigationComponentName = 'GoogleNavigationView';

const GoogleNavigationView =
  UIManager.getViewManagerConfig(GoogleNavigationComponentName) != null
    ? requireNativeComponent<GoogleNavigationViewProps>(
        GoogleNavigationComponentName
      )
    : () => {
        throw new Error(LINKING_ERROR);
      };

export interface NavigationViewRefType {
  isVoiceMuted: () => Promise<{ isVoiceMuted: boolean }>;
  setVoiceMuted: (muted: boolean) => void;
  recenter: () => void;
}

export const NavigationView = forwardRef(
  (
    props: GoogleNavigationViewProps,
    ref: Ref<NavigationViewRefType>
  ): JSX.Element => {
    // Refs
    const viewRef = useRef(null);

    useImperativeHandle(ref, () => ({ isVoiceMuted, setVoiceMuted, recenter }));

    const _onShowResumeButton = (event: {
      nativeEvent: GoogleNavigationOnShowResumeButtonEvent;
    }) => {
      if (!props.onShowResumeButton) {
        return;
      }
      // process raw event...
      props.onShowResumeButton(event.nativeEvent.showResumeButton);
    };

    const _onUpdateNavigationInfo = (event: {
      nativeEvent: GoogleNavigationOnUpdateNavigationInfoEvent;
    }) => {
      if (!props.onUpdateNavigationInfo) {
        return;
      }
      // process raw event...
      props.onUpdateNavigationInfo(
        event.nativeEvent.distanceRemaining,
        event.nativeEvent.durationRemaining
      );
    };

    const _onDidArrive = (_: { nativeEvent: {} }) => {
      if (!props.onDidArrive) {
        return;
      }
      // process raw event...
      props.onDidArrive();
    };

    const _onDidLoadRoute = (_: { nativeEvent: {} }) => {
      if (!props.onDidLoadRoute) {
        return;
      }
      // process raw event...
      props.onDidLoadRoute();
    };

    // Exposed public functions
    const setVoiceMuted = (muted: boolean): void => {
      NativeModules.GoogleNavigationView.setVoiceMuted(
        findNodeHandle(viewRef.current),
        muted
      );
    };
    const recenter = (): void => {
      NativeModules.GoogleNavigationView.recenter(findNodeHandle(viewRef.current));
    };
    const isVoiceMuted = (): Promise<{ isVoiceMuted: boolean }> => {
      return NativeModules.GoogleNavigationView.isVoiceMuted(
        findNodeHandle(viewRef.current)
      );
    };

    return (
      // @ts-ignore
      <GoogleNavigationView
        ref={viewRef}
        style={props.style}
        fromLatitude={props.from ? props.from[0] : 0}
        fromLongitude={props.from ? props.from[1] : 0}
        toLatitude={props.toCoordinate ? props.toCoordinate[0] : 0}
        toLongitude={props.toCoordinate ? props.toCoordinate[1] : 0}
        toPlaceId={props.toPlaceId}
        showTripProgressBar={
          props.showTripProgressBar === undefined ? true : props.showTripProgressBar
        }
        showCompassButton={
          props.showCompassButton === undefined ? true : props.showCompassButton
        }
        showTrafficLights={
          props.showTrafficLights === undefined ? true : props.showTrafficLights
        }
        showStopSigns={
          props.showStopSigns === undefined ? true : props.showStopSigns
        }
        showSpeedometer={
          props.showSpeedometer === undefined ? true : props.showSpeedometer
        }
        showSpeedLimit={
          props.showSpeedLimit === undefined ? true : props.showSpeedLimit
        }
        // @ts-ignore
        onShowResumeButton={_onShowResumeButton}
        // @ts-ignore
        onUpdateNavigationInfo={_onUpdateNavigationInfo}
        // @ts-ignore
        onDidArrive={_onDidArrive}
        // @ts-ignore
        onDidLoadRoute={_onDidLoadRoute}
      />
    );
  }
);
