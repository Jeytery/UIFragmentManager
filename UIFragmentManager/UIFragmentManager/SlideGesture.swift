//
//  SlideGesture.swift
//  UIFragmentManager
//
//  Created by Jeytery on 2/28/21.
//  Copyright © 2021 Epsillent. All rights reserved.
//

import UIKit

class SlideGesture: UIFragmentGesture {

    private var frameIncForSide: ((CGPoint) -> CGFloat)? = nil

    private var makeFinalTranslationForSide: ((UIPanGestureRecognizer) -> Void)? = nil

    private func completion(value: Float) {
        let deadlock = self.deadlock
        switch fragmentDelegate!.parameters.side {
        case .bottom:
            if value < Float(Float(deadlock) + Float(idleState)) { // minY
                fragmentDelegate!.showFrame(fragmentDelegate!.parameters.fragmentData,fragmentDelegate!.fragmentVC)
                fragmentDelegate!.parameters.effect.resetAlpha()
            } else {
                UIFragmentManager.shared.hide(fragmentVC: fragmentDelegate!.fragmentVC)
            }
            break
        case .top:
            if value + Float(fragmentDelegate!.parameters.edges.top) > Float(deadlock) - Float(idleState) { // maxY
                fragmentDelegate!.showFrame(fragmentDelegate!.parameters.fragmentData,fragmentDelegate!.fragmentVC)
                fragmentDelegate!.parameters.effect.resetAlpha()
            } else {
                UIFragmentManager.shared.hide(fragmentVC: fragmentDelegate!.fragmentVC)
            }
        case .left:
            if value + Float(fragmentDelegate!.parameters.edges.left) > Float(deadlock) - Float(idleState) { // maxX
                fragmentDelegate!.showFrame(fragmentDelegate!.parameters.fragmentData,fragmentDelegate!.fragmentVC)
                fragmentDelegate!.parameters.effect.resetAlpha()
            } else {
                UIFragmentManager.shared.hide(fragmentVC: fragmentDelegate!.fragmentVC)
            }
        case .right:
            if value - Float(fragmentDelegate!.parameters.edges.right) < Float(deadlock) + Float(idleState) { // minX
                fragmentDelegate!.showFrame(fragmentDelegate!.parameters.fragmentData,fragmentDelegate!.fragmentVC)
                fragmentDelegate!.parameters.effect.resetAlpha()
            } else {
                UIFragmentManager.shared.hide(fragmentVC: fragmentDelegate!.fragmentVC)
            }
        }
    }

    private func frameInc(translation: CGPoint) -> CGFloat {
        let deadlock = self.deadlock
        switch fragmentDelegate!.parameters.side {
        case .bottom:
            let dframe = fragmentDelegate!.fragmentVC.view.layer.frame.minY - deadlock
            if fragmentDelegate!.fragmentVC.view.frame.origin.y < deadlock { return fragmentDelegate!.fragmentVC.view.frame.origin.y } // guard >=
            else if -translation.y > CGFloat(dframe) { return deadlock }
            return fragmentDelegate!.fragmentVC.view.frame.origin.y + translation.y
        case .left:
            let dframe: Double = Double(deadlock - fragmentDelegate!.fragmentVC.view.layer.frame.maxX)
            if fragmentDelegate!.fragmentVC.view.frame.maxX > deadlock { return 0 + CGFloat(fragmentDelegate!.parameters.edges.left) } // guard <=
            else if translation.x > CGFloat(dframe) { return 0 + CGFloat(fragmentDelegate!.parameters.edges.left) }
            return fragmentDelegate!.fragmentVC.view.frame.origin.x + translation.x
        case .right:
            let dframe = fragmentDelegate!.fragmentVC.view.frame.minX - deadlock
            if fragmentDelegate!.fragmentVC.view.frame.minX < deadlock { return deadlock }
            else if -translation.x > CGFloat(dframe) { return deadlock }
            return fragmentDelegate!.fragmentVC.view.frame.origin.x + translation.x
        case .top:
            let dframe = deadlock - fragmentDelegate!.fragmentVC.view.frame.maxY
            if fragmentDelegate!.fragmentVC.view.frame.maxY > deadlock { return CGFloat(fragmentDelegate!.parameters.edges.top) } // guard >=
            else if translation.y > CGFloat(dframe) { return CGFloat(fragmentDelegate!.parameters.edges.top) }
            return fragmentDelegate!.fragmentVC.view.frame.origin.y + translation.y
        }
    }

    override func gestureLogic(_ sender: UIPanGestureRecognizer) {
        let view = sender.view!
        switch sender.state {
        case .changed:
            if fragmentDelegate?.parameters.side == .top || fragmentDelegate?.parameters.side == .bottom {
                let translation = sender.translation(in: view)
                view.frame.origin = CGPoint(x: CGFloat(fragmentDelegate!.parameters.edges.left), y: frameInc(translation: translation))
                fragmentDelegate!.parameters.effect.setAlpha(value: getAlphaForEffectRelativelyFragmentPosition(value: fragmentDelegate!.parameters.side == .bottom ? Float(fragmentDelegate!.fragmentVC.view.frame.minY - CGFloat(fragmentDelegate!.parameters.edges.bottom)) : Float(fragmentDelegate!.fragmentVC.view.frame.maxY + CGFloat(fragmentDelegate!.parameters.edges.bottom))) )
                sender.setTranslation(CGPoint.zero, in: view)
            }

            if fragmentDelegate?.parameters.side == .left || fragmentDelegate?.parameters.side == .right {
                let translation = sender.translation(in: view)
                view.frame.origin = CGPoint(x: frameInc(translation: translation), y: CGFloat(fragmentDelegate!.parameters.edges.top))

                print(getAlphaForEffectRelativelyFragmentPosition(value: fragmentDelegate!.parameters.side == .left ? Float(fragmentDelegate!.fragmentVC.view.frame.maxX + CGFloat(fragmentDelegate!.parameters.edges.left)) : Float(fragmentDelegate!.fragmentVC.view.frame.minX - CGFloat(fragmentDelegate!.parameters.edges.right))))

                fragmentDelegate!.parameters.effect.setAlpha(value: getAlphaForEffectRelativelyFragmentPosition(value: fragmentDelegate!.parameters.side == .left ? Float(fragmentDelegate!.fragmentVC.view.frame.maxX + CGFloat(fragmentDelegate!.parameters.edges.left)) : Float(fragmentDelegate!.fragmentVC.view.frame.minX - CGFloat(fragmentDelegate!.parameters.edges.right))))
                sender.setTranslation(CGPoint.zero, in: view)
            }
            break
        case .ended:
            if fragmentDelegate?.parameters.side == .top || fragmentDelegate?.parameters.side == .bottom {
                completion(value: fragmentDelegate!.parameters.side == .bottom ? Float(fragmentDelegate!.fragmentVC.view.frame.minY - CGFloat(fragmentDelegate!.parameters.edges.bottom)) : Float(fragmentDelegate!.fragmentVC.view.frame.maxY + CGFloat(fragmentDelegate!.parameters.edges.top)))
            }

            if fragmentDelegate?.parameters.side == .left || fragmentDelegate?.parameters.side == .right {
                completion(value: fragmentDelegate!.parameters.side == .left ? Float(fragmentDelegate!.fragmentVC.view.frame.maxX - CGFloat(fragmentDelegate!.parameters.edges.left)) : Float(fragmentDelegate!.fragmentVC.view.frame.minX + CGFloat(fragmentDelegate!.parameters.edges.right)) )
            }
            break
        default:
            break
        }
    }
}
