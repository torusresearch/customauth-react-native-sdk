# customauth-react-native-sdk

Fully white-labelled UI/UX paired up to Torus PKI and auth for React Native.

**Important**

This SDK requires native modules and is designed to bring native experience to
your React Native app without you doing any work.

## 🩹 Examples

Checkout the example of `CustomAuth React Native SDK` in our
[examples directory.](https://github.com/torusresearch/customauth-react-native-sdk/tree/master/example)

## Getting Started

```bash
npm i --save @toruslabs/customauth-react-native-sdk
```

Please refer to the native SDKs for platform-specific configuration.

- [Android SDK](https://github.com/torusresearch/customauth-android-sdk)
- [iOS SDK](https://github.com/torusresearch/customauth-swift-sdk)

### Manual installation

#### iOS

1. Add the following to your `Podfile` then run `pod install` from the `ios`
   directory:

```ruby
pod 'CustomAuth', '~> 2.1.0', :modular_headers => true
pod 'secp256k1.swift', :modular_headers => true
```

2. Open Xcode, in the project navigator, select your project. Add
   `libRNCustomAuthSdk.a` to your project's `Build Phases` ➜
   `Link Binary With Libraries`
3. Run your project `Cmd+R`

#### Android

1. Add `maven { url "https://jitpack.io" }` to the repositories block of
   `android/build.gradle`
2. Append the following lines to `android/settings.gradle`:

   ```groovy
   include ':customauth-react-native-sdk'
   project(':customauth-react-native-sdk').projectDir = new File(rootProject.projectDir, '../node_modules/@toruslabs/customauth-react-native-sdk/android')
   ```

3. Insert the following lines inside the dependencies block in
   `android/app/build.gradle`:

   ```groovy
   implementation project(':customauth-react-native-sdk')
   ```

4. Add the following to `android/app/build.grade`

```groovy
android {
  ...
  defaultConfig {
    manifestPlaceholders = [
          //... other placeholders if you have them
          'torusRedirectScheme': 'torusapp',
          'torusRedirectHost': 'org.torusresearch.customauthandroid',
          'torusRedirectPathPrefix': '/redirect'
      ]
  }
}
```

## Usage

Initialize the SDK after your app is mounted (`useEffect` or
`componentDidMount`):

```js
import CustomAuth from '@toruslabs/customauth-react-native-sdk'

CustomAuth.init({
  network: 'testnet',

  // Final redirect to your app, can be either custom scheme or deep link
  redirectUri: 'torusapp://org.torusresearch.customauthexample/redirect',

  // Redirect from browser, some providers don't allow to redirect to custom scheme, you'll need to configure a proxy web address in which case
  browserRedirectUri: 'https://scripts.toruswallet.io/redirect.html',
})
```

Trigger user's login:

```js
import CustomAuth from '@toruslabs/customauth-react-native-sdk'

const credentials = await CustomAuth.triggerLogin({
  typeOfLogin: 'google', // "facebook", "email_passwordless", "twitter", "discord", etc
  verifier: 'acme-google', // Your verifier registered on https://dashboard.web3auth.io
  clientId, // Your OAuth provider's client ID
  jwtParams, // Extra params vary by provider
})
```

## FAQ

1. I got `BigInt not found` build error when building for iOS, what should I do?

   Add the following snipplet to your `ios/Podfile`. See `example/ios/Podfile`
   for a full example.

   ```ruby
     post_install do |installer|
       installer.pods_project.targets.each do |target|
         if target.name == "web3.swift"
           target.build_configurations.each do |config|
             config.build_settings["SWIFT_INCLUDE_PATHS[sdk=iphonesimulator*]"] = "$(inherited) $(PODS_CONFIGURATION_BUILD_DIR)/BigInt $(PODS_CONFIGURATION_BUILD_DIR)/GenericJSON $(PODS_TARGET_SRCROOT)/web3swift/lib/**"
             config.build_settings["SWIFT_INCLUDE_PATHS[sdk=iphoneos*]"] = "$(inherited) $(PODS_CONFIGURATION_BUILD_DIR)/BigInt $(PODS_CONFIGURATION_BUILD_DIR)/GenericJSON $(PODS_TARGET_SRCROOT)/web3swift/lib/**"
           end
         end
       end
     end
   ```

   This is a temporary mitigation for broken xcconfig in the podspec of
   web3.swift. You may know more at
   https://github.com/argentlabs/web3.swift/pull/161. If you are using
   web3.swift >= 0.8.2 this should be fixed.

   Want to know more or implement more advanced use cases? See our
   [API reference](https://docs.tor.us/customauth/api-reference/usage).

2. I got an error on my android build similar to
   `Failed to transform bcprov-jdk15on-1.68.jar`

   Add the following to `android/app/build.gradle` in the `android` block:

   ```groovy
   android {
     //All other config in the android block should be above this
     configurations {
       all*.exclude module: 'bcprov-jdk15on'
     }
   }
   ```

   and add the following to `gradle.properties`:

   ```
   android.jetifier.blacklist=bcprov
   ```

## 💬 Troubleshooting and Discussions

- Have a look at our
  [GitHub Discussions](https://github.com/Web3Auth/Web3Auth/discussions?discussions_q=sort%3Atop)
  to see if anyone has any questions or issues you might be having.
- Checkout our
  [Troubleshooting Documentation Page](https://web3auth.io/docs/troubleshooting)
  to know the common issues and solutions
- Join our [Discord](https://discord.gg/web3auth) to join our community and get
  private integration support or help with your integration.
