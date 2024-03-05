import UIKit

final class PopupDismissAnimator: NSObject {
  
  let imageView: UIImageView
  let duration: CGFloat

  init(imageView: UIImageView, duration: CGFloat) {
    self.imageView = imageView
    self.duration = duration
  }
}

extension PopupDismissAnimator: UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard
      let to = transitionContext.viewController(forKey: .to),
      let from = transitionContext.viewController(forKey: .from) as? PopupViewController
    else {
      return
    }
    
    let transitionDuration = transitionDuration(using: transitionContext)
    let container = transitionContext.containerView
    
    imageView.isHidden = true
    
    UIView.animate(withDuration: transitionDuration) {
      from.imageView.transform = .identity
      from.view.backgroundColor = .clear
    } completion: { _ in
      self.imageView.isHidden = false
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }
}
