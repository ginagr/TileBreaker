//
//  TutorialController.swift
//  TileBreaker
//
//  Created by GGR on 1/2/18.
//  Copyright © 2018 ggr. All rights reserved.
//

import UIKit

class TutorialController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.isScrollEnabled = true
        scrollView.contentSize.height = stackView.frame.height //UIScreen.main.bounds.height
    }
}
