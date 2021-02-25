//
//  AppDelegate.swift
//  MyApp
//
//  Created by bongzniak on 2020/12/20.
//

import UIKit
import CoreData

import FBSDKCoreKit
import AsyncDisplayKit
import URLNavigator

class AppDelegate: UIResponder, UIApplicationDelegate {

  private let dependency: AppDependency
  var window: UIWindow?

  private override init() {
    dependency = AppDependency.resolve()
    super.init()
  }

  init(dependency: AppDependency) {
    self.dependency = dependency
  }

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    window = dependency.window

    dependency.configureSDKs()
    dependency.configureAppearance()

    // DEBUG
    ASControlNode.enableHitTestDebug = true
    ASDisplayNode.shouldShowRangeDebugOverlay = true

    // FACEBOOK
    ApplicationDelegate.shared.application(
      application,
      didFinishLaunchingWithOptions: launchOptions
    )
    return true
  }

  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    // Try presenting the URL first
    if dependency.navigator.present(url, wrap: UINavigationController.self) != nil {
      print("[Navigator] present: \(url)")
      return true
    }

    // Try opening the URL
    if dependency.navigator.open(url) == true {
      print("[Navigator] open: \(url)")
      return true
    }

    // FACEBOOK
    ApplicationDelegate.shared.application(
      app,
      open: url,
      options: options
    )
    return false
  }
}
