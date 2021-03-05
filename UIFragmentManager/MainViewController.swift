//
//  MainViewController.swift
//  UIFragmentManager
//
//  Created by Jeytery on 2/13/21.
//  Copyright © 2021 Epsillent. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var fragmentVC: ChildViewController?

    var param = UIFragmentParameters(side: .bottom,
                                     intend: 400,
                                     edges: (bottom: 20, top: 20, left: 20, right: 20),
                                     layer: 1,
                                     effect: BlackoutEffect(intensity: 0),
                                     gesture: SlideGesture(),
                                     cornersCurves: (corners: [.allCorners], radius: 15)
    )

    @IBAction func hide(_ sender: Any) {
        let vc = UIViewController()
        vc.view.backgroundColor = .darkGray
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func action(_ sender: Any) {
        fragmentVC = ChildViewController()
        fragmentVC!.view.backgroundColor = .cyan
        //UIFragmentManager.shared.show(fragmentVC: fragmentVC!, parameters: param)
        UIFragmentManager.shared.showOnVC(fragmentVC: fragmentVC!, parameters: param)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
