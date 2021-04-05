import React from "react";
import { StyleSheet, Text, View, Button } from "react-native";
import { Picker } from "@react-native-picker/picker";
import { GITHUB, verifierMap } from "./config";
import TorusSdk from "@toruslabs/torus-direct-react-native-sdk";

export default class App extends React.Component {
  state = { selectedVerifier: GITHUB, loginHint: "", consoleText: "" };
  
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
     * Android example: <APPLICATION_REDIRECT_URI> = "torusapp://org.torusresearch.torusdirectexample/redirect",
     * iOS example:     <APPLICATION_REDIRECT_URI> = "tdsdk://tdsdk/oauthCallback",
     */
    try {
      TorusSdk.init({
        browserRedirectUri: "torusapp://org.torusresearch.torusdirectexample/redirect",
        redirectUri: "torusapp://org.torusresearch.torusdirectexample/redirect",
        network: "testnet", // details for test net
        proxyContractAddress: "0x4023d2a0D330bF11426B12C6144Cfb96B7fa6183", // details for test net
      });
    } catch (error) {
      console.error(error, "mounted caught");
    }
  };
  
  login = async () => {
    const { selectedVerifier } = this.state;
    try {
      // Trigger login
      const { typeOfLogin, clientId, verifier, jwtParams } = verifierMap[selectedVerifier];
      const loginDetails = await TorusSdk.triggerLogin({
        typeOfLogin,
        verifier,
        clientId,
        jwtParams,
      });
      this.setState({ consoleText: `publicAddress: ${loginDetails.publicAddress}` });

      // Get Torus key 
      // const loginDetails = await TorusSdk.getTorusKey("google-lrc", "<id>", "<token>");
      // console.log(loginDetails);

      // Get aggregate Torus key 
      // const loginDetails = await TorusSdk.getAggregateTorusKey("tkey-google", "<id>", "<cognito token>", "cognito");
      // console.log(loginDetails);
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
    