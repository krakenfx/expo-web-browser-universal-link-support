# Expo Web Browser Universal Link Support

This is a fork of the `expo-web-browser` package that adds support for universal links to prevent [iOS URL Scheme Hijacking](https://evanconnelly.github.io/post/ios-oauth/).

Provides access to the system's web browser and supports handling redirects. On iOS, it uses SFSafariViewController or ASWebAuthenticationSession, depending on the method you call, and on Android it uses ChromeCustomTabs. As of iOS 11, SFSafariViewController no longer shares cookies with Safari, so if you are using WebBrowser for authentication you will want to use WebBrowser.openAuthSessionAsync, and if you just want to open a webpage (such as your app privacy policy), then use WebBrowser.openBrowserAsync.

# API documentation

- [Documentation for the latest stable release](https://docs.expo.dev/versions/latest/sdk/webbrowser/)
- [Documentation for the main branch](https://docs.expo.dev/versions/unversioned/sdk/webbrowser/)

# Installation in managed Expo projects

For [managed](https://docs.expo.dev/archive/managed-vs-bare/) Expo projects, please follow the installation instructions in the [API documentation for the latest stable release](https://docs.expo.dev/versions/latest/sdk/webbrowser/).

# Installation in bare React Native projects

For bare React Native projects, you must ensure that you have [installed and configured the `expo` package](https://docs.expo.dev/bare/installing-expo-modules/) before continuing.

### Add the package to your npm dependencies

```
npx expo install expo-web-browser
```

### Configure for Android

No additional set up necessary.

### Configure for iOS

Run `npx pod-install` after installing the npm package.

# Contributing

Contributions are very welcome! Please refer to guidelines described in the [contributing guide](https://github.com/expo/expo#contributing).
