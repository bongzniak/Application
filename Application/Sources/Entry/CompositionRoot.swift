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

    // Append AuthPlugin plgunin
    plugins.append(AuthPlugin(authService: authService))
    networking = Networking(plugins: plugins)
    let postService = PostService(networking: networking)

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

    // Post
    container.register(PostListViewReactor.self) { _ in
      PostListViewReactor(postService: postService)
    }
    container.autoregister(
      PostListViewController.Factory.self,
      dependency: PostListViewController.Dependency.init
    )

    // PostListSectionController
    container.autoregister(
      PostListSectionController.Factory.self,
      dependency: PostListSectionController.Dependency.init
    )

    // PostListViewCell
    container.register(PostListViewCellNode.Factory.self) { _ in
      PostListViewCellNode.Factory(dependency: .init(
        reactorFactory: { (post: Post) -> PostListViewCellReactor in
          PostListViewCellReactor(post: post)
        }
      ))
    }

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
      openURL: openURLFactory(navigator: navigator)
    )
  }

  static func configureWindow() -> UIWindow {
    UIWindow(frame: UIScreen.main.bounds).then {
      $0.frame = UIScreen.main.bounds
      $0.backgroundColor = .black
      $0.makeKeyAndVisible()
    }
  }

  static func configureSDKs() {
//    FirebaseApp.configure()
  }

  static func configureAppearance() {
    let navigationBarBackgroundImage = UIImage.resizable().color(0x333333.color).image
    UINavigationBar.appearance().setBackgroundImage(navigationBarBackgroundImage, for: .default)
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().barStyle = .black
    UINavigationBar.appearance().tintColor = 0x9DA3A5.color
    UITabBar.appearance().tintColor = 0x333333.color
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
