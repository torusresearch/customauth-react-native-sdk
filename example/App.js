import React from "react";
import { StyleSheet, Text, View, Button, Picker, AppRegistry } from "react-native";
import { GITHUB, verifierMap } from "./config";
import TorusSdk from "torus-direct-react-native-sdk";

export default class App extends React.Component {
  state = { selectedVerifier: GITHUB, loginHint: "", consoleText: "" };

  componentDidMount = async () => {
    console.log("TorusSdk", TorusSdk)
    try {
      TorusSdk.initialize({
        redirectUri: "tdsdk://tdsdk/oauthCallback",
        network: "testnet",  // details for test net
        proxyContractAddress: "0x4023d2a0D330bF11426B12C6144Cfb96B7fa6183", // details for test net
      });
    } catch (error) {
      console.error(error, "mounted caught");
    }
  };

  login = async () => {
    const { selectedVerifier } = this.state;
    try {
      const { typeOfLogin, clientId, verifier, jwtParams } = verifierMap[selectedVerifier];
      debugger
      const loginDetails = await TorusSdk.triggerLogin({
        typeOfLogin,
        verifier,
        clientId,
        jwtParams,
      });
      this.setState({ consoleText: `publicAddress: ${loginDetails.publicAddress}` });
    } catch (error) {
      console.error(error, "login caught");
    }
  };

  render() {
    const { selectedVerifier, consoleText } = this.state;
    return (
      <View style={styles.container}>
        <View style={styles.container}>
          <Text style={styles.wrapper}>Verifier:</Text>
          <Picker
            style={styles.wrapper}
            selectedValue={selectedVerifier}
            onValueChange={(itemValue) => {
              this.setState({ selectedVerifier: itemValue });
            }}>
            {Object.keys(verifierMap).map((login) => (
              <Picker.Item style={styles.wrapper} value={login} key={login.toString()} label={verifierMap[login].name} />
            ))}
          </Picker>
        </View>
        <View style={styles.top}>
          <Button onPress={this.login} title="Login with Torus" />
        </View>
        <View style={styles.console}>
          <Text>{consoleText}</Text>
        </View>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
  },
  wrapper: {
    alignItems: "center",
    justifyContent: "center",
    height: 50,
    width: 250,
  },
  top: {
    // marginTop: "20",
    flex: 1,
    alignItems: "center",
    justifyContent: "center",
  },
  console: {
    flex: 1,
    height: 250,
    width: 250,
    alignItems: "center",
    justifyContent: "center",
  },
});
