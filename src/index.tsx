import {
  requireNativeComponent,
  UIManager,
  Platform,
  NativeModules,
  type ViewStyle,
  findNodeHandle,
} from 'react-native';
import {
  forwardRef,
  Ref,
  useEffect,
  useImperativeHandle,
  useRef,
  useState,
} from 'react';

const LINKING_ERROR =
  `The package 'react-native-google-navigation-sdk' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

export type GoogleNavigationOnEnableTakePictureEvent = {
  enable: boolean;
};

export type GoogleNavigationOnImageCapturedEvent = {
  imagePath: string;
};

type GoogleNavigationSdkProps = {
  style: ViewStyle;
  color: string;
  onEnableTakePicture: (enable: boolean) => void;
  onImageCaptured: (imagePath: string) => void;
};

const ComponentName = 'GoogleNavigationSdkView';

const GoogleNavigationSdkView =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<GoogleNavigationSdkProps>(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };

export interface NavigationViewRefType {
  takePicture: () => void;
}

export const NavigationView = forwardRef(
  (
    props: GoogleNavigationSdkProps,
    ref: Ref<NavigationViewRefType>
  ): JSX.Element => {
    // Refs
    const viewRef = useRef(null);

    const [enableTakePicture, setEnableTakePicture] = useState(false);

    useEffect(() => {
      props.onEnableTakePicture(enableTakePicture);
    }, [enableTakePicture, props]);

    useImperativeHandle(ref, () => ({ takePicture }));

    const _onEnableTakePicture = (event: {
      nativeEvent: GoogleNavigationOnEnableTakePictureEvent;
    }) => {
      if (!props.onEnableTakePicture) {
        return;
      }
      // process raw event...
      setEnableTakePicture(event.nativeEvent.enable);
    };

    const _onImageCaptured = (event: {
      nativeEvent: GoogleNavigationOnImageCapturedEvent;
    }) => {
      if (!props.onImageCaptured) {
        return;
      }
      // process raw event...
      props.onImageCaptured(event.nativeEvent.imagePath);
    };

    // Exposed public functions
    const takePicture = (): void => {
      NativeModules.GoogleNavigationSdkView.takePicture(
        findNodeHandle(viewRef.current)
      );
    };

    return (
      <GoogleNavigationSdkView
        ref={viewRef}
        {...props}
        // @ts-ignore
        onEnableTakePicture={_onEnableTakePicture}
        // @ts-ignore
        onImageCaptured={_onImageCaptured}
      />
    );
  }
);

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
