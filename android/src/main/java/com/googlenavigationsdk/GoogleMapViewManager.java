//package com.googlenavigationsdk;
//
//import android.graphics.Color;
//import android.view.View;
//
//import androidx.annotation.NonNull;
//
//import com.facebook.react.uimanager.SimpleViewManager;
//import com.facebook.react.uimanager.ThemedReactContext;
//import com.facebook.react.uimanager.annotations.ReactProp;
//import com.facebook.react.bridge.ReactApplicationContext;
//
//public class GoogleMapViewManager extends SimpleViewManager<View> {
//  public static final String REACT_CLASS = "GoogleMapView";
//
//  private ReactApplicationContext mReactContext;
//
//  public GoogleMapViewManager(ReactApplicationContext reactContext) {
//    mReactContext = reactContext;
//  }
//
//  @Override
//  @NonNull
//  public String getName() {
//    return REACT_CLASS;
//  }
//
//  @Override
//  @NonNull
//  public View createViewInstance(ThemedReactContext reactContext) {
//    return new View(reactContext);
//  }
//
//  @ReactProp(name = "color")
//  public void setColor(View view, String color) {
//    view.setBackgroundColor(Color.parseColor(color));
//  }
//}
