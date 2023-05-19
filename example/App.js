import React from 'react';
import {StyleSheet, Text, View, Button} from 'react-native';
import {Picker} from '@react-native-picker/picker';
import {GOOGLE, verifierMap} from './config';
import CustomAuth from '@toruslabs/customauth-react-native-sdk';
import auth from '@react-native-firebase/auth';
import {decode as atob} from 'base-64';

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

  signInWithEmailPassword = async () => {
    try {
      const res = await auth().signInWithEmailAndPassword(
        'custom+jwt@firebase.login',
        'Testing@123',
      );
      return res;
    } catch (error) {
      console.error(error);
    }
  };

  parseToken = token => {
    try {
      const base64Url = token.split('.')[1];
      const base64 = base64Url.replace('-', '+').replace('_', '/');
      return JSON.parse(atob(base64 || ''));
    } catch (err) {
      console.error(err);
      return null;
    }
  };

  getTorusKey = async () => {
    try {
      const loginRes = await this.signInWithEmailPassword();
      console.log('Login success', loginRes);
      const idToken = await loginRes.user.getIdToken(true);
      console.log('idToken', idToken);
      const parsedToken = this.parseToken(idToken);

      const verifier = 'web3auth-firebase-examples';
      const verifierId = parsedToken.sub;

      const getTorusKeyDetails = await CustomAuth.getTorusKey(
        verifier,
        verifierId,
        {
          verifierIdField: 'sub',
        },
        idToken,
      );

      console.log(getTorusKeyDetails);
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
