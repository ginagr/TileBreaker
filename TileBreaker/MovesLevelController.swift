//
//  MovesLevelController.swift
//  TileBreaker
//
//  Created by GGR on 12/25/17.
//  Copyright © 2017 ggr. All rights reserved.
//
import UIKit

class MovesLevelController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func levelOneSwitch(_ sender: UIButton) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "MovesController") as! MovesController
        viewController.level = 1
        self.present(viewController, animated:false, completion:nil)
    }
    
    @IBAction func levelTwoSwitch(_ sender: UIButton) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "MovesController") as! MovesController
        viewController.level = 2
        self.present(viewController, animated:false, completion:nil)
    }
    
    @IBAction func levelThreeSwitch(_ sender: UIButton) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "MovesController") as! MovesController
        viewController.level = 3
        self.present(viewController, animated:false, completion:nil)
    }
}

