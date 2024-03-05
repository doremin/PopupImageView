import UIKit

final class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
  
  var interactionController: UIPercentDrivenInteractiveTransition?
  
  private let duration: TimeInterval
  private let presentAnimator: PopupPresentAnimator
  private let dismissAnimator: PopupDismissAnimator
  
  init(from imageView: UIImageView, duration: TimeInterval) {
    self.duration = duration
    self.presentAnimator = PopupPresentAnimator(imageView: imageView, duration: duration)
    self.dismissAnimator = PopupDismissAnimator(imageView: imageView, duration: duration)
  }
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return presentAnimator
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return dismissAnimator
  }
  
  func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactionController
  }
}
