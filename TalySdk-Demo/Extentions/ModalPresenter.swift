//
//  ModalPresenter.swift
//  PaymentDemoApp
//
//  Created by Taly on 21/06/23.
//


import Foundation
import UIKit

class ModalPresenter: NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration: CGFloat = 0.5
    var cornerRadius: CGFloat = 2.0
    var darkViewOpacity: CGFloat = 0.5
    
    var leftPadding: CGFloat = 20
    var width: CGFloat? = nil
    
    var topPadding: CGFloat = 100
    var height: CGFloat? = nil
    
    var touchEvent: ()->Void = {}
    
    init(duration: CGFloat = 0.5, cornerRadius: CGFloat = 3.0, width: CGFloat? = nil, height: CGFloat? = nil) {
        self.duration = duration
        self.cornerRadius = cornerRadius
        self.width = width
        self.height = height
    }
    
    var isPresenting: Bool = true
    
    fileprivate lazy var darkView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(self.darkViewOpacity)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(darkViewTouched)))
        return view
    }()
    
    @objc func darkViewTouched() {
        self.touchEvent = {
//            debugPrint("touched...")
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(duration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toView = isPresenting ? transitionContext.view(forKey: UITransitionContextViewKey.to)! : transitionContext.view(forKey: UITransitionContextViewKey.from)!
        
        toView.layer.cornerRadius = cornerRadius
        toView.layer.masksToBounds = true
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(darkView)
        darkView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        darkView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        darkView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        darkView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        darkView.alpha = isPresenting ? 0 : 1
        
        containerView.addSubview(toView)
        
        toView.frame = CGRect(x: 0, y: 0, width: width ?? containerView.frame.width - (2 * leftPadding), height: height ?? containerView.frame.height - (2 * topPadding))
        toView.center.x = containerView.center.x
        toView.center.y = containerView.center.y
        
        toView.transform = isPresenting ? CGAffineTransform(translationX: 0, y: containerView.frame.height) : CGAffineTransform.identity
        
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            if self.isPresenting {
                toView.transform = CGAffineTransform.identity
                self.darkView.alpha = 1
            }else {
                toView.transform = CGAffineTransform(translationX: 0, y: containerView.frame.height)
                self.darkView.alpha = 0
            }
        }) { (success) in
            transitionContext.completeTransition(success)
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = true
        self.height = 250
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = false
        return self
    }
}

