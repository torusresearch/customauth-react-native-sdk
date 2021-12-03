package org.torusresearch.rntorusdirect;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;

import org.torusresearch.rntorusdirect.utils.UtilsFactory;
import org.torusresearch.customauth.CustomAuth;

import java.util.HashMap;

public class RNCustomAuthSdkModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;
    private CustomAuth torusDirectSdk;

    public RNCustomAuthSdkModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @ReactMethod
    public void init(ReadableMap args, Promise promise) {
        try {
            this.torusDirectSdk = new CustomAuth(UtilsFactory.directSdkArgsFromMap(args), this.reactContext);
            WritableMap map = new WritableNativeMap();
            promise.resolve(map);
        } catch (Exception e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void triggerLogin(ReadableMap subVerifierDetails, Promise promise) {
        try {
            this.torusDirectSdk.triggerLogin(UtilsFactory.subVerifierDetailsFromMap(subVerifierDetails)).whenComplete((response, throwable) -> {
                if (throwable != null) promise.reject(throwable);
                else promise.resolve(UtilsFactory.torusLoginResponseToMap(response));
            });
        } catch (Exception e) {
            promise.reject(e);
        }

    }

    @ReactMethod
    public void triggerAggregateLogin(ReadableMap aggregateLoginParams, Promise promise) {
        try {
            this.torusDirectSdk.triggerAggregateLogin(UtilsFactory.aggregateLoginParamsFromMap(aggregateLoginParams)).whenComplete((torusAggregateLoginResponse, throwable) -> {
                if (throwable != null) promise.reject(throwable);
                else
                    promise.resolve(UtilsFactory.torusAggregateLoginResponseToMap(torusAggregateLoginResponse));
            });
        } catch (Exception e) {
            promise.reject(e);
        }

    }

    @ReactMethod
    public void getTorusKey(String verifier, String verifierId, ReadableMap verifierParams, String idToken, Promise promise) {
        try {
            HashMap<String, Object> finalVerifierParams = UtilsFactory.toHashMap(verifierParams);
            this.torusDirectSdk.getTorusKey(verifier, verifierId, finalVerifierParams, idToken).whenComplete((torusKey, throwable) -> {
                if (throwable != null) promise.reject(throwable);
                else
                    promise.resolve(UtilsFactory.torusKeyToMap(torusKey));
            });
        } catch (Exception e) {
            promise.reject(e);
        }

    }

    @ReactMethod
    public void getAggregateTorusKey(String verifier, String verifierId, ReadableArray subVerifierInfoArray, Promise promise) {
        try {
            this.torusDirectSdk.getAggregateTorusKey(verifier, verifierId, UtilsFactory.subVerifierInfoFromArray(subVerifierInfoArray)).whenComplete((torusKey, throwable) -> {
                if (throwable != null) promise.reject(throwable);
                else
                    promise.resolve(UtilsFactory.torusKeyToMap(torusKey));
            });
        } catch (Exception e) {
            promise.reject(e);
        }

    }

    @Override
    public String getName() {
        return "RNCustomAuthSdk";
    }
}