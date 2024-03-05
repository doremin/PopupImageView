import UIKit

/// Utility to present PopupViewController on the top view controller
fileprivate extension UIApplication {
  private class var rootViewController: UIViewController? {
    let keyWindow = UIApplication
      .shared
      .connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .last { $0.isKeyWindow }
    
    return keyWindow?.rootViewController
  }
  
  fileprivate func topViewController(_ base: UIViewController? = UIApplication.rootViewController) -> UIViewController? {
    if let navigationController = base as? UINavigationController {
      return topViewController(navigationController.visibleViewController)
    }
    
    if let tabBarController = base as? UITabBarController,
       let selectedViewController = tabBarController.selectedViewController {
      return topViewController(selectedViewController)
    }
    
    if let presentedViewController = base?.presentedViewController {
      return topViewController(presentedViewController)
    }
    
    return base
  }
}

open class PopupImageView: UIImageView {
  
  // MARK: Properties
  open var isAnimationEnabled: Bool = true
  open var damping: CGFloat = 0.4
  open var delay: TimeInterval = .zero
  open var duration: TimeInterval = 0.25
  open var scaleX: CGFloat = 0.8
  open var scaleY: CGFloat = 0.8
  open var initialVelocity: CGFloat = 0.0
  open var transitionDuration: CGFloat = 0.25
  
  /// Start animation when touch PopupImageView
  open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    scaleDown()
  }
  
  open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    scaleUp()
  }
  
  open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    scaleUp()
  }
  
  // MARK: Intializer
  public init() {
    super.init(frame: .zero)
    
    setup()
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    let tapGestureRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(imageViewDidTapped))
    
    tapGestureRecognizer.cancelsTouchesInView = false
    addGestureRecognizer(tapGestureRecognizer)
    isUserInteractionEnabled = true
    translatesAutoresizingMaskIntoConstraints = false
    clipsToBounds = true
  }
  
  // MARK: Tap Gesture
  @objc private func imageViewDidTapped(_ sender: UITapGestureRecognizer) {
    guard let topViewController = UIApplication.shared.topViewController() else {
      return
    }
    
    let transition = TransitionDelegate(from: self, duration: transitionDuration)
    let popupViewController = PopupViewController(transition: transition)
    popupViewController.modalPresentationStyle = .custom
    topViewController.present(popupViewController, animated: true)
  }
  
  // MARK: Scale Animation
  private func scaleDown() {
    guard isAnimationEnabled else { return }
    
    UIView.animate(
      withDuration: duration,
      delay: delay,
      usingSpringWithDamping: damping,
      initialSpringVelocity: initialVelocity) 
    {
      self.transform = CGAffineTransform(scaleX: self.scaleX, y: self.scaleY)
    }
  }
  
  private func scaleUp() {
    guard isAnimationEnabled else { return }
    
    UIView.animate(
      withDuration: duration,
      delay: delay,
      usingSpringWithDamping: damping,
      initialSpringVelocity: initialVelocity) 
    {
      self.transform = .identity
    }
  }
}
