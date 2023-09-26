package com.googlenavigationsdk;

import android.graphics.Color;
import android.view.View;

import androidx.annotation.NonNull;

import com.facebook.react.uimanager.UIManagerModule;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.Promise;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.UiThreadUtil;

import com.google.android.libraries.navigation.NavigationView;

import java.util.Map;

public class GoogleNavigationViewManager extends SimpleViewManager<GoogleNavigationView> {
  public static final String REACT_CLASS = "GoogleNavigationView";

  private ReactApplicationContext mReactContext;

  public GoogleNavigationViewManager(ReactApplicationContext reactContext) {
    mReactContext = reactContext;
  }

  @Override
  @NonNull
  public String getName() {
    return REACT_CLASS;
  }

  @Override
  public Map getExportedCustomBubblingEventTypeConstants() {
    return MapBuilder.builder().put(
      "showResumeButton",
      MapBuilder.of(
        "phasedRegistrationNames",
        MapBuilder.of("bubbled", "onShowResumeButton", "captured", "onShowResumeButtonCapture")
      )).put(
      "didArrive",
      MapBuilder.of(
        "phasedRegistrationNames",
        MapBuilder.of("bubbled", "onDidArrive", "captured", "onDidArriveCapture")
      )).put(
      "didLoadRoute",
      MapBuilder.of(
        "phasedRegistrationNames",
        MapBuilder.of("bubbled", "onDidLoadRoute", "captured", "onDidLoadRouteCapture")
      )).put(
      "updateNavigationInfo",
      MapBuilder.of(
        "phasedRegistrationNames",
        MapBuilder.of("bubbled", "onUpdateNavigationInfo", "captured", "onUpdateNavigationInfoCapture")
      )).build();
  }

  @Override
  @NonNull
  public GoogleNavigationView createViewInstance(ThemedReactContext reactContext) {
    return new GoogleNavigationView(reactContext);
  }

  @ReactProp(name = "fromLatitude")
  public void setFromLatitude(GoogleNavigationView view, double fromLatitude) {
    view.setFromLatitude(fromLatitude);
  }

  @ReactProp(name = "fromLongitude")
  public void setFromLongitude(GoogleNavigationView view, double fromLongitude) {
    view.setFromLongitude(fromLongitude);
  }

  @ReactProp(name = "toLatitude")
  public void setToLatitude(GoogleNavigationView view, double toLatitude) {
    view.setToLatitude(toLatitude);
  }

  @ReactProp(name = "toLongitude")
  public void setToLongitude(GoogleNavigationView view, double toLongitude) {
    view.setToLongitude(toLongitude);
  }

  @ReactMethod
  public void setVoiceMuted(int reactTag, boolean voiceMuted, Promise promise) {
    UiThreadUtil.runOnUiThread(new Runnable() {
      @Override
      public void run() {
        UIManagerModule uiManagerModule = mReactContext.getNativeModule(UIManagerModule.class);
        GoogleNavigationView view = (GoogleNavigationView) uiManagerModule.resolveView(reactTag);
        if (view != null) {
          view.setVoiceMuted(voiceMuted);
        }
        promise.resolve(null);
      }
    });
  }

  @ReactMethod
  public void isVoiceMuted(int reactTag, Promise promise) {
    UiThreadUtil.runOnUiThread(new Runnable() {
      @Override
      public void run() {
        UIManagerModule uiManagerModule = mReactContext.getNativeModule(UIManagerModule.class);
        GoogleNavigationView view = (GoogleNavigationView) uiManagerModule.resolveView(reactTag);
        boolean isVoiceMuted = false;
        if (view != null) {
          isVoiceMuted = view.isVoiceMuted();
        }
        WritableMap event = Arguments.createMap();
        event.putBoolean("isVoiceMuted", isVoiceMuted);
        promise.resolve(event);
      }
    });
  }

  @ReactMethod
  public void recenter(int reactTag, Promise promise) {
    UiThreadUtil.runOnUiThread(new Runnable() {
      @Override
      public void run() {
        UIManagerModule uiManagerModule = mReactContext.getNativeModule(UIManagerModule.class);
        GoogleNavigationView view = (GoogleNavigationView) uiManagerModule.resolveView(reactTag);
        if (view != null) {
          view.recenter();
        }
        promise.resolve(null);
      }
    });
  }

}
