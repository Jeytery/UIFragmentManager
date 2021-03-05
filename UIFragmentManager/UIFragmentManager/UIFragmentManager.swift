        //
//  UIFragmentManager.swift
//  UIFragmentManager
//
//  Created by Jeytery on 2/11/21.
//  Copyright © 2021 Epsillent. All rights reserved.
//

import UIKit

class UIFragmentManager {

    public var popUpWindow = UIWindow(frame: UIScreen.main.bounds)

    public var fragments = [UIFragmentDelegate?]()

    public static var shared = UIFragmentManager()

    static var rootVC = UIViewController()

    private init() {

    }

    public func show(fragmentVC: UIViewController, parameters: UIFragmentParameters) {
        UIFragmentDelegate.window?.windowLevel = .statusBar
        for i in 0..<fragments.count {
            if fragmentVC == fragments[i]!.fragmentVC {
                fragments[i]!.show(completion: nil)
                return
            }
        }
        let fragmentDelegate = UIFragmentDelegate(fragmentVC: fragmentVC, parameters: parameters)
        parameters.gesture.fragmentDelegate = fragmentDelegate
        fragments.append(fragmentDelegate)
        fragmentDelegate.show(completion: nil)
    }

    public func hide(fragmentVC: UIViewController) {
        for i in 0..<fragments.count {
            if fragmentVC == fragments[i]!.fragmentVC {
                fragments[i]!.hide(completion: nil)
                fragments[i] = nil
                fragments.remove(at: i)
            }
        }
    }

    public func show(fragmentVC: UIViewController, parameters: UIFragmentParameters, completion: (() -> Void)?) {
        for i in 0..<fragments.count {
            if fragmentVC == fragments[i]!.fragmentVC {
                fragments[i]!.show(completion: completion)
                return
            }
        }
        let fragmentDelegate = UIFragmentDelegate(fragmentVC: fragmentVC, parameters: parameters)
        parameters.gesture.fragmentDelegate = fragmentDelegate
        fragments.append(fragmentDelegate)
        fragmentDelegate.show(completion: completion)
    }

    public func hide(fragmentVC: UIViewController, completion: (() -> Void)?) {
        for i in 0..<fragments.count {
            if fragmentVC == fragments[i]!.fragmentVC {
                fragments[i]!.hide(completion: completion)
                fragments[i] = nil
                fragments.remove(at: i)
            }
        }
    }

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
            fragments.append(fragment)
            fragment.show(completion: nil)
        }
    }

}
