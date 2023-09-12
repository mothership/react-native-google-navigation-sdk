package com.googlenavigationsdk;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.pm.PackageManager;
import android.util.AttributeSet;
import android.util.Log;
import android.widget.FrameLayout;
import android.widget.Toast;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.fragment.app.FragmentActivity;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.facebook.react.bridge.Arguments;

import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.FollowMyLocationOptions;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.libraries.navigation.ArrivalEvent;
import com.google.android.libraries.navigation.DisplayOptions;
import com.google.android.libraries.navigation.ForceNightMode;
import com.google.android.libraries.navigation.ListenableResultFuture;
import com.google.android.libraries.navigation.NavigationApi;
import com.google.android.libraries.navigation.NavigationView;
import com.google.android.libraries.navigation.Navigator;
import com.google.android.libraries.navigation.RoutingOptions;
import com.google.android.libraries.navigation.SpeedAlertOptions;
import com.google.android.libraries.navigation.SpeedAlertSeverity;
import com.google.android.libraries.navigation.StylingOptions;
import com.google.android.libraries.navigation.Waypoint;

public class GoogleNavigationView extends FrameLayout {

  private NavigationView navigationView = null;
  private GoogleMap mGoogleMap;
  private Navigator mNavigator = null;
  private RoutingOptions mRoutingOptions = null;
  private DisplayOptions mDisplayOptions = null;

  private double fromLatitude = 0;
  private double fromLongitude = 0;
  private double toLatitude = 0;
  private double toLongitude = 0;
  private boolean navigationAlreadyAdded = false;
  private boolean navigationAlreadyStarted = false;
  private int audioGuidance = Navigator.AudioGuidance.VOICE_ALERTS_AND_GUIDANCE;
  private Navigator.RemainingTimeOrDistanceChangedListener remainingTimeOrDistanceChangedListener = null;
  private Navigator.ArrivalListener arrivalListener = null;

  private static final int BLACK_COLOR = 0xFF000000;

  private ReactContext mReactContext = null;

  public GoogleNavigationView(@NonNull ReactContext reactContext) {
    super(reactContext);
    mReactContext = reactContext;
    addSubview(reactContext);
  }

  private void addSubview(Context context) {
    navigationView = new NavigationView(context);
    addView(navigationView, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
    navigationView.onCreate(null);
  }

  public void setFromLatitude(double fromLatitude) {
    this.fromLatitude = fromLatitude;
  }

  public void setFromLongitude(double fromLongitude) {
    this.fromLongitude = fromLongitude;
  }

  public void setToLatitude(double toLatitude) {
    this.toLatitude = toLatitude;
  }

  public void setToLongitude(double toLongitude) {
    this.toLongitude = toLongitude;
  }

  public void setVoiceMuted(boolean voiceMuted) {
    audioGuidance = voiceMuted ? Navigator.AudioGuidance.SILENT : Navigator.AudioGuidance.VOICE_ALERTS_AND_GUIDANCE;
    if (mNavigator != null &&  mNavigator.isGuidanceRunning()) {
      mNavigator.setAudioGuidance(audioGuidance);
    }
  }

  public boolean isVoiceMuted() {
    if (mNavigator != null) {
      // TODO not able to get current setting
      return false;
    }
    return false;
  }

  public void recenter() {
    if (mGoogleMap != null) {
      mGoogleMap.followMyLocation(GoogleMap.CameraPerspective.TILTED);
      sendShowResumeButton(false);
    }
  }

  @Override
  protected void onDetachedFromWindow() {
    super.onDetachedFromWindow();

    navigationView.onStop();
    navigationView.onDestroy();

    if (mNavigator != null) {
      mNavigator.stopGuidance();

      if (arrivalListener != null) {
        mNavigator.removeArrivalListener(arrivalListener);
      }
      if (remainingTimeOrDistanceChangedListener != null) {
        mNavigator.removeRemainingTimeOrDistanceChangedListener(remainingTimeOrDistanceChangedListener);
      }

      //mNavigator.getSimulator().unsetUserLocation();
      mNavigator.cleanup();
    }
  }

  @Override
  protected void onAttachedToWindow() {
    super.onAttachedToWindow();

    navigationView.onStart();
    startNavigationIfAllCoordinatesSet();
  }

  private void sendShowResumeButton(boolean showResumeButton) {
      WritableMap event = Arguments.createMap();
      event.putBoolean("showResumeButton", showResumeButton);
      mReactContext
              .getJSModule(RCTEventEmitter.class)
              .receiveEvent(getId(), "showResumeButton", event);
  }

  private void sendArrivalEvent() {
    WritableMap event = Arguments.createMap();
    mReactContext
      .getJSModule(RCTEventEmitter.class)
      .receiveEvent(getId(), "didArrive", event);
  }

  private void sendCurrentNavigationInfo() {
    WritableMap event = Arguments.createMap();
    event.putDouble("distanceRemaining", (double)mNavigator.getCurrentTimeAndDistance().getMeters());
    event.putDouble("durationRemaining", (double)mNavigator.getCurrentTimeAndDistance().getSeconds());
    mReactContext
      .getJSModule(RCTEventEmitter.class)
      .receiveEvent(getId(), "updateNavigationInfo", event);
  }

  private void startNavigationIfAllCoordinatesSet() {
    if (navigationAlreadyStarted || fromLatitude == 0 || fromLongitude == 0 || toLatitude == 0 || toLongitude == 0) {
      return;
    }

    FragmentActivity activity = (FragmentActivity) mReactContext.getCurrentActivity();
    if (activity == null) {
      return;
    }

    navigationAlreadyStarted = true;

    NavigationApi.getNavigator(activity, new NavigationApi.NavigatorListener() {
      /**
       * Sets up the navigation UI when the navigator is ready for use.
       */
      @Override
      public void onNavigatorReady(Navigator navigator) {
        mNavigator = navigator;

        // Follow user
        navigationView.getMapAsync(new OnMapReadyCallback() {
          @SuppressLint("MissingPermission")
          @Override
          public void onMapReady(GoogleMap googleMap) {
            mGoogleMap = googleMap;
            googleMap.setTrafficEnabled(true);
            googleMap.followMyLocation(GoogleMap.CameraPerspective.TILTED);
            googleMap.setOnCameraMoveStartedListener(new GoogleMap.OnCameraMoveStartedListener() {
                @Override
                public void onCameraMoveStarted(int reason) {
                    if (reason == GoogleMap.OnCameraMoveStartedListener.REASON_GESTURE) {
                        sendShowResumeButton(true);
                    }
                }
            });
          }
        });

        // UI settings
        navigationView.setNavigationUiEnabled(true);
        navigationView.setHeaderEnabled(true);
        navigationView.setEtaCardEnabled(false);
        navigationView.setRecenterButtonEnabled(false);
        navigationView.setSpeedLimitIconEnabled(false);
        navigationView.setSpeedometerEnabled(true);
        navigationView.setTripProgressBarEnabled(true);
//        navigationView.setTrafficIncidentCardsEnabled(true);
//        navigationView.setTrafficPromptsEnabled(true);
        navigationView.setForceNightMode(ForceNightMode.FORCE_DAY);
       navigationView.setStylingOptions(new StylingOptions()
         .primaryDayModeThemeColor(BLACK_COLOR)
         .primaryNightModeThemeColor(BLACK_COLOR)
         .secondaryDayModeThemeColor(BLACK_COLOR)
         .secondaryNightModeThemeColor(BLACK_COLOR));

        // Setup SpeedAlertOptions
        mNavigator.setSpeedAlertOptions(new SpeedAlertOptions.Builder()
          .setSpeedAlertThresholdPercentage(SpeedAlertSeverity.MINOR, 5.0f)
          .setSpeedAlertThresholdPercentage(SpeedAlertSeverity.MAJOR, 10.0f)
          .setSeverityUpgradeDurationSeconds(5)
          .build());

        // Add listeners
        remainingTimeOrDistanceChangedListener = new Navigator.RemainingTimeOrDistanceChangedListener() {
          @Override
          public void onRemainingTimeOrDistanceChanged() {
            // send event
            sendCurrentNavigationInfo();
          }
        };
        arrivalListener = new Navigator.ArrivalListener() {
          @Override
          public void onArrival(ArrivalEvent arrivalEvent) {
            if (arrivalEvent.isFinalDestination()) {
              mNavigator.stopGuidance();

              // Stop simulating vehicle movement.
              //mNavigator.getSimulator().unsetUserLocation();

              // send event
              sendArrivalEvent();
            }
          }
        };
        mNavigator.addArrivalListener(arrivalListener);
        mNavigator.addRemainingTimeOrDistanceChangedListener(10, 100, remainingTimeOrDistanceChangedListener);

        // Set the last digit of the car's license plate to get route restrictions
        // in supported countries. (optional)
        // mNavigator.setLicensePlateRestrictionInfo(12, "US");

        // Set the travel mode (DRIVING, WALKING, CYCLING, TWO_WHEELER, or TAXI).
        mRoutingOptions =  new RoutingOptions();
        mRoutingOptions = mRoutingOptions.travelMode(RoutingOptions.TravelMode.DRIVING);

        mDisplayOptions =
          new DisplayOptions().showTrafficLights(true).showStopSigns(true);

        // Navigate to the location
        ListenableResultFuture<Navigator.RouteStatus> result = mNavigator.setDestination(Waypoint.builder().setLatLng(
          toLatitude, toLongitude
        ).build(), mRoutingOptions, mDisplayOptions);
        result.setOnResultListener(new ListenableResultFuture.OnResultListener<Navigator.RouteStatus>() {
          @Override
          public void onResult(Navigator.RouteStatus routeStatus) {
            if (routeStatus == Navigator.RouteStatus.OK) {
              // Audio guidance
              mNavigator.setAudioGuidance(Navigator.AudioGuidance.VOICE_ALERTS_AND_GUIDANCE);

              //mNavigator.getSimulator().simulateLocationsAlongExistingRoute();

              mNavigator.startGuidance();
            }
          }
        });
      }

      /**
       * Handles errors from the Navigation SDK.
       * @param errorCode The error code returned by the navigator.
       */
      @Override
      public void onError(@NavigationApi.ErrorCode int errorCode) {
        Log.e("GoogleNavigationView", "Error loading Google Navigation View: " + errorCode);
      }
    });
  }
}
