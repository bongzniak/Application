import Swinject
import PureSwinject
import URLNavigator
import Firebase
import Umbrella
import SwiftyColor
import Moya

struct AppDependency {
  typealias OpenURLHandler = (
    _ url: URL,
    _ options: [UIApplication.OpenURLOptionsKey: Any]
  ) -> Bool

  let window: UIWindow
  let navigator: Navigator
  let configureSDKs: () -> Void
  let configureAppearance: () -> Void
  let openURL: OpenURLHandler
}

extension AppDependency {
  private static let container = Container()

  static func resolve() -> AppDependency {

    // Window
    let window = configureWindow()
    container.register(UIWindow.self) { _ in  window }

    // Navigator
    let navigator = Navigator()
    NavigationMap.initialize(navigator: navigator, container: container)
    container.register(Navigator.self) { _ in navigator }

    // Analytics
    let analytics = MyAppAnalytics()
    analytics.register(provider: FirebaseProvider())

    // Service & Networking
    var plugins: [PluginType] = [LoggingPlugin()]

    var networking = Networking(plugins: plugins)
    let authService = AuthService(networking: networking)
    let appStoreService = AppStoreService(networking: networking)

    // append plgunin
    plugins.append(AuthPlugin(authService: authService))
    networking = Networking(plugins: plugins)


    // Splash
    container.register(SplashViewReactor.self) { _ in
      SplashViewReactor(appStoreService: appStoreService, authService: authService)
    }
    container.autoregister(
      SplashViewController.Factory.self,
      dependency: SplashViewController.Dependency.init
    )

    // Login
    container.register(LoginViewReactor.self) { _ in
      LoginViewReactor(authService: authService)
    }
    container.autoregister(
      LoginViewController.Factory.self,
      dependency: LoginViewController.Dependency.init
    )

    // MainTabBarController
    container.register(MainTabBarViewReactor.self) { _ in
      MainTabBarViewReactor()
    }
    container.autoregister(
      MainTabBarController.Factory.self,
      dependency: MainTabBarController.Dependency.init
    )

    // RootViewController
    window.rootViewController = container.resolve(SplashViewController.Factory.self)?.create()

    return AppDependency(
      window: window,
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
