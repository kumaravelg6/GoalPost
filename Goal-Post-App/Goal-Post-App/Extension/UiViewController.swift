//
//  UiViewController.swift
//  Goal-Post-App
//
//  Created by Kumaravel G on 1/30/23.
//  Copyright © 2023 Kumaravel G. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentDetail(viewControllerToPresent: UIViewController) { //func to animate the view in with a custom animation
        let transition = CATransition() //an animation
        transition.duration = 0.3
        transition.type = kCATransitionFade //a type of animation, the way the view controller slides in
        transition.subtype = kCATransitionFromRight //begins at the right side
        self.view.window?.layer.add(transition, forKey: kCATransition)//access the layer of the view
        
        present(viewControllerToPresent, animated: false, completion: nil) //false bcuz we already ovveride the animation
    }
    
    func presentSecondaryDetail(viewControllerToPresent: UIViewController) {
        let transition = CATransition() //an animation
        transition.duration = 0.3
        transition.type = kCATransitionFade //a type of animation, the way the view controller slides in
        transition.subtype = kCATransitionFromRight //begins at the right side
        
        guard let presentedViewController = presentedViewController else { return } //hold the presented view controller we're in
        
        presentedViewController.dismiss(animated: false) { //once the view controller that was there before us gets dismissed, then we add this new VC
            self.view.window?.layer.add(transition, forKey: kCATransition)
            self.present(viewControllerToPresent, animated: false, completion: nil)
        }
    }
    
    func dismissDetail() { //to dismiss the view with a custom animation
        let transition = CATransition() //an animation
        transition.duration = 0.3
        transition.type = kCATransitionFade //a type of animation, the way the view controller slides in
        transition.subtype = kCATransitionFromLeft //begins at the left
        self.view.window?.layer.add(transition, forKey: kCATransition)//access the layer of the view
        
        dismiss(animated: false, completion: nil) //dismisses the view
    }
    
}
