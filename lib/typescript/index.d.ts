export declare const GoogleNavigationSdk: any;
export declare function provideGoogleNavigationAPIKey(apiKey: string): Promise<void>;
export type GoogleNavigationOnShowResumeButtonEvent = {
    showResumeButton: boolean;
};
export type GoogleNavigationOnUpdateNavigationInfoEvent = {
    distanceRemaining: number;
    durationRemaining: number;
};
export interface NavigationViewRefType {
    isVoiceMuted: () => Promise<{
        isVoiceMuted: boolean;
    }>;
    setVoiceMuted: (muted: boolean) => void;
    recenter: () => void;
}
export declare const NavigationView: any;
//# sourceMappingURL=index.d.ts.map