// Copyright 2022-present 650 Industries. All rights reserved.

import ExpoModulesCore
import AuthenticationServices

private class PresentationContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
  func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    return UIApplication.shared.keyWindow ?? ASPresentationAnchor()
  }
}

final internal class WebAuthSession {
  var authSession: ASWebAuthenticationSession?
  var promise: Promise?
  var isOpen: Bool {
    promise != nil
  }

  // It must be initialized before hand as `ASWebAuthenticationSession` holds it as a weak property
  private var presentationContextProvider = PresentationContextProvider()

  init(authUrl: URL, redirectUrl: URL?, options: AuthSessionOptions) {

    if #available(iOS 17.4, *) {
      // Make sure redirectUrl and redirectUrl.host is not nil
      guard let redirectUrl: URL = redirectUrl else {
        self.finish(with: [
            "type": "cancel",
            "url": "",
            "error": "No redirectUrl"
          ])
        return
      }
      guard let host = redirectUrl.host else {
        self.finish(with: [
            "type": "cancel",
            "url": "",
            "error": "No redirectUrl host"
          ])
        return
      }
    
      // New init method available on iOS 17.4 and later that officially supports universal links:
      // https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession/init(url:callback:completionhandler:)
      self.authSession = ASWebAuthenticationSession(
        url: authUrl,
        callback: ASWebAuthenticationSession.Callback.https(
					host: host,
					path: redirectUrl.path
				),
        completionHandler: { callbackUrl, error in
          self.finish(with: [
            "type": callbackUrl != nil ? "success" : "cancel",
						"url": callbackUrl?.absoluteString,
            "error": error?.localizedDescription
          ])
        }
      )
    } else {
      // Deprecated init method used on iOS 17.3 and earlier
      // https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession/init(url:callbackurlscheme:completionhandler:)
      self.authSession = ASWebAuthenticationSession(
        url: authUrl,
        callbackURLScheme: redirectUrl?.scheme,
        completionHandler: { callbackUrl, error in
          self.finish(with: [
            "type": callbackUrl != nil ? "success" : "cancel",
            "url": callbackUrl?.absoluteString,
            "error": error?.localizedDescription
          ])
        }
      )
    }
    self.authSession?.prefersEphemeralWebBrowserSession = options.preferEphemeralSession
  }

  func open(_ promise: Promise) {
    authSession?.presentationContextProvider = presentationContextProvider
    authSession?.start()
    self.promise = promise
  }

  func dismiss() {
    authSession?.cancel()
    finish(with: ["type": "dismiss"])
  }

  // MARK: - Private

  private func finish(with result: [String: String?]) {
    promise?.resolve(result)
    promise = nil
    authSession = nil
  }
}
