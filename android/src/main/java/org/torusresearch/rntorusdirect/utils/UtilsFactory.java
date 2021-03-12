package org.torusresearch.rntorusdirect.utils;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;

import org.jetbrains.annotations.NotNull;
import org.torusresearch.torusdirect.types.AggregateLoginParams;
import org.torusresearch.torusdirect.types.AggregateVerifierType;
import org.torusresearch.torusdirect.types.Auth0ClientOptions;
import org.torusresearch.torusdirect.types.DirectSdkArgs;
import org.torusresearch.torusdirect.types.Display;
import org.torusresearch.torusdirect.types.LoginType;
import org.torusresearch.torusdirect.types.Prompt;
import org.torusresearch.torusdirect.types.SubVerifierDetails;
import org.torusresearch.torusdirect.types.TorusAggregateLoginResponse;
import org.torusresearch.torusdirect.types.TorusKey;
import org.torusresearch.torusdirect.types.TorusLoginResponse;
import org.torusresearch.torusdirect.types.TorusNetwork;
import org.torusresearch.torusdirect.types.TorusSubVerifierInfo;
import org.torusresearch.torusdirect.types.TorusVerifierUnionResponse;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

// Checks are not present at certain places. It implies params are mandatory and app should crash if they are not provided.
public final class UtilsFactory {
    public static DirectSdkArgs directSdkArgsFromMap(ReadableMap map) {
        String browserRedirectUri = map.getString("browserRedirectUri");
        DirectSdkArgs args = new DirectSdkArgs(browserRedirectUri);
        if (map.hasKey("network")) {
            args = new DirectSdkArgs(browserRedirectUri, TorusNetwork.valueOfLabel(map.getString("network")));
        }
        if (map.hasKey("proxyContractAddress")) {
            args.setProxyContractAddress((map.getString("proxyContractAddress")));
        }
        if (map.hasKey("redirectUri")) {
            args.setRedirectUri((map.getString("redirectUri")));
        }
        return args;
    }

    public static AggregateLoginParams aggregateLoginParamsFromMap(ReadableMap map) {
        AggregateVerifierType aggregateVerifierType = AggregateVerifierType.valueOfLabel(map.getString("aggregateVerifierType"));
        String verifierIdentifier = map.getString("verifierIdentifier");
        ReadableArray subVerfierDetailsArray = map.getArray("subVerifierDetailsArray");
        List<SubVerifierDetails> arrayList = new ArrayList<>();

        for (int i = 0; i < subVerfierDetailsArray.size(); i++) {
            if (subVerfierDetailsArray.getType(i) == ReadableType.Map) {
                arrayList.add(subVerifierDetailsFromMap(subVerfierDetailsArray.getMap(i)));
            } else {
                throw new IllegalArgumentException("Could not convert object at index: " + i + ".");
            }
        }
        return new AggregateLoginParams(aggregateVerifierType, verifierIdentifier, arrayList.toArray(new SubVerifierDetails[0]));
    }


    public static SubVerifierDetails subVerifierDetailsFromMap(ReadableMap map) {
        LoginType typeOfLogin = LoginType.valueOfLabel(map.getString("typeOfLogin"));
        String verifier = map.getString("verifier");
        String clientId = map.getString("clientId");
        Auth0ClientOptions auth0ClientOptions = new Auth0ClientOptions.Auth0ClientOptionsBuilder("").build();
        if (map.hasKey("jwtParams")) {
            auth0ClientOptions = mapToJwtParams(map.getMap("jwtParams"));
        }
        boolean isNewActivity = true;
        if (map.hasKey("isNewActivity")) isNewActivity = map.getBoolean("isNewActivity");
        return new SubVerifierDetails(typeOfLogin, verifier, clientId, auth0ClientOptions, isNewActivity);
    }

    public static TorusSubVerifierInfo[] subVerifierInfoFromArray(ReadableArray arr) {
        TorusSubVerifierInfo[] torusSubVerifierInfo = new TorusSubVerifierInfo[arr.size()];
        for (int i = 0; i < arr.size(); i++) {
            ReadableMap map = arr.getMap(i);
            String verifier = map.getString("verifier");
            String idToken = map.getString("idToken");
            torusSubVerifierInfo[i] = new TorusSubVerifierInfo(verifier, idToken);
        }
        return torusSubVerifierInfo;
    }

    public static WritableMap torusLoginResponseToMap(TorusLoginResponse response) {
        WritableMap map = new WritableNativeMap();
        WritableMap userInfoMap = getUserInfoWritableMap(response.getUserInfo());
        map.putString("privateKey", response.getPrivateKey());
        map.putString("publicAddress", response.getPublicAddress());
        map.putMap("userInfo", (ReadableMap) userInfoMap);
        return map;
    }

    @NotNull
    private static WritableMap getUserInfoWritableMap(TorusVerifierUnionResponse userInfo) {
        WritableMap userInfoMap = new WritableNativeMap();
        userInfoMap.putString("email", userInfo.getEmail() != null ? userInfo.getEmail() : "");
        userInfoMap.putString("name", userInfo.getName() != null ? userInfo.getName() : "");
        userInfoMap.putString("profileImage", userInfo.getProfileImage() != null ? userInfo.getProfileImage() : "");
        userInfoMap.putString("verifier", userInfo.getVerifier() != null ? userInfo.getVerifier() : "");
        userInfoMap.putString("verifierId", userInfo.getVerifierId() != null ? userInfo.getVerifierId() : "");
        userInfoMap.putString("typeOfLogin", userInfo.getTypeOfLogin() != null ? userInfo.getTypeOfLogin().name() : "");
        userInfoMap.putString("accessToken", userInfo.getAccessToken() != null ? userInfo.getAccessToken() : "");
        userInfoMap.putString("idToken", userInfo.getIdToken() != null ? userInfo.getIdToken() : "");
        return userInfoMap;
    }

    public static WritableMap torusAggregateLoginResponseToMap(TorusAggregateLoginResponse response) {
        WritableMap map = new WritableNativeMap();
        WritableArray userInfoArray = Arguments.createArray();
        Arrays.asList(response.getUserInfo()).forEach(x -> {
            userInfoArray.pushMap(getUserInfoWritableMap(x));
        });
        map.putArray("userInfo", userInfoArray);
        map.putString("privateKey", response.getPrivateKey());
        map.putString("publicAddress", response.getPublicAddress());

        return map;
    }

    public static WritableMap torusKeyToMap(TorusKey response) {
        WritableMap map = new WritableNativeMap();

        map.putString("privateKey", response.getPrivateKey());
        map.putString("publicAddress", response.getPublicAddress());

        return map;
    }

    public static Auth0ClientOptions mapToJwtParams(ReadableMap jwtParams) {
        if (!jwtParams.hasKey("domain")) {
            Auth0ClientOptions.Auth0ClientOptionsBuilder builder = new Auth0ClientOptions.Auth0ClientOptionsBuilder("");
            return builder.build();
        }
        String domain = jwtParams.getString("domain");
        Auth0ClientOptions.Auth0ClientOptionsBuilder builder = new Auth0ClientOptions.Auth0ClientOptionsBuilder(domain);

        if (jwtParams.hasKey("isVerifierIdCaseSensitive")) {
            builder.setVerifierIdCaseSensitive(jwtParams.getBoolean("isVerifierIdCaseSensitive"));
        }
        if (jwtParams.hasKey("client_id")) {
            builder.setClient_id(jwtParams.getString("client_id"));
        }
        if (jwtParams.hasKey("leeway")) {
            builder.setLeeway(jwtParams.getString("leeway"));
        }
        if (jwtParams.hasKey("verifierIdField")) {
            builder.setVerifierIdField(jwtParams.getString("verifierIdField"));
        }
        if (jwtParams.hasKey("display")) {
            builder.setDisplay(Display.valueOfLabel(jwtParams.getString("display")));
        }
        if (jwtParams.hasKey("prompt")) {
            builder.setPrompt(Prompt.valueOfLabel(jwtParams.getString("prompt")));
        }
        if (jwtParams.hasKey("max_age")) {
            builder.setMax_age(jwtParams.getString("max_age"));
        }
        if (jwtParams.hasKey("ui_locales")) {
            builder.setUi_locales(jwtParams.getString("ui_locales"));
        }
        if (jwtParams.hasKey("id_token_hint")) {
            builder.setId_token_hint(jwtParams.getString("id_token_hint"));
        }
        if (jwtParams.hasKey("login_hint")) {
            builder.setLogin_hint(jwtParams.getString("login_hint"));
        }
        if (jwtParams.hasKey("acr_values")) {
            builder.setAcr_values(jwtParams.getString("acr_values"));
        }
        if (jwtParams.hasKey("scope")) {
            builder.setScope(jwtParams.getString("scope"));
        }
        if (jwtParams.hasKey("audience")) {
            builder.setAudience(jwtParams.getString("audience"));
        }
        if (jwtParams.hasKey("connection")) {
            builder.setConnection(jwtParams.getString("connection"));
        }
        if (jwtParams.hasKey("additionalParams")) {
            builder.setAdditionalParams(toStringHashMap(jwtParams.getMap("additionalParams")));
        }

        return builder.build();
    }

    public static HashMap<String, String> toStringHashMap(ReadableMap map) {
        ReadableMapKeySetIterator iterator = map.keySetIterator();
        HashMap<String, String> hashMap = new HashMap<>();

        while (iterator.hasNextKey()) {
            String key = iterator.nextKey();
            switch (map.getType(key)) {
                case Null:
                    hashMap.put(key, null);
                    break;
                case Boolean:
                    hashMap.put(key, String.valueOf(map.getBoolean(key)));
                    break;
                case Number:
                    hashMap.put(key, String.valueOf(map.getDouble(key)));
                    break;
                case String:
                    hashMap.put(key, map.getString(key));
                    break;
                default:
                    throw new IllegalArgumentException("Could not convert object with key: " + key + ".");
            }
        }
        return hashMap;
    }

    public static HashMap<String, Object> toHashMap(ReadableMap map) {
        ReadableMapKeySetIterator iterator = map.keySetIterator();
        HashMap<String, Object> hashMap = new HashMap<>();

        while (iterator.hasNextKey()) {
            String key = iterator.nextKey();
            switch (map.getType(key)) {
                case Null:
                    hashMap.put(key, null);
                    break;
                case Boolean:
                    hashMap.put(key, map.getBoolean(key));
                    break;
                case Number:
                    hashMap.put(key, map.getDouble(key));
                    break;
                case String:
                    hashMap.put(key, map.getString(key));
                    break;
                case Map:
                    hashMap.put(key, toHashMap(map.getMap(key)));
                    break;
                case Array:
                    hashMap.put(key, toArrayList(map.getArray(key)));
                    break;
                default:
                    throw new IllegalArgumentException("Could not convert object with key: " + key + ".");
            }
        }
        return hashMap;
    }

    public static ArrayList<Object> toArrayList(ReadableArray map) {
        ArrayList<Object> arrayList = new ArrayList<>();

        for (int i = 0; i < map.size(); i++) {
            switch (map.getType(i)) {
                case Null:
                    arrayList.add(null);
                    break;
                case Boolean:
                    arrayList.add(map.getBoolean(i));
                    break;
                case Number:
                    arrayList.add(map.getDouble(i));
                    break;
                case String:
                    arrayList.add(map.getString(i));
                    break;
                case Map:
                    arrayList.add(toHashMap(map.getMap(i)));
                    break;
                case Array:
                    arrayList.add(toArrayList(map.getArray(i)));
                    break;
                default:
                    throw new IllegalArgumentException("Could not convert object at index: " + i + ".");
            }
        }
        return arrayList;
    }
}
