import UIKit

open class PopupViewController: UIViewController {
  
  let imageView = UIImageView()
  
  private let transition: TransitionDelegate
  
  open var threshold: CGFloat
  open var velocityThreshold: CGFloat
  
  init(
    transition: TransitionDelegate,
    threshold: CGFloat = 0.5,
    velocityThreshold: CGFloat = 450)
  {
    self.transition = transition
    self.threshold = threshold
    self.velocityThreshold = velocityThreshold
    
    super.init(nibName: nil, bundle: nil)
    
    transitioningDelegate = transition
  }
  
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
    setupImageView()
  }
  
  private func setup() {
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureDidOccur))
    
    view.addGestureRecognizer(panGestureRecognizer)
    view.isUserInteractionEnabled = true
    view.backgroundColor = .clear
  }
  
  private func setupImageView() {
    view.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  @objc private func panGestureDidOccur(_ sender: UIPanGestureRecognizer) {
    let upscaleFactor: CGFloat = 3
    let rawProgress = sender.translation(in: view).y / view.bounds.height * upscaleFactor
    let progress = min(max(rawProgress, 0), 1)
    let velocity = sender.velocity(in: view).y
    
    switch sender.state {
    case .began:
      transition.interactionController = UIPercentDrivenInteractiveTransition()
      dismiss(animated: true)
    case .changed:
      transition.interactionController?.update(progress)
    case .ended, .cancelled:
      if progress > threshold || velocity > velocityThreshold {
        transition.interactionController?.finish()
      } else {
        transition.interactionController?.cancel()
      }
      
    default:
      transition.interactionController?.cancel()
      transition.interactionController = nil
    }
  }
}
