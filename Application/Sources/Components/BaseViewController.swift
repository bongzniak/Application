import AsyncDisplayKit
import RxSwift

class BaseViewController: ASViewController<ASDisplayNode> {

  // MARK: Properties

  lazy private(set) var className: String = {
    type(of: self).description().components(separatedBy: ".").last ?? ""
  }()

  // MARK: Initializing

  init() {
    super.init(node: forwardingNode)

    configureNode()

    forwardInterfaceState()
    forwardLayoutSpec()
    forwardLayoutTransition()
  }

  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
  }

  deinit {
    log.info("DEINIT: \(className)")
  }

  private func configureNode() {
    node.automaticallyManagesSubnodes = true
    node.automaticallyRelayoutOnSafeAreaChanges = true
  }

  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    hidesBottomBarWhenPushed = true
    view.backgroundColor = .background
    configureNavigationItem()
  }

  // MARK: Rx

  var disposeBag = DisposeBag()

  // MARK: Navigation

  func configureNavigationItem() {
    navigationItem.largeTitleDisplayMode = .never

    if navigationController?.viewControllers.count ?? 0 > 1 { // pushed
      navigationItem.leftBarButtonItem = nil
    } else if navigationController?.viewControllers.count ?? 0 == 0 { // pushed
      navigationItem.leftBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "chevron.backward")
      ).then {
        $0.target = self
        $0.action = #selector(navigationBackNodeDidTap)
      }
    } else if presentingViewController != nil { // presented
      navigationItem.leftBarButtonItem = UIBarButtonItem(
        barButtonSystemItem: .cancel,
        target: self,
        action: #selector(navigationCloseNodeDidTap)
      )
    }
  }

  @objc private func navigationBackNodeDidTap() {
    navigationController?.popViewController(animated: true)
  }

  @objc private func navigationCloseNodeDidTap() {
    navigationController?.dismiss(animated: true)
  }

  // MARK: Forwarding

  private let forwardingNode = ForwardingDisplayNode()

  private func forwardInterfaceState() {
    forwardingNode.didEnterPreloadStateBlock = { [weak self] in
      self?.didEnterPreloadState()
    }
    forwardingNode.didExitPreloadStateBlock = { [weak self] in
      self?.didExitPreloadState()
    }
    forwardingNode.didEnterDisplayStateBlock = { [weak self] in
      self?.didEnterDisplayState()
    }
    forwardingNode.didExitDisplayStateBlock = { [weak self] in
      self?.didExitDisplayState()
    }
    forwardingNode.didEnterVisibleStateBlock = { [weak self] in
      self?.didEnterVisibleState()
    }
    forwardingNode.didExitVisibleStateBlock = { [weak self] in
      self?.didExitVisibleState()
    }
  }

  private func forwardLayoutSpec() {
    forwardingNode.layoutSpecBlock = { [weak self] _, sizeRange in
      self?.layoutSpecThatFits(sizeRange) ?? ASLayoutSpec()
    }
  }

  private func forwardLayoutTransition() {
    forwardingNode.animateLayoutTransitionBlock = { [weak self] context, superBlock in
      self?.animateLayoutTransition(context, superBlock: superBlock)
    }
  }

  // MARK: Interface State

  func didEnterPreloadState() {
  }

  func didExitPreloadState() {
  }

  func didEnterDisplayState() {
  }

  func didExitDisplayState() {
  }

  func didEnterVisibleState() {
  }

  func didExitVisibleState() {
  }

  // MARK: Layout Spec

  func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    ASLayoutSpec()
  }

  // MARK: Layout Transition

  private var animateLayoutTransitionSuperBlockStack: [AnimateLayoutTransitionSuperBlock] = []

  private func animateLayoutTransition(
    _ context: ASContextTransitioning,
    superBlock: AnimateLayoutTransitionSuperBlock?
  ) {
    if let superBlock = superBlock {
      animateLayoutTransitionSuperBlockStack.append(superBlock)
    }

    self.animateLayoutTransition(context)

    if superBlock != nil {
      _ = animateLayoutTransitionSuperBlockStack.popLast()
    }
  }

  func animateLayoutTransition(_ context: ASContextTransitioning) {
    animateLayoutTransitionSuperBlockStack.last?(context)
  }
}

private typealias AnimateLayoutTransitionSuperBlock = (ASContextTransitioning) -> Void

private final class ForwardingDisplayNode: ASDisplayNode {

  // MARK: Interface State

  var didEnterPreloadStateBlock: (() -> Void)?
  var didExitPreloadStateBlock: (() -> Void)?

  var didEnterDisplayStateBlock: (() -> Void)?
  var didExitDisplayStateBlock: (() -> Void)?

  var didEnterVisibleStateBlock: (() -> Void)?
  var didExitVisibleStateBlock: (() -> Void)?

  override func didEnterPreloadState() {
    super.didEnterPreloadState()
    didEnterPreloadStateBlock?()
  }

  override func didExitPreloadState() {
    super.didExitPreloadState()
    didExitPreloadStateBlock?()
  }

  override func didEnterDisplayState() {
    super.didEnterDisplayState()
    didEnterDisplayStateBlock?()
  }

  override func didExitDisplayState() {
    super.didExitDisplayState()
    didExitDisplayStateBlock?()
  }

  override func didEnterVisibleState() {
    super.didEnterVisibleState()
    didEnterVisibleStateBlock?()
  }

  override func didExitVisibleState() {
    super.didExitVisibleState()
    didExitVisibleStateBlock?()
  }

  // MARK: Layuot Transition

  var animateLayoutTransitionBlock: ((_ context: ASContextTransitioning,
    _ superBlock: AnimateLayoutTransitionSuperBlock?) -> Void)?

  override func animateLayoutTransition(_ context: ASContextTransitioning) {
    animateLayoutTransitionBlock?(context, super.animateLayoutTransition)
  }
}
