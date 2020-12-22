
# torus-direct-react-native-sdk

## Getting started

`$ npm install @toruslabs/torus-direct-react-native-sdk --save`

Please refer to the native sdks for specific configuration.

[Android Sdk](https://github.com/torusresearch/torus-direct-android-sdk)
[iOS Sdk](https://github.com/torusresearch/torus-direct-swift-sdk)

More info can be found on docs [here](https://docs.tor.us/direct-auth/redirects-and-service-workers#android-and-react-native-android)


### Mostly automatic installation

`$ react-native link torus-direct-react-native-sdk`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `@toruslabs/torus-direct-react-native-sdk` and add `RNTorusDirectSdk.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNTorusDirectSdk.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import org.torusresearch.rntorusdirect.RNTorusDirectSdkPackage;` to the imports at the top of the file
  - Add `new RNTorusDirectSdkPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':torus-direct-react-native-sdk'
  	project(':torus-direct-react-native-sdk').projectDir = new File(rootProject.projectDir, 	'../node_modules/torus-direct-react-native-sdk/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':torus-direct-react-native-sdk')
  	```


## Usage
```javascript
import RNTorusDirectSdk from '@toruslabs/torus-direct-react-native-sdk';

// TODO: What to do with the module?
RNTorusDirectSdk;
```
