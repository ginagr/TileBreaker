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
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GameStoryboard") as! ViewController
        self.present(nextViewController, animated:false, completion:nil)
//        ViewController.levelChange(1)
    }
    @IBAction func levelTwoSwitch(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GameStoryboard") as! ViewController
        self.present(nextViewController, animated:false, completion:nil)
//        ViewController.levelChange(2)
    }
    @IBAction func levelThreeSwitch(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GameStoryboard") as! ViewController
        self.present(nextViewController, animated:false, completion:nil)
//        ViewController.levelChange(3)
    }
}
