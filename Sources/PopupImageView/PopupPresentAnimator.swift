import UIKit

final class PopupPresentAnimator: NSObject {
  
  let imageView: UIImageView
  let duration: CGFloat
  
  init(imageView: UIImageView, duration: CGFloat) {
    self.imageView = imageView
    self.duration = duration
  }
}

extension PopupPresentAnimator: UIViewControllerAnimatedTransitioning {
  
  struct Transform {
    let x: CGFloat
    let y: CGFloat
    let scaleX: CGFloat
    let scaleY: CGFloat
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard 
      let to = transitionContext.viewController(forKey: .to) as? PopupViewController,
      let from = transitionContext.viewController(forKey: .from)
    else {
      return
    }
    
    let transitionDuration = transitionDuration(using: transitionContext)
    let container = transitionContext.containerView
    let width = to.view.frame.width
    let transform = makeTransform(from: imageView, to: from.view)
    container.addSubview(to.view)
    
    to.imageView.image = imageView.image
    to.imageView.frame = from.view.convert(imageView.frame, to: nil)
    imageView.isHidden = true
    
    UIView.animate(withDuration: transitionDuration) {
      to.imageView.transform = .identity
        .translatedBy(x: transform.x, y: transform.y)
        .scaledBy(x: transform.scaleX, y: transform.scaleY)
      
      to.view.backgroundColor = .black
    } completion: { _ in
      self.imageView.isHidden = false
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }
  
  /// Make width, height equals to screen's width
  private func makeTransform(from: UIView, to: UIView) -> Transform {
    return Transform(
      x: to.frame.midX - from.frame.midX,
      y: to.frame.midY - from.frame.midY,
      scaleX: to.frame.width / from.frame.width,
      scaleY: to.frame.width / from.frame.height)
  }
}
