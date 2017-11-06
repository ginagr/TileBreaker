//
//  ViewController.swift
//  cs4100
//
//  Created by GGR on 11/6/17.
//  Copyright © 2017 ggr. All rights reserved.
//

import UIKit

extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
       
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var button01: UIButton!
    
    var isHighLighted:Bool = false
    var firstColor: UIColor!
    var firstButton: UIButton!
    
    var btnY = 5
    let btnHeight = 40
    var buttonArray=["Button 1","Button 2","Button 3"," Button 4", "Button 5"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
//        addButtonsUsingStackView()
        
        for view in self.view.subviews as [UIView] {
            if let btn = view as? UIButton {
                let myColor: UIColor = .random;
                btn.backgroundColor = myColor;
            }
        }
    }

    func addButtonsUsingStackView()
    {
        
//        for view in self.view.subviews{
//            view.removeFromSuperview()
//        }
//
//        for i in 1...5 {
//
//            let btnFloor = UIButton()
//            btnFloor.backgroundColor = UIColor.orange
//            btnFloor.titleLabel?.textColor = UIColor.white
//            btnFloor.frame = CGRect(x: 10, y: btnY, width: Int(scrllView.frame.width - 20), height: btnHeight)
//            btnFloor.contentMode = UIViewContentMode.scaleToFill
//            btnY += btnHeight + 5
//            btnFloor.addTarget(self, action: #selector(self.btnTappedFloor(_:)), for: UIControlEvents.touchUpInside)
//            self.view.addSubview(btnFloor)
//        }
    }
    
    @objc func btnTappedFloor( _ button : UIButton)
    {
        buttonArray.remove(at: button.tag)
        addButtonsUsingStackView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func clickButton(_ sender: UIButton, forEvent event: UIEvent) {
    
        if isHighLighted == false { //first button already clicked
          
            sender.layer.shadowOpacity = 0.5 //add shadow
            isHighLighted = true;
            
            firstColor = sender.backgroundColor; //save color
            firstButton = sender; //save button

        } else {
            
            UIButton.animate(withDuration: 0.75) {
                self.firstButton.layer.shadowOpacity = 0.0 //shadow
                self.firstButton.backgroundColor = sender.backgroundColor; //switch colors
                sender.backgroundColor = self.firstColor;
            }

            isHighLighted = false //reset
        }
        
    }
}

