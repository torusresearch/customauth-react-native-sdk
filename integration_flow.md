If 

your OAuth provider supports deep link urls,

Please use the following

```js
TorusSdk.init({
        browserRedirectUri: "torusapp://org.torusresearch.torusdirectexample/redirect", // Your app scheme
        redirectUri: "torusapp://org.torusresearch.torusdirectexample/redirect", // Your app scheme
        network: "testnet", // details for test net
        proxyContractAddress: "0x4023d2a0D330bF11426B12C6144Cfb96B7fa6183", // details for test net
      });
```

Else,

you should host the redirect.html present here(https://github.com/torusresearch/torus-direct-android-sdk/blob/master/torusdirect/src/main/java/org/torusresearch/torusdirect/activity/redirect.html) from your own URL (eg: https://wallet.gooddollar.org/torus/scripts.html).

In that redirect.html, please edit the `whiteListedURLs` to add the scheme specified in manifestPlaceHolders and pass it in as redirectUri.
(This is helpful to so that both android and ios can use the same script and whitelisting is for security reasons as detailed below)

```js
TorusSdk.init({
        browserRedirectUri: "https://scripts.toruswallet.io/redirect.html", // Your app hosted url
        redirectUri: "torusapp://org.torusresearch.torusdirectexample/redirect", // Your app scheme
        network: "testnet", // details for test net
        proxyContractAddress: "0x4023d2a0D330bF11426B12C6144Cfb96B7fa6183", // details for test net
      });
```

Note: 
redirect.html does the following tasks
- get the `redirectUri` specified in the application which is present in `state` param of OAuth redirect
- Allow the redirect only if it's present in the `whiteListedURLs`

This is important to prevent other apps from using your client ids.