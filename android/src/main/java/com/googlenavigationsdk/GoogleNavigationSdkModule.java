package com.googlenavigationsdk;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.module.annotations.ReactModule;

@ReactModule(name = GoogleNavigationSdkModule.NAME)
public class GoogleNavigationSdkModule extends ReactContextBaseJavaModule {
  public static final String NAME = "GoogleNavigationSdk";

  public GoogleNavigationSdkModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }

  @ReactMethod
  public void provideAPIKey(String apiKey, Promise promise) {
    // Nothing to do for Android, this method was just for iOS
    promise.resolve(null);
  }
}
