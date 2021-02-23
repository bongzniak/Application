import Swinject
import PureSwinject
import URLNavigator
import Firebase
import Umbrella
import SwiftyColor

struct AppDependency {
  typealias OpenURLHandler = (_ url: URL,
                              _ options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool
  let window: UIWindow
  let navigator: Navigator
  let configureSDKs: () -> Void
  let configureAppearance: () -> Void
  let openURL: OpenURLHandler
}

extension AppDependency {
  private static let container = Container()

  static func resolve() -> AppDependency {
    let navigator = Navigator()

    NavigationMap.initialize(navigator: navigator, container: container)

    // Analytics
    let analytics = MyAppAnalytics()
    analytics.register(provider: FirebaseProvider())

    // Service & Networking
    let authService = AuthService(navigator: navigator)
    let networking = Networking(plugins: [AuthPlugin(authService: authService)])
    let appStoreService = AppStoreService(networking: networking)

    // Splash
    container.register(SplashViewReactor.self) { _ in
      SplashViewReactor(appStoreService: appStoreService, authService: authService)
    }
    container.autoregister(SplashViewController.Factory.self,
                           dependency: SplashViewController.Dependency.init)


    // MainTabBarController
    container.register(MainTabBarViewReactor.self) { _ in
      MainTabBarViewReactor()
    }
    container.autoregister(MainTabBarController.Factory.self,
                           dependency: MainTabBarController.Dependency.init)

    return AppDependency(
        window: configureWindow(),
        navigator: navigator,
        configureSDKs: configureSDKs,
        configureAppearance: configureAppearance,
        openURL: self.openURLFactory(navigator: navigator)
    )
  }

  static func configureWindow() -> UIWindow {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.frame = UIScreen.main.bounds
    window.backgroundColor = .black
    window.makeKeyAndVisible()
    window.rootViewController = container
      .resolve(MainTabBarController.Factory.self)?
      .create(payload: .init(version: 0))

    return window
  }

  static func configureSDKs() {
//    FirebaseApp.configure()
  }

  static func configureAppearance() {
    let navigationBarBackgroundImage = UIImage.resizable().color(UIColor.black).image
//    let navigationBarBackgroundImage = UIImage.resizable().color(.db_charcoal).image
    UINavigationBar.appearance().setBackgroundImage(navigationBarBackgroundImage, for: .default)
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().barStyle = .black
//    UINavigationBar.appearance().tintColor = .db_slate
//    UITabBar.appearance().tintColor = .db_charcoal
    UINavigationBar.appearance().tintColor = UIColor.red
    UITabBar.appearance().tintColor = UIColor.red
  }

  static func openURLFactory(navigator: NavigatorType) -> AppDependency.OpenURLHandler {
    { url, _ -> Bool in
      if navigator.open(url) {
        return true
      }
      if navigator.present(url, wrap: UINavigationController.self) != nil {
        return true
      }
      return false
    }
  }
}
