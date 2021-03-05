//
//  UIFragmentGesture.swift
//  UIFragmentManager
//
//  Created by Jeytery on 2/11/21.
//  Copyright © 2021 Epsillent. All rights reserved.
//

import UIKit

class UIFragmentGesture {

    /* You can't use two fragments with gesture in the same time on screen */

    public weak var fragmentDelegate: UIFragmentDelegate?

    public static var shared = UIFragmentGesture()

    internal var screenSize = UIScreen.main.bounds

    internal var deadlock: CGFloat {
        get {
            switch fragmentDelegate!.parameters.side {
            case .bottom:
                return (self.screenSize.height - fragmentDelegate!.fragmentVC.view.frame.height) - CGFloat(fragmentDelegate!.parameters.edges.bottom)
            case .top:
                return fragmentDelegate!.fragmentVC.view.frame.height + CGFloat(fragmentDelegate!.parameters.edges.top)
            case .left:
                return 0 + fragmentDelegate!.fragmentVC.view.frame.width + CGFloat(fragmentDelegate!.parameters.edges.left)
            case .right:
                return self.screenSize.width - fragmentDelegate!.fragmentVC.view.frame.width - CGFloat(fragmentDelegate!.parameters.edges.right)
            }
        }
        /* F - fragment
            -___-                 -___-
           |     |               |  F  |
           |     |               |-----| <- deadlock
           |     |               |     |
           |-----| <- deadlock   |     |
           |  F  |               |     |
            -----                 -----
        */
    }

    /// zone of some fragment action, for example in slide gesture it is zone where fragment can't be closed
    internal var idleState: Int = 40
         /* F - fragment, above idleState point -> still show fragment, under idleState -> hide Fragment
            -___-
           |     |
     zone >|-----|
           |  F  |
     zone >|    -| <- idleState (fragment.topPoint + 40)
           |     |
            -----
        */

    internal func gestureLogic(_ sender: UIPanGestureRecognizer) {}

    @objc func gesture(_ sender: UIPanGestureRecognizer) {
        gestureLogic(sender)
    }

    ///standart animation in gesture
    internal func animate( animate: @escaping () -> Void, completion: ( () -> Void)? ) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: .curveEaseIn,
            animations: {
                animate()
            }, completion: { (status) in
                completion?()
        })
    }

    ///the name of fucntion is exactly what it do. For example value: 5 from: 0...5 to: 0...10 is 10
    internal func convertValueFromOneDiaposonToAnother(value: Float , from diaposonA: ClosedRange<Float>, to diaposonB: ClosedRange<Float>) -> Float {
        return (value-diaposonA.upperBound) / (diaposonA.lowerBound - diaposonA.upperBound) * (diaposonB.lowerBound - diaposonB.upperBound) + diaposonB.upperBound
    }

    /// read name
    internal func getAlphaForEffectRelativelyFragmentPosition(value: Float) -> Float {
        switch fragmentDelegate!.parameters.side {
        case .bottom:
            return Float(fragmentDelegate!.parameters.effect.intensity) - convertValueFromOneDiaposonToAnother(value: value, from: fragmentDelegate!.parameters.fragmentDiaposon, to: fragmentDelegate!.parameters.effect.diaposon)
        case .top:
            return convertValueFromOneDiaposonToAnother(value: value, from: fragmentDelegate!.parameters.fragmentDiaposon, to: fragmentDelegate!.parameters.effect.diaposon)
        case .left:
            return convertValueFromOneDiaposonToAnother(value: value, from: fragmentDelegate!.parameters.fragmentDiaposon, to: fragmentDelegate!.parameters.effect.diaposon)
        case .right:
            return Float(fragmentDelegate!.parameters.effect.intensity) - convertValueFromOneDiaposonToAnother(value: value, from: fragmentDelegate!.parameters.fragmentDiaposon, to: fragmentDelegate!.parameters.effect.diaposon)
        }
    }
}
