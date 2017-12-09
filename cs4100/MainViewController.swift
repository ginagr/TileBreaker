//
//  MainViewController.swift
//  cs4100
//
//  Created by GGR on 12/9/17.
//  Copyright © 2017 ggr. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func levelOneSwitch(_ sender: UIButton) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        viewController.level = 1
        self.present(viewController, animated:false, completion:nil)
    }
    @IBAction func levelTwoSwitch(_ sender: UIButton) {
//        let viewController = ViewController()
//        viewController.levelChange(newLevel: 2)
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        viewController.level = 2
        self.present(viewController, animated:false, completion:nil)
    }
    @IBAction func levelThreeSwitch(_ sender: UIButton) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        viewController.level = 3
        self.present(viewController, animated:false, completion:nil)
    }
}
