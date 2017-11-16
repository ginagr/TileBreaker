//
//  ViewController.swift
//  cs4100
//
//  Created by GGR on 11/6/17.
//  Copyright © 2017 ggr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pattern1: UIButton!
    @IBOutlet weak var pattern2: UIButton!
    @IBOutlet weak var pattern3: UIButton!
    @IBOutlet weak var pattern4: UIButton!
    @IBOutlet weak var pattern5: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var gameOverButton: UIButton!
    @IBOutlet weak var gameOverText: UITextField!
    @IBOutlet weak var scoreText: UILabel!
    @IBOutlet weak var highScoreText: UILabel!
    
    var level = 1
    
    var isHighLighted:Bool = false
    var firstColor: UIColor!
    var firstButton: UIButton!
    
    var colorArray=[UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow, UIColor.orange]
    
    var allButtons = [UIButton] ()
    var patternButtons = [UIButton] ()
    
    var patternFound:Bool = false
    
    //get screen sizes
    let screenSize = UIScreen.main.bounds
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var gameTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.borderWidth = 3.0;
        
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        gameOverLabel.layer.borderColor = UIColor.black.cgColor
        gameOverLabel.layer.borderWidth = 3.0;
        
        //TODO: change back to 2
        gameTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(addBlock), userInfo: nil, repeats: true)
        
        //append all pattern buttons to array
        patternButtons.append(pattern1)
        patternButtons.append(pattern2)
        patternButtons.append(pattern3)
        patternButtons.append(pattern4)
        patternButtons.append(pattern5)
        
        updatePattern()
        
    }
    
    func updatePattern() {
        for button in patternButtons { //hide pattern buttons
            button.isHidden = true
        }
        
        var pattern = [UIColor] ()
        pattern = generateRandomPattern(level) //get randomly generated pattern
        
        for (index, element) in pattern.enumerated() { //put pattern in pattern buttons
            patternButtons[index].backgroundColor = element
            patternButtons[index].isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addBlock() {
        let height = (screenHeight/20)
        let button = UIButton(frame: CGRect(x: 20, y: 0, width: 150, height: height - 5))
        button.backgroundColor = colorArray[generateRandomColor(level)]
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        
        allButtons.insert(button, at: 0)
        self.view.addSubview(button)
        
        moveButtonsDown()
    }
    
    func moveButtonsDown() {
        let x = allButtons[0].frame.origin.x
        let height = (screenHeight/20)
        let width = allButtons[0].frame.size.width
            for index in 0...allButtons.count-1 {
                let y = height * CGFloat(index)
                UIView.animate(withDuration: 0.1, animations:{
                    self.allButtons[index].frame = CGRect(x: x, y: y, width: width, height: height - 5)
                })
            }
            if (allButtons[allButtons.count-1].frame.origin.y) > (screenHeight - height - 1) {
                gameOver()
            } else {
                if allButtons.count > 2 {
                    checkPattern()
                }
        }
    }
    
    @IBAction func clickButton(sender: UIButton!) {
        if isHighLighted == false { //first button already clicked
            sender.layer.shadowOpacity = 1.0 //add shadow
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
            checkPattern()
        }
    }
    
    func generateRandomColor(_ level:Int) -> Int {
        if level == 1 { //three colors
            return Int(arc4random_uniform(UInt32(3)))
        } else if level == 2 { //four colors
            return Int(arc4random_uniform(UInt32(4)))
        } else { //five colors
            return Int(arc4random_uniform(UInt32(5)))
        }
    }
    
    //TODO: make sure there is at least of one color
    func generateRandomPattern(_ level:Int) -> [UIColor] {
        if level == 1 { //three colors, pattern of three
            let pattern = [colorArray[0], colorArray[1], colorArray[2]]
            return shuffleColor(array: pattern)
        } else if level == 2 {//four colors, pattern of four
            let pattern = [colorArray[0], colorArray[1], colorArray[2], colorArray[3]]
            return shuffleColor(array: pattern)
        } else { //five colors, pattern of five
            let pattern = [colorArray[0], colorArray[1], colorArray[2], colorArray[3], colorArray[4]]
            return shuffleColor(array: pattern)
        }
    }
    
    func shuffleColor(array: [UIColor]) -> [UIColor] {
        var tempArray = array
        for _ in 0...5 {
            for index in 0...array.count - 1 {
                let rand = Int(arc4random_uniform(UInt32(array.count - 1)))
                let temp = tempArray[index]
                tempArray[index] = tempArray[rand]
                tempArray[rand] = temp
            }
        }
        return tempArray
    }
    
    func checkPattern() {
        switch level {
        case 1:
            for index in 0...(allButtons.count-3) {
                if allButtons[index].backgroundColor == pattern1.backgroundColor {
                    if allButtons[index+1].backgroundColor == pattern2.backgroundColor {
                        if allButtons[index+2].backgroundColor == pattern3.backgroundColor {
                            patternFound(index: index)
                        }
                    }
                }
            }
            break;
        case 2:
            for index in 0...(allButtons.count-4) {
                if allButtons[index].backgroundColor == pattern1.backgroundColor {
                    if allButtons[index+1].backgroundColor == pattern2.backgroundColor {
                        if allButtons[index+2].backgroundColor == pattern3.backgroundColor {
                            if allButtons[index+3].backgroundColor == pattern4.backgroundColor {
                                patternFound(index: index)
                            }
                        }
                    }
                }
            }
            break;
        default:
            for index in 0...(allButtons.count-5) {
                if allButtons[index].backgroundColor == pattern1.backgroundColor {
                    if allButtons[index+1].backgroundColor == pattern2.backgroundColor {
                        if allButtons[index+2].backgroundColor == pattern3.backgroundColor {
                            if allButtons[index+3].backgroundColor == pattern4.backgroundColor {
                                if allButtons[index+4].backgroundColor == pattern5.backgroundColor {
                                    patternFound(index: index)
                                }
                            }
                        }
                    }
                }
            }
            break;
        }
    }
    
    func patternFound(index: Int) {
        print("INDEX: \(index)")
        let newScore = Int(scoreText.text!)! + 1
        scoreText.text = String(newScore)
        gameTimer.invalidate()
        patternFound = true
        if level == 1 {
            allButtons[index].backgroundColor = UIColor.black
            allButtons[index+1].backgroundColor = UIColor.black
            allButtons[index+2].backgroundColor = UIColor.black
            
            let width = allButtons[index].frame.size.width
            let height = allButtons[index].frame.size.height
            let x = allButtons[index].frame.origin.x
            
            UIView.animate(withDuration: 0.7, animations:{
                self.allButtons[index].frame = CGRect(x: x + self.screenWidth, y: self.allButtons[index].frame.origin.y, width: width, height: height)
                self.allButtons[index+1].frame = CGRect(x: x + self.screenWidth, y: self.allButtons[index+1].frame.origin.y, width: width, height: height)
                self.allButtons[index+2].frame = CGRect(x: x + self.screenWidth, y: self.allButtons[index+2].frame.origin.y, width: width, height: height)
                
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.allButtons[index].removeFromSuperview()
                    self.allButtons[index+1].removeFromSuperview()
                    self.allButtons[index+2].removeFromSuperview()
                    
                    self.allButtons.remove(at: index)
                    self.allButtons.remove(at: index)
                    self.allButtons.remove(at: index)
                    
                    self.moveButtonsUp(i: index)
                    self.patternFound = false
                    
                    //TODO: change back to 2
                    self.gameTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.addBlock), userInfo: nil, repeats: true)
                }
            })
            
            //            if index+2 < allButtons.count {
            //                UIView.animate(withDuration: 1.0, animations:{
            //                    let diff = 3 * (self.screenHeight/20)
            //                    for i in (index+3)...(self.allButtons.count-1) {
            //                        self.allButtons[i].frame = CGRect(x: x, y: self.allButtons[i].frame.origin.y - diff, width: width, height: height)
            //                    }
            //                })
            //            }
            
            //            for i in (-1...(index+2)).reversed() {
            //
            //                UIView.animate(withDuration: 1.0, animations:{
            //                    let button = self.allButtons[index]
            //                    button.frame = CGRect(x: button.frame.origin.x + 25, y: button.frame.origin.y + 25, width: button.frame.size.width, height: button.frame.size.height)
            //                })
            
            //            }
            
            
            //            if index > 2 { //make sure in bounds
            //                allButtons[index].backgroundColor = allButtons[index-3].backgroundColor
            //                allButtons[index+1].backgroundColor = allButtons[index-2].backgroundColor
            //                allButtons[index+2].backgroundColor = allButtons[index-1].backgroundColor
            //            }
        }
    }
    
    func moveButtonsUp(i: Int) {
        UIView.animate(withDuration: 0.3, animations:{
            let diff = 3 * (self.screenHeight/20)
            if i <= self.allButtons.count-1 {
                for index in i...(self.allButtons.count-1) {
                    let idiff = self.allButtons[index].frame.origin.y - diff
                    self.allButtons[index].frame = CGRect(x: self.allButtons[index].frame.origin.x, y: idiff, width: self.allButtons[index].frame.size.width, height: self.allButtons[index].frame.size.height)
                }
            }
        })
    }
    
    func updateButtons() {
        
        allButtons.removeAll()
        var count = 0
        for view in self.view.subviews as [UIView] {
            if let btn = view as? UIButton {
                if btn.titleLabel?.text != "pattern" {
                    allButtons.append(btn)
                    //                    btn.setTitle("Number \(count)", for: .normal)
                    count = count + 1
                }
            }
        }
    }
    
    func gameOver() { //tiles have reached bottom of screen
        gameTimer.invalidate() //stop timer
        view.bringSubview(toFront: gameOverLabel)
        view.bringSubview(toFront: gameOverButton)
        view.bringSubview(toFront: gameOverText)
        gameOverLabel.isHidden = false
        gameOverButton.isHidden = false
        gameOverText.isHidden = false
        
        if Int(highScoreText.text!)! < Int(scoreText.text!)! {
            highScoreText.text = scoreText.text
        }
    }
    
    @IBAction func restartGame(_ sender: UIButton) {
        print("restarting game")
        for (_, element) in allButtons.enumerated() {
            element.removeFromSuperview()
        }
        gameOverLabel.isHidden = true
        gameOverButton.isHidden = true
        gameOverText.isHidden = true
        
        scoreText.text = "0"
        
        allButtons.removeAll()
        
        updatePattern()
        
        //TODO: change back to 2
        gameTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.addBlock), userInfo: nil, repeats: true)
    }
}

