//
//  MainController.swift
//  TileBreaker
//
//  Created by GGR on 12/25/17.
//  Copyright © 2017 ggr. All rights reserved.
//
import UIKit

class MainController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func movesLevel(_ sender: UIButton) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "MovesController") as! MovesController
        self.present(viewController, animated:false, completion:nil)
    }
    
    @IBAction func timedLevel(_ sender: UIButton) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "TimedLevelController") as! TimedLevelController
        self.present(viewController, animated:false, completion:nil)
    }
}
