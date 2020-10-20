export const GOOGLE = "google";
const FACEBOOK = "facebook";
const REDDIT = "reddit";
const DISCORD = "discord";
const TWITCH = "twitch";
const GITHUB = "github";
const APPLE = "apple";
const LINKEDIN = "linkedin";
const TWITTER = "twitter";
const LINE = "line";
const EMAIL_PASSWORD = "email_password";
const HOSTED_EMAIL_PASSWORDLESS = "hosted_email_passwordless";
const HOSTED_SMS_PASSWORDLESS = "hosted_sms_passwordless";

const AUTH_DOMAIN = "torus-test.auth0.com";

export const verifierMap = {
  [GOOGLE]: {
    name: "Google",
    typeOfLogin: "google",
    clientId: "221898609709-obfn3p63741l5333093430j3qeiinaa8.apps.googleusercontent.com",
    verifier: "google-lrc",
  },
  [FACEBOOK]: { name: "Facebook", typeOfLogin: "facebook", clientId: "617201755556395", verifier: "facebook-lrc" },
  [REDDIT]: { name: "Reddit", typeOfLogin: "reddit", clientId: "YNsv1YtA_o66fA", verifier: "torus-reddit-test" },
  [TWITCH]: { name: "Twitch", typeOfLogin: "twitch", clientId: "f5and8beke76mzutmics0zu4gw10dj", verifier: "twitch-lrc" },
  [DISCORD]: { name: "Discord", typeOfLogin: "discord", clientId: "682533837464666198", verifier: "discord-lrc" },
  [EMAIL_PASSWORD]: {
    name: "Email Password",
    typeOfLogin: "email_password",
    clientId: "sqKRBVSdwa4WLkaq419U7Bamlh5vK1H7",
    verifier: "torus-auth0-email-password",
    jwtParams: {
      domain: AUTH_DOMAIN,
    },
  },
  [APPLE]: {
    name: "Apple",
    typeOfLogin: "apple",
    clientId: "m1Q0gvDfOyZsJCZ3cucSQEe9XMvl9d9L",
    verifier: "torus-auth0-apple-lrc",
    jwtParams: {
      domain: AUTH_DOMAIN,
    },
  },
  [GITHUB]: {
    name: "Github",
    typeOfLogin: "github",
    clientId: "PC2a4tfNRvXbT48t89J5am0oFM21Nxff",
    verifier: "torus-auth0-github-lrc",
    jwtParams: {
      domain: AUTH_DOMAIN,
    },
  },
  [LINKEDIN]: {
    name: "Linkedin",
    typeOfLogin: "linkedin",
    clientId: "59YxSgx79Vl3Wi7tQUBqQTRTxWroTuoc",
    verifier: "torus-auth0-linkedin-lrc",
    jwtParams: {
      domain: AUTH_DOMAIN,
    },
  },
  [TWITTER]: {
    name: "Twitter",
    typeOfLogin: "twitter",
    clientId: "A7H8kkcmyFRlusJQ9dZiqBLraG2yWIsO",
    verifier: "torus-auth0-twitter-lrc",
    jwtParams: {
      domain: AUTH_DOMAIN,
    },
  },
  [LINE]: {
    name: "Line",
    typeOfLogin: "line",
    clientId: "WN8bOmXKNRH1Gs8k475glfBP5gDZr9H1",
    verifier: "torus-auth0-line-lrc",
    jwtParams: {
      domain: AUTH_DOMAIN,
    },
  },
  [HOSTED_EMAIL_PASSWORDLESS]: {
    name: "Hosted Email Passwordless",
    typeOfLogin: "jwt",
    clientId: "P7PJuBCXIHP41lcyty0NEb7Lgf7Zme8Q",
    verifier: "torus-auth0-passwordless",
    jwtParams: {
      domain: AUTH_DOMAIN,
      verifierIdField: "name",
      isVerifierIdCaseSensitive: false,
    },
  },
  [HOSTED_SMS_PASSWORDLESS]: {
    name: "Hosted SMS Passwordless",
    typeOfLogin: "jwt",
    clientId: "nSYBFalV2b1MSg5b2raWqHl63tfH3KQa",
    verifier: "torus-auth0-sms-passwordless",
    jwtParams: {
      domain: AUTH_DOMAIN,
      verifierIdField: "name",
    },
  },
};
