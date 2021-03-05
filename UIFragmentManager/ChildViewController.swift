//
//  ChildViewController.swift
//  UIFragmentManager
//
//  Created by Jeytery on 2/13/21.
//  Copyright © 2021 Epsillent. All rights reserved.
//

import UIKit

class ChildViewController: UIViewController {

    @IBAction func actioinButtonWasPressed(_ sender: Any) {
        let vc = UIViewController()
        vc.view.backgroundColor = .brown
        self.present(vc, animated: true, completion: {})
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ChildVC: allocated")
        // Do any additional setup after loading the view.
    }

    deinit {
        print("ChildVC: deallocated")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
