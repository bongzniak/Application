//
//  NavigationMap.swift
//  MyApp
//
//  Created by bongzniak on 2020/12/24.
//

import SafariServices
import UIKit
import Swinject
import URLNavigator

enum NavigationMap {
  static func initialize(navigator: NavigatorType, container: Container) {

    navigator.register("http://<path:_>", webViewControllerFactory)
    navigator.register("https://<path:_>", webViewControllerFactory)

    navigator.handle("navigator://alert", self.alert(navigator: navigator))

    navigator.handle("navigator://<path:_>") { (_, _, _) -> Bool in
      // No navigator match, do analytics or fallback function here
      print("[Navigator] NavigationMap.\(#function):\(#line) - global fallback function is called")
      return true
    }
  }

  private static func webViewControllerFactory(
    url: URLConvertible,
    values: [String: Any],
    context: Any?
  ) -> UIViewController? {
    guard let url = url.urlValue else { return nil }
    return SFSafariViewController(url: url)
  }

  private static func alert(navigator: NavigatorType) -> URLOpenHandlerFactory {
    { url, _, _ in
      guard let title = url.queryParameters["title"] else { return false }
      let message = url.queryParameters["message"]
      let alertController = UIAlertController(
        title: title,
        message: message,
        preferredStyle: .alert
      )
      alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      navigator.present(alertController)
      return true
    }
  }
}
