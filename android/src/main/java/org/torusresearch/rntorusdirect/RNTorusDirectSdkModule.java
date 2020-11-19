package org.torusresearch.rntorusdirect;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;

import org.torusresearch.rntorusdirect.utils.UtilsFactory;
import org.torusresearch.torusdirect.TorusDirectSdk;
import org.torusresearch.torusdirect.types.TorusAggregateLoginResponse;
import org.torusresearch.torusdirect.types.TorusKey;
import org.torusresearch.torusdirect.types.TorusLoginResponse;

import java.util.HashMap;
import java.util.concurrent.ForkJoinPool;

public class RNTorusDirectSdkModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;
    private TorusDirectSdk torusDirectSdk;

    public RNTorusDirectSdkModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @ReactMethod
    public void init(ReadableMap args, Promise promise) {
        ForkJoinPool.commonPool().submit(() -> {
            try {
                this.torusDirectSdk = new TorusDirectSdk(UtilsFactory.directSdkArgsFromMap(args), this.reactContext);
                WritableMap map = new WritableNativeMap();
                promise.resolve(map);
            } catch (Exception e) {
                promise.reject(e);
            }
        });
    }

    @ReactMethod
    public void triggerLogin(ReadableMap subVerifierDetails, Promise promise) {
        ForkJoinPool.commonPool().submit(() -> {
            try {
                TorusLoginResponse response = this.torusDirectSdk.triggerLogin(UtilsFactory.subVerifierDetailsFromMap(subVerifierDetails)).get();
                promise.resolve(UtilsFactory.torusLoginResponseToMap(response));
            } catch (Exception e) {
                promise.reject(e);
            }
        });
    }

    @ReactMethod
    public void triggerAggregateLogin(ReadableMap aggregateLoginParams, Promise promise) {
        ForkJoinPool.commonPool().submit(() -> {
            try {
                TorusAggregateLoginResponse response = this.torusDirectSdk.triggerAggregateLogin(UtilsFactory.aggregateLoginParamsFromMap(aggregateLoginParams)).get();
                promise.resolve(UtilsFactory.torusAggregateLoginResponseToMap(response));
            } catch (Exception e) {
                promise.reject(e);
            }
        });
    }

    @ReactMethod
    public void getTorusKey(String verifier, String verifierId, ReadableMap verifierParams, String idToken, Promise promise) {
        ForkJoinPool.commonPool().submit(() -> {
            try {
                HashMap<String, Object> finalVerifierParams = UtilsFactory.toHashMap(verifierParams);
                TorusKey response = this.torusDirectSdk.getTorusKey(verifier, verifierId, finalVerifierParams, idToken).get();
                promise.resolve(UtilsFactory.torusKeyToMap(response));
            } catch (Exception e) {
                promise.reject(e);
            }
        });
    }

    @Override
    public String getName() {
        return "RNTorusDirectSdk";
    }
}