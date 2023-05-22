import React from 'react';
import {StyleSheet, Text, View, Button} from 'react-native';
import {Picker} from '@react-native-picker/picker';
import {GOOGLE, verifierMap} from './config';
import CustomAuth from '@toruslabs/customauth-react-native-sdk';

export default class App extends React.Component {
  state = {selectedVerifier: GOOGLE, loginHint: '', consoleText: ''};

  componentDidMount = async () => {
    /**
     * Testing mode
     * 1. "https://scripts.toruswallet.io/redirect.html" will redirect to arbitrary redirectUri and should ONLY be use in developement mode.
     * 2. If you want a similar, i.e. brower to application (deeplink) flow, please host you own URL with hardcoded redirectUri for security purposes.
     *
     * browserRedirectUri: "https://scripts.toruswallet.io/redirect.html"
     * redirectUri: "<APPLICATION_REDIRECT_URI>"
     *
     * Production mode
     * browserRedirectUri: "<APPLICATION_REDIRECT_URI>"
     * redirectUri: "<APPLICATION_REDIRECT_URI>"
     *
     * Android example: <APPLICATION_REDIRECT_URI> = "torusapp://org.torusresearch.customauthexample/redirect",
     * iOS example:     <APPLICATION_REDIRECT_URI> = "tdsdk://tdsdk/oauthCallback",
     */
    try {
      CustomAuth.init({
        browserRedirectUri: 'https://scripts.toruswallet.io/redirect.html',
        redirectUri: 'torusapp://org.torusresearch.customauthexample/redirect',
        network: 'testnet', // details for test net
        enableLogging: true,
        enableOneKey: false,
      });
    } catch (error) {
      console.error(error, 'mounted caught');
    }
  };

  login = async () => {
    const {selectedVerifier} = this.state;
    try {
      const {typeOfLogin, clientId, verifier, jwtParams} =
        verifierMap[selectedVerifier];
      const loginDetails = await CustomAuth.triggerLogin({
        typeOfLogin,
        verifier,
        clientId,
        jwtParams,
      });
      this.setState({
        consoleText: `publicAddress: ${loginDetails.publicAddress}`,
      });
    } catch (error) {
      console.error(error, 'login caught');
    }
  };

  getTorusKey = async () => {
    try {
      const getTorusKeyDetails = await CustomAuth.getTorusKey(
        'torus-test-health',
        'hello@torus.us',
        {verifier_id: 'hello@torus.us'},
        'eyJhbGciOiJSUzI1NiIsImtpZCI6ImY0MTk2YWVlMTE5ZmUyMTU5M2Q0OGJmY2ZiNWJmMDAxNzdkZDRhNGQiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI2MzYxOTk0NjUyNDItZmQ3dWp0b3JwdnZ1ZHRzbDN1M2V2OTBuaWplY3RmcW0uYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI2MzYxOTk0NjUyNDItZmQ3dWp0b3JwdnZ1ZHRzbDN1M2V2OTBuaWplY3RmcW0uYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDkxMTE5NTM4NTYwMzE3OTk2MzkiLCJoZCI6InRvci51cyIsImVtYWlsIjoibWljaGFlbEB0b3IudXMiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXRfaGFzaCI6Ik9meERLU2JBUEE5Zjc1SGpQdUh5M3ciLCJub25jZSI6IlM5WmhVenJ1YTMiLCJuYW1lIjoiTWljaGFlbCBMZWUiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUFUWEFKd3NCYjk4Z1NZalZObEJCQWhYSmp2cU5PdzJHRFNlVGYwSTZTSmg9czk2LWMiLCJnaXZlbl9uYW1lIjoiTWljaGFlbCIsImZhbWlseV9uYW1lIjoiTGVlIiwibG9jYWxlIjoiZW4iLCJpYXQiOjE2MzM2NjIyNDAsImV4cCI6MTYzMzY2NTg0MH0.nElQXYUDk-wC1nHJOAJ_JT7ZpkeiD6LPjixWImTm-h7vc2Je5zYbyupMOoIXVIQBploxcG2JMZXPDIhOXn9pXxasjdlOzMvT4a-xdPAvhuW0kQBBSxw2wwqRbzmFKzYnpsfmGRGjBYj8vjieQxiWV4hOgllePEPEn7At-VtTegUZC99Bblu2zhqblAF1I7ML5aKdmAvv2q1FK26i0WC5qQMZk9FFf9sk1DUJzxEp_RTDlgy_G0p7YUS99Olu3WPOIDsb5KKtjYOca006_G-onk6omKaPUklBxSNuhTilKpvQsT609OpsOAFKxaqTlGKfdwkahL_-Bm-rGRtGpoX8pw',
      );
      console.log(getTorusKeyDetails);
      this.setState({
        consoleText: `privateKey: ${getTorusKeyDetails.privateKey}`,
      });
    } catch (error) {
      console.error(error, 'getTorusKey failed');
    }
  };

  render() {
    const {selectedVerifier, consoleText} = this.state;
    return (
      <View style={styles.container}>
        <View style={styles.container}>
          <Text style={styles.headerStyle}>Web3Auth Verifier:</Text>
          <View style={{borderWidth: 1, borderColor: 'black', borderRadius: 4}}>
            <Picker
              style={styles.wrapper}
              selectedValue={selectedVerifier}
              onValueChange={itemValue => {
                this.setState({selectedVerifier: itemValue});
              }}>
              {Object.keys(verifierMap).map(login => (
                <Picker.Item
                  style={styles.wrapper}
                  value={login}
                  key={login.toString()}
                  label={verifierMap[login].name}
                />
              ))}
            </Picker>
          </View>
        </View>
        <View style={styles.top}>
          <View style={{marginBottom: 10}}>
            <Button
              uppercase={false}
              onPress={this.login}
              title="Login with Torus"
            />
          </View>
          <Button onPress={this.getTorusKey} title="test get-Torus-Key" />
        </View>
        <View style={styles.console}>
          <Text style={styles.consoleText}>{consoleText}</Text>
        </View>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
  wrapper: {
    alignItems: 'center',
    justifyContent: 'center',
    height: 50,
    width: 250,
  },
  headerStyle: {
    alignItems: 'center',
    justifyContent: 'center',
    height: 50,
    width: 250,
    fontSize: 18,
    color: '#0364FF',
  },
  consoleText: {
    alignItems: 'center',
    justifyContent: 'center',
    height: 50,
    width: 250,
    fontSize: 16,
    color: '#0364FF',
  },
  top: {
    // marginTop: "20",
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  console: {
    flex: 1,
    height: 250,
    width: 250,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
