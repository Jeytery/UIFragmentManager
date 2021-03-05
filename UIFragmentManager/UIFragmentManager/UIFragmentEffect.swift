//
//  UIFragmentEffect.swift
//  UIFragmentManager
//
//  Created by Jeytery on 2/13/21.
//  Copyright © 2021 Epsillent. All rights reserved.
//

import Foundation
import UIKit

protocol UIFragmentEffect {
    var diaposon: ClosedRange<Float> { get }
    var intensity: CGFloat { get }
    var fragmentVC: UIViewController { get set }

    func show(fragmentVC: UIViewController)
    func show(parentVC: UIViewController, fragmentVC: UIViewController)

    func hide()
    func resetAlpha()
    func setAlpha(value: Float)

    init(intensity: CGFloat)
    init(fragmentVC: UIViewController, intensity: CGFloat)
}

extension UIFragmentEffect {
    var diaposon: ClosedRange<Float> {
        get {
            return Float(0)...Float(self.intensity)
        }
    }
}

class BlackoutEffect: UIFragmentEffect {

    private var view = UIView()
    
    public var intensity: CGFloat = 0

    public var diaposon: ClosedRange<Float> {
        get {
            return Float(0)...Float(intensity)
        }
    }

    public var fragmentVC: UIViewController = UIViewController()

    required init(intensity: CGFloat) {
        self.intensity = intensity
    }

    required init(fragmentVC: UIViewController, intensity: CGFloat) {
        self.intensity = intensity
        view.frame = UIFragmentDelegate.window!.frame
        view.backgroundColor = .black
        view.alpha = 0
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapCloseGesture))
        view.addGestureRecognizer(recognizer)
        self.fragmentVC = fragmentVC
    }

    @objc func tapCloseGesture() {
        print("hide")
        UIFragmentManager.shared.hide(fragmentVC: self.fragmentVC, completion: nil)
    }

    private func configureView() {
        view.frame = UIFragmentDelegate.window!.frame
        view.backgroundColor = .black
        view.alpha = 0
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapCloseGesture))
        view.addGestureRecognizer(recognizer)
    }

    public func resetAlpha() {
        UIView.animate(
        withDuration: 0.5,
        delay: 0,
        usingSpringWithDamping: 1.0,
        initialSpringVelocity: 1.0,
        options: .curveEaseIn,
        animations: {
            self.view.alpha = self.intensity
        }, completion: nil)
    }

    public func show(fragmentVC: UIViewController) {
        configureView()
        UIFragmentDelegate.window!.insertSubview(view, belowSubview: fragmentVC.view)
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: .curveEaseIn,
            animations: {
                self.view.alpha = self.intensity
            }, completion: nil)
    }

    public func show(parentVC: UIViewController, fragmentVC: UIViewController) {
        configureView()
        parentVC.view.insertSubview(view, belowSubview: fragmentVC.view)
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: .curveEaseIn,
            animations: {
                self.view.alpha = self.intensity
            }, completion: nil)
    }

    public func hide() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: .curveEaseIn,
            animations: {
                self.view.alpha = 0
            }, completion: { _ in
                self.view.removeFromSuperview()
            })
    }

    public func setAlpha(value: Float) {
        self.view.alpha = CGFloat(value)
    }
}
