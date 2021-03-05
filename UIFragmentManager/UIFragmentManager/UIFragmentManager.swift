        //
//  UIFragmentManager.swift
//  UIFragmentManager
//
//  Created by Jeytery on 2/11/21.
//  Copyright © 2021 Epsillent. All rights reserved.
//

import UIKit

class UIFragmentManager {

    ///all your fragments in the applications
    public var fragments = [UIFragmentDelegate?]()

    ///singleton
    public static var shared = UIFragmentManager()
    
    //MARK: - private functions
    private func checkFragment(_ fragmentVC: UIViewController, _ completion: (() -> Void)?) {
        for i in 0..<fragments.count {
            if fragmentVC == fragments[i]!.fragmentVC {
                fragments[i]!.show(completion: completion)
                return
            }
        }
    }
    
    private func findTopController() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    //MARK: - public functions
    
    ///will automatically define top controller as parent or display fragment on core UIWindow
    public func show(fragmentVC: UIViewController, parameters: UIFragmentParameters, completion: (() -> Void)?) {
        checkFragment(fragmentVC, completion)
        let fragmentDelegate = UIFragmentDelegate(fragmentVC: fragmentVC, parameters: parameters)
        parameters.gesture.fragmentDelegate = fragmentDelegate
        fragments.append(fragmentDelegate)
        fragmentDelegate.show(completion: completion)
    }
    
    ///will show on parentVC
    public func show(parentVC: UIViewController, fragmentVC: UIViewController, parameters: UIFragmentParameters, completion: (() -> Void)?) {
        checkFragment(fragmentVC, completion)
        let fragmentDelegate = UIFragmentDelegate(parentVC: parentVC, fragmentVC: fragmentVC, parameters: parameters)
        parameters.gesture.fragmentDelegate = fragmentDelegate
        fragments.append(fragmentDelegate)
        fragmentDelegate.show(completion: completion)
    }
    
    ///find and hide fragmentVC
    public func hide(fragmentVC: UIViewController, completion: (() -> Void)?) {
        for i in 0..<fragments.count {
            if fragmentVC == fragments[i]!.fragmentVC {
                fragments[i]!.hide(completion: completion)
                fragments[i] = nil
                fragments.remove(at: i)
            }
        }
    }

    ///hide all fragments
    public func hideAll() {
        for i in 0..<fragments.count {
            fragments[i]?.hide(completion: nil)
        }
    }

    //MARK: - test //////////
    public func showOnVC(fragmentVC: UIViewController, parameters: UIFragmentParameters) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.view.backgroundColor = .red
            let fragment = UIFragmentDelegate(parentVC: topController, fragmentVC: fragmentVC, parameters: parameters)
            parameters.gesture.fragmentDelegate = fragment
            fragments.append(fragment)
            fragment.show(completion: nil)
        }
    }

}
