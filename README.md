# torus-direct-react-native-sdk

Fully white-labelled UI/UX paired up to Torus PKI and auth for React Native.

**Important**

This SDK requires native modules and is designed to bring native experience to your React Native app without you doing any work.

If you've already implemented a native auth experience or prefer to use plain JS React Native, you can use [torus-direct-web-sdk](https://github.com/torusresearch/torus-direct-web-sdk), which won't require native modules and can plug into your login system via `getTorusKey` and `getAggregateTorusKey` function.

## Getting Started

```bash
npm i --save @toruslabs/torus-direct-react-native-sdk
```

Please refer to the native SDKs for platform-specific configuration.

- [Android SDK](https://github.com/torusresearch/torus-direct-android-sdk)
- [iOS SDK](https://github.com/torusresearch/torus-direct-swift-sdk)


### Manual installation

#### iOS

1. In Xcode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `@toruslabs/torus-direct-react-native-sdk` and add `RNTorusDirectSdk.xcodeproj`
3. In Xcode, in the project navigator, select your project. Add `libRNTorusDirectSdk.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project `Cmd+R`

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`

   - Add `import org.torusresearch.rntorusdirect.RNTorusDirectSdkPackage;` to the imports at the top of the file

   - Add `new RNTorusDirectSdkPackage()` to the list returned by the `getPackages()` method

2. Append the following lines to `android/settings.gradle`:

   ```groovy
   include ':torus-direct-react-native-sdk'
   project(':torus-direct-react-native-sdk').projectDir = new File(rootProject.projectDir, '../node_modules/torus-direct-react-native-sdk/android')
   ```

3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:

   ```groovy
   compile project(':torus-direct-react-native-sdk')
   ```

## Usage

Initialize the SDK after your app is mounted (`useEffect` or `componentDidMount`):

```js
import TorusDirect from "@toruslabs/torus-direct-react-native-sdk";

TorusDirect.init({
  network: "testnet",

  // Final redirect to your app, can be either custom scheme or deep link
  redirectUri: "torusapp://org.torusresearch.torusdirectexample/redirect",

  // Redirect from browser, some providers don't allow to redirect to custom scheme, you'll need to configure a proxy web address in which case
  browserRedirectUri:
    "https://scripts.toruswallet.io/redirect.html",
});
```

Trigger user's login:

```js
import TorusDirect from "@toruslabs/torus-direct-react-native-sdk";

const credentials = await TorusDirect.triggerLogin({
  typeOfLogin: "google", // "facebook", "email_passwordless", "twitter", "discord", etc
  verifier: "acme-google", // Your verifier registered on https://developer.tor.us
  clientId, // Your OAuth provider's client ID
  jwtParams, // Extra params vary by provider
});
```

Want to know more or implement more advanced use cases? See our [API reference](https://docs.tor.us/customauth/api-reference/usage).
