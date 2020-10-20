
# react-native-torus-direct-sdk

## Getting started

`$ npm install react-native-torus-direct-sdk --save`

### Mostly automatic installation

`$ react-native link react-native-torus-direct-sdk`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-torus-direct-sdk` and add `RNTorusDirectSdk.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNTorusDirectSdk.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import org.torusresearch.rntorusdirect.RNTorusDirectSdkPackage;` to the imports at the top of the file
  - Add `new RNTorusDirectSdkPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-torus-direct-sdk'
  	project(':react-native-torus-direct-sdk').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-torus-direct-sdk/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-torus-direct-sdk')
  	```


## Usage
```javascript
import RNTorusDirectSdk from 'react-native-torus-direct-sdk';

// TODO: What to do with the module?
RNTorusDirectSdk;
```

## TODO
- add example
  