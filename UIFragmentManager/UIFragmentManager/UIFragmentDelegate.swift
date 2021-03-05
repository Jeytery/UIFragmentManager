//
//  UIFragmentDelegate.swift
//  UIFragmentManager
//
//  Created by Jeytery on 2/11/21.
//  Copyright © 2021 Epsillent. All rights reserved.
//

import UIKit

class UIFragmentDelegate {

    public var fragmentVC: UIViewController

    public var parentVC: UIViewController?

    public var parameters: UIFragmentParameters

    public var screenSize = UIScreen.main.bounds

    private var isToogled = false

    static var window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })

    private func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.fragmentVC.view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.fragmentVC.view.layer.mask = mask
    }
    
    public func showFrame(_ frame: FragmentData, _ fragmentVC: UIViewController) {
        UIView.animate(
        withDuration: 0.5,
        delay: 0,
        usingSpringWithDamping: 1.0,
        initialSpringVelocity: 1.0,
        options: .curveEaseIn,
        animations: {
            fragmentVC.view.frame = CGRect(x: frame.deltaX, y: frame.deltaY, width: frame.width, height: frame.height)
        }, completion: nil)
    }

    private func hideFrame(_ frame: FragmentData, _ fragmentVC: UIViewController) {
        UIView.animate(
        withDuration: 0.5,
        delay: 0,
        usingSpringWithDamping: 1.0,
        initialSpringVelocity: 1.0,
        options: .curveEaseIn,
        animations: {
            fragmentVC.view.frame = CGRect(x: frame.x, y: frame.y, width: frame.width, height: frame.height)
        }, completion: nil)
    }

    public init(fragmentVC: UIViewController, parameters: UIFragmentParameters) {
        self.fragmentVC = fragmentVC
        self.parameters = parameters
        fragmentVC.view.frame = CGRect(x: parameters.fragmentData.x, y: parameters.fragmentData.y, width: parameters.fragmentData.width, height: parameters.fragmentData.height)
        roundCorners(corners: parameters.cornersCurves.corners, radius: CGFloat(parameters.cornersCurves.radius))
        fragmentVC.view.addPanGesture(target: parameters.gesture, action: #selector(parameters.gesture.gesture))
        parameters.effect.fragmentVC = self.fragmentVC
    }

    public init(parentVC: UIViewController, fragmentVC: UIViewController, parameters: UIFragmentParameters) {
        self.fragmentVC = fragmentVC
        self.parameters = parameters
        self.parentVC = parentVC
        fragmentVC.view.frame = CGRect(x: parameters.fragmentData.x, y: parameters.fragmentData.y, width: parameters.fragmentData.width, height: parameters.fragmentData.height)
        roundCorners(corners: parameters.cornersCurves.corners, radius: CGFloat(parameters.cornersCurves.radius))
        fragmentVC.view.addPanGesture(target: parameters.gesture, action: #selector(parameters.gesture.gesture))
        parameters.effect.fragmentVC = self.fragmentVC
    }

    public func show(completion: (() -> Void)?) {
        guard isToogled == false else { return }
        if parentVC != nil {
            print("parentVC is not nil")
            parentVC?.addChild(fragmentVC)
            parentVC?.view.addSubview(fragmentVC.view)
            parameters.effect.show(parentVC: parentVC!, fragmentVC: fragmentVC)
        } else {
            UIFragmentDelegate.window?.insertSubview(fragmentVC.view, at: parameters.layer)
            parameters.effect.show(fragmentVC: fragmentVC)
        }
        showFrame(parameters.fragmentData, fragmentVC)
        isToogled = true
        completion?()
    }

    public func hide(completion: (() -> Void)?) {
        guard isToogled == true else { return }
        isToogled = false
        parameters.effect.hide()
        hideFrame(parameters.fragmentData, fragmentVC)
        completion?()
    }

    //MARK: - test //////////
    public func showOnVC() {

    }

}

extension UIView {
    func addPanGesture(target: Any, action: Selector) {
        let tap = UIPanGestureRecognizer(target: target, action: action)
        addGestureRecognizer(tap)
    }
}
