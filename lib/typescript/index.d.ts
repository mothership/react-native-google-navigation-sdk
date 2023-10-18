/// <reference types="react" />
import { type ViewStyle } from 'react-native';
export declare const GoogleNavigationSdk: any;
export declare function provideGoogleNavigationAPIKey(apiKey: string): Promise<void>;
export type GoogleNavigationOnShowResumeButtonEvent = {
    showResumeButton: boolean;
};
export type GoogleNavigationOnUpdateNavigationInfoEvent = {
    distanceRemaining: number;
    durationRemaining: number;
};
type GoogleNavigationViewProps = {
    style?: ViewStyle;
    from?: [number, number];
    to?: [number, number];
    showTripProgressBar?: boolean;
    showCompassButton?: boolean;
    showTrafficLights?: boolean;
    showStopSigns?: boolean;
    showSpeedometer?: boolean;
    showSpeedLimit?: boolean;
    onShowResumeButton?: (showResumeButton: boolean) => void;
    onDidArrive?: () => void;
    onDidLoadRoute?: () => void;
    onUpdateNavigationInfo?: (distanceRemaining: number, durationRemaining: number) => void;
};
export interface NavigationViewRefType {
    isVoiceMuted: () => Promise<{
        isVoiceMuted: boolean;
    }>;
    setVoiceMuted: (muted: boolean) => void;
    recenter: () => void;
}
export declare const NavigationView: import("react").ForwardRefExoticComponent<GoogleNavigationViewProps & import("react").RefAttributes<NavigationViewRefType>>;
export {};
//# sourceMappingURL=index.d.ts.map