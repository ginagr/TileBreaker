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
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var gameOverButton: UIButton!
    @IBOutlet weak var gameOverText: UITextField!
    @IBOutlet weak var gameOverMessage: UILabel!
    @IBOutlet weak var scoreText: UILabel!
    @IBOutlet weak var highScoreText: UILabel!
    
    var isHighLighted:Bool = false
    var firstColor: UIColor!
    var firstButton: UIButton!
    
    let colorArray = [UIColor(red:0.76, green:0.71, blue:0.93, alpha:1.0), UIColor(red:0.08, green:0.35, blue:0.40, alpha:1.0), UIColor(red:0.60, green:0.15, blue:0.35, alpha:1.0), UIColor(red:0.69, green:0.98, blue:0.97, alpha:1.0), UIColor(red:0.90, green:0.98, blue:0.62, alpha:1.0)]
    
    let tripleColor = UIColor(red:0.96, green:0.27, blue:0.85, alpha:1.0) //pink
    let patternColor = UIColor(red:0.52, green:0.97, blue:0.49, alpha:1.0) //green
    
    var allButtons = [UIButton] ()
    var patternButtons = [UIButton] ()
    
    var patternFound:Bool = false
    
    //Screen Sizes and Constants
    let screenSize = UIScreen.main.bounds
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var xConst: CGFloat!
    var heightConst: CGFloat!
    var widthConst: CGFloat!
    
    var gameTimer: Timer!
    var initialTime: Double!
    var speed = 2.0
    
    var level: Int!
    
    let userDefults = UserDefaults.standard //returns shared defaults object
    
    var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (level) == nil {
            level = 1
        }
        print("LEVEL: \(level)")
        if let highScore = userDefults.value(forKey: "highScore") { //check if highscore has been stored
            highScoreText.text = String(describing: highScore)
        }
        
        let date = NSDate()
        initialTime = date.timeIntervalSince1970
        
        //append all pattern buttons to array
        patternButtons.append(pattern1)
        patternButtons.append(pattern2)
        patternButtons.append(pattern3)
        
        // hide/unhide level boxes & pattern buttons
        if level == 1 {
            label = labelOne
            labelTwo.isHidden = true
            labelThree.isHidden = true
            pattern4.isHidden = true
            pattern5.isHidden = true
        } else if level == 2 {
            label = labelTwo
            labelOne.isHidden = true
            labelThree.isHidden = true
            patternButtons.append(pattern4)
            pattern5.isHidden = true
        } else {
            label = labelThree
            labelOne.isHidden = true
            labelTwo.isHidden = true
            patternButtons.append(pattern4)
            patternButtons.append(pattern5)
        }
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.borderWidth = 3.0;
        
        //set constants
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        xConst = screenWidth * 0.05
        heightConst = (screenHeight/20) - 5
        widthConst = (screenWidth/2) - (screenWidth * 0.05)
        
        gameOverLabel.layer.borderColor = UIColor.black.cgColor
        gameOverLabel.layer.borderWidth = 3.0;
        
        gameTimer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(addBlock), userInfo: nil, repeats: true)
        
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
        checkTime()
        let button = UIButton(frame: CGRect(x: xConst, y: 0, width: widthConst, height: heightConst))
        let tempColor = colorArray[generateRandomColor(level)]
        let tempText = checkGrammar(color: tempColor)
        if tempText.count < 1 {
            button.backgroundColor = tempColor
        } else {
            button.setTitle(tempText, for: .normal)
        }

        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        
        allButtons.insert(button, at: 0)
        self.view.addSubview(button)
        
        moveButtonsDown()
    }
    
    func checkTime() {
        let tempDate = NSDate()
        let diff = tempDate.timeIntervalSince1970 - initialTime
        if diff < 30 {
            return
        } else {
            if (diff > 30) && (diff < 60) {
                speed = 1.75
            } else if (diff > 59) && (diff < 90) {
                speed = 1.50
            } else if (diff > 89) && (diff < 120) {
                speed = 1.25
            } else if (diff > 119) && (diff < 150) {
                speed = 1.0
            } else if (diff > 149) && (diff < 240) {
                speed = 0.75
            } else if diff > 239 {
                speed = 0.50
            }
            gameTimer.invalidate()
            self.gameTimer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(self.addBlock), userInfo: nil, repeats: true)
        }
    }
    
    func checkGrammar(color: UIColor) -> String {
        if allButtons.count < 2 { //not enough colors to change grammar
            return ""
        } else {
            switch(level) {
            case 1:
                return levelOneGrammar(color: color)
            case 2:
                return levelTwoGrammar(color: color)
            case 3:
                return levelThreeGrammar(color: color)
            default:
                return ""
            }
        }
    }
    
    func levelOneGrammar(color: UIColor) -> String {
        let num = Int(widthConst/24) //make sure right num of emojis to fit phone size
        var text = ""
        var emoji = ""
        if allButtons[0].backgroundColor == color &&
            allButtons[1].backgroundColor == color { //three colors in a row
            emoji = "🗡"
        } else if color  == patternButtons[0].backgroundColor &&
            allButtons[0].backgroundColor == patternButtons[1].backgroundColor &&
            allButtons[1].backgroundColor == patternButtons[2].backgroundColor { //pattern
            emoji = "💥"
        } else if color == patternButtons[2].backgroundColor &&
            allButtons[0].backgroundColor == patternButtons[1].backgroundColor &&
            allButtons[1].backgroundColor == patternButtons[0].backgroundColor { // reverse pattern
            emoji = "⏸"
        } else if allButtons.count < 3 { //check for last grammar - 4 tiles
            return text
        } else {
            let tempColors = [color, allButtons[0].backgroundColor, allButtons[1].backgroundColor, allButtons[2].backgroundColor]
            if tempColors[0] == tempColors[1] && tempColors[2] == tempColors[3] { //two doubles in a row
                emoji = "💣"
            }
        }
        if emoji.count > 0 {
            for _ in 1...num {
                text = text + emoji
            }
            return text
        }
        return text
    }
    
    func levelTwoGrammar(color: UIColor) -> String {
        let num = Int(widthConst/24) //make sure right num of emojis to fit phone size
        var text = ""
        var emoji = ""
        if allButtons[0].backgroundColor == color &&    //three colors in a row
            allButtons[1].backgroundColor == color {
            emoji = "🗡"
        } else if (color  == patternButtons[0].backgroundColor &&   //pattern
            allButtons[0].backgroundColor == patternButtons[1].backgroundColor &&
            allButtons[1].backgroundColor == patternButtons[2].backgroundColor) ||
            (color  == patternButtons[1].backgroundColor &&
                allButtons[0].backgroundColor == patternButtons[2].backgroundColor &&
                allButtons[1].backgroundColor == patternButtons[3].backgroundColor) {
            emoji = "💥"
        } else if (color == patternButtons[2].backgroundColor &&    // reverse pattern
            allButtons[0].backgroundColor == patternButtons[1].backgroundColor &&
            allButtons[1].backgroundColor == patternButtons[0].backgroundColor) ||
            (color == patternButtons[3].backgroundColor &&
                allButtons[0].backgroundColor == patternButtons[2].backgroundColor &&
                allButtons[1].backgroundColor == patternButtons[1].backgroundColor) {
            emoji = "⏸"
        } else if allButtons.count < 3 { //check for last grammar - 4 tiles
            return text
        } else {
            let tempColors = [color, allButtons[0].backgroundColor, allButtons[1].backgroundColor, allButtons[2].backgroundColor]
            if tempColors[0] == tempColors[1] && tempColors[2] == tempColors[3] { //two doubles in a row
                emoji = "💣"
            }
        }
        if emoji.count > 0 {
            for _ in 1...num {
                text = text + emoji
            }
            return text
        }
        return text
    }
    
    func levelThreeGrammar(color: UIColor) -> String {
        let num = Int(widthConst/24) //make sure right num of emojis to fit phone size
        var text = ""
        var emoji = ""
        if allButtons[0].backgroundColor == color &&    //three colors in a row
            allButtons[1].backgroundColor == color {
            emoji = "🗡"
        } else if (color  == patternButtons[0].backgroundColor &&   //pattern
            allButtons[0].backgroundColor == patternButtons[1].backgroundColor &&
            allButtons[1].backgroundColor == patternButtons[2].backgroundColor) ||
            (color  == patternButtons[1].backgroundColor &&
                allButtons[0].backgroundColor == patternButtons[2].backgroundColor &&
                allButtons[1].backgroundColor == patternButtons[3].backgroundColor) ||
            (color  == patternButtons[2].backgroundColor &&
                allButtons[0].backgroundColor == patternButtons[3].backgroundColor &&
                allButtons[1].backgroundColor == patternButtons[4].backgroundColor) {
            emoji = "💥"
        } else if (color == patternButtons[2].backgroundColor &&    // reverse pattern
            allButtons[0].backgroundColor == patternButtons[1].backgroundColor &&
            allButtons[1].backgroundColor == patternButtons[0].backgroundColor) ||
            (color == patternButtons[3].backgroundColor &&
                allButtons[0].backgroundColor == patternButtons[2].backgroundColor &&
                allButtons[1].backgroundColor == patternButtons[1].backgroundColor) ||
            (color == patternButtons[4].backgroundColor &&
                allButtons[0].backgroundColor == patternButtons[3].backgroundColor &&
                allButtons[1].backgroundColor == patternButtons[2].backgroundColor) {
            emoji = "⏸"
        } else if allButtons.count < 3 { //check for last grammar - 4 tiles
            return text
        } else {
            let tempColors = [color, allButtons[0].backgroundColor, allButtons[1].backgroundColor, allButtons[2].backgroundColor]
            if tempColors[0] == tempColors[1] && tempColors[2] == tempColors[3] { //two doubles in a row
                emoji = "💣"
            }
        }
        if emoji.count > 0 {
            for _ in 1...num {
                text = text + emoji
            }
            return text
        }
        return text
    }
    
    func moveButtonsDown() {
        let height = (screenHeight/20)
        for index in 0...allButtons.count-1 {
            let y = height * CGFloat(index)
            let x = allButtons[index].frame.origin.x
            UIView.animate(withDuration: 0.1, animations:{
                self.allButtons[index].frame = CGRect(x: x, y: y, width: self.widthConst, height: self.heightConst)
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
        if (sender.titleLabel?.text) != nil { //checking if pause button or bomb are clicked
            if (sender.titleLabel!.text)![((sender.titleLabel!.text)!.startIndex)] == "⏸" { //pause for five seconds
                UIButton.animate(withDuration: 0.75) { //eliminate pause tile
                    sender.backgroundColor = UIColor.black //switch colors
                    sender.frame = CGRect(x: self.xConst + self.screenWidth, y: sender.frame.origin.y, width: self.widthConst, height: self.heightConst)
                }
                if isHighLighted { //unclick button
                    UIButton.animate(withDuration: 0.05) { //move button back to regular x position
                        sender.frame = CGRect(x: self.xConst, y: sender.frame.origin.y, width: self.widthConst, height: self.heightConst)
                    }
                    isHighLighted = false
                }
                gameTimer.invalidate() //stop timer
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: { //pausing timer
                    self.gameTimer = Timer.scheduledTimer(timeInterval: self.speed, target: self, selector: #selector(self.addBlock), userInfo: nil, repeats: true)
                })
                return
            } else if (sender.titleLabel!.text)![((sender.titleLabel!.text)!.startIndex)] == "💣" { //explode two tiles +-
            
                if isHighLighted { //unclick button
                    UIButton.animate(withDuration: 0.05) { //move button back to regular x position
                        sender.frame = CGRect(x: self.xConst, y: sender.frame.origin.y, width: self.widthConst, height: self.heightConst)
                    }
                    isHighLighted = false
                }
                return
            }
        }
        if isHighLighted == false { //first button hasn't been clicked
            UIButton.animate(withDuration: 0.05) { //move button to right to show clicked
                sender.frame = CGRect(x: self.xConst + 5, y: sender.frame.origin.y, width: self.widthConst, height: self.heightConst)
            }
            isHighLighted = true;
            
            firstColor = sender.backgroundColor; //save color
            firstButton = sender; //save button
        } else {
            handleSwitch(sender: sender)
        }
    }
    
    func handleSwitch(sender: UIButton!) {
        var emoji = ""
        var senderBool = false
        var firstBool = false
        if (sender.titleLabel?.text) == nil && (firstButton.titleLabel?.text) == nil {
            normalSwitch(sender: sender)
            return
        } else if (sender.titleLabel?.text) != nil {
            emoji = (sender.titleLabel?.text)!
            senderBool = true
        } else if (firstButton.titleLabel?.text) != nil {
            emoji = (firstButton.titleLabel?.text)!
            firstBool = true
        } else {
            print("SOMETHING WENT WRONG IN SWITCHING")
            return //something went wrong
        }

        switch emoji[emoji.startIndex] {
        case "🗡": // delete both tiles
            UIButton.animate(withDuration: 0.75) {
                self.firstButton.backgroundColor = UIColor.black //switch colors
                self.firstButton.frame = CGRect(x: self.xConst + self.screenWidth, y: self.firstButton.frame.origin.y, width: self.widthConst, height: self.heightConst)
                
                sender.backgroundColor = UIColor.black //switch colors
                sender.frame = CGRect(x: self.xConst + self.screenWidth, y: sender.frame.origin.y, width: self.widthConst, height: self.heightConst)
            }
            
            let newScore = Int(scoreText.text!)! + 1
            scoreText.text = String(newScore)
            
            //remove both buttons from view & array
            firstButton.removeFromSuperview()
            allButtons = allButtons.filter {$0 != firstButton}
            
            sender.removeFromSuperview()
            allButtons = allButtons.filter {$0 != sender}
            
            isHighLighted = false //reset
            checkPattern()
            break
        case "💥": //delete all of tile color
            var colorButtons = [UIButton] ()
            
            UIButton.animate(withDuration: 0.75) {
                var tempColor: UIColor
                
                if senderBool { //eliminate emoji tile
                    tempColor = self.firstButton.backgroundColor!
                    sender.frame = CGRect(x: self.xConst + self.screenWidth, y: sender.frame.origin.y, width: self.widthConst, height: self.heightConst)
                } else {
                    tempColor = sender.backgroundColor!
                    self.firstButton.frame = CGRect(x: self.xConst + self.screenWidth, y: self.firstButton.frame.origin.y, width: self.widthConst, height: self.heightConst)
                }
                
                for (_, element) in self.allButtons.enumerated() {
                    if element.backgroundColor == tempColor {
                        colorButtons.append(element)
                        
                        element.backgroundColor = UIColor.black //switch colors
                        element.frame = CGRect(x: self.xConst + self.screenWidth, y: element.frame.origin.y, width: self.widthConst, height: self.heightConst)
                        
                        let newScore = Int(self.scoreText.text!)! + 1
                        self.scoreText.text = String(newScore)
                    }
                }
            }
            firstButton.removeFromSuperview()
            colorButtons = colorButtons.filter {$0 != firstButton}
            allButtons = allButtons.filter {$0 != firstButton}
            
            sender.removeFromSuperview()
            colorButtons = colorButtons.filter {$0 != sender}
            allButtons = allButtons.filter {$0 != sender}
            
            for index in 0...colorButtons.count-1 {
                colorButtons[index].removeFromSuperview()
                allButtons = allButtons.filter {$0 != colorButtons[index]}
            }
            
            isHighLighted = false //reset
            checkPattern()
            break
//        case "⏸": //pause for
//            gameTimer.invalidate() //stop timer
//            UIButton.animate(withDuration: 0.75) {
//
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
//                self.gameTimer = Timer.scheduledTimer(timeInterval: self.speed, target: self, selector: #selector(self.addBlock), userInfo: nil, repeats: true)
//            })
//
//            break
        case "💣":
            //TODO: explode +=3 tiles
            break
        default:
            print("SOMETHING WENT WRONG IN SWITCHING AGAIN")
            return //something went wrong
        }
    }
    
    func normalSwitch(sender: UIButton!) {
        UIButton.animate(withDuration: 0.75) {
            self.firstButton.layer.shadowOpacity = 0.0 //shadow
            self.firstButton.backgroundColor = sender.backgroundColor //switch colors
            sender.backgroundColor = self.firstColor
            self.firstButton.frame = CGRect(x: self.xConst, y: self.firstButton.frame.origin.y, width: self.widthConst, height: self.heightConst)
        }
        isHighLighted = false //reset
        checkPattern()
    }
    
    
    func generateRandomColor(_ level:Int) -> Int {
        if level == 1 { //three colors
            if allButtons.count > 9 { //check if at least there is one of each color half way down
                var first = false
                var second = false
                var third = false
                for (_, element) in allButtons.enumerated() {
                    switch element.backgroundColor {
                    case colorArray[0]?:
                        first = true
                        break
                    case colorArray[1]?:
                        second = true
                        break
                    case colorArray[2]?:
                        third = true
                        break
                    default:
                        break
                    }
                }
                //return color if havent shown up yet
                if !first {
                    return 0
                } else if !second {
                    return 1
                } else if !third {
                    return 2
                } else {
                    return Int(arc4random_uniform(UInt32(3)))
                }
            } else {
                return Int(arc4random_uniform(UInt32(3)))
            }
        } else if level == 2 { //four colors
            return Int(arc4random_uniform(UInt32(4)))
        } else { //five colors
            return Int(arc4random_uniform(UInt32(5)))
        }
    }
    
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
            if allButtons.count > 3 {
                for index in 0...(allButtons.count-3) {
                    if allButtons[index].backgroundColor == pattern1.backgroundColor {
                        if allButtons[index+1].backgroundColor == pattern2.backgroundColor {
                            if allButtons[index+2].backgroundColor == pattern3.backgroundColor {
                                patternFound(index: index)
                            }
                        }
                    }
                }
            }
            break;
        case 2:
            if allButtons.count > 4 {
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
            }
            break;
        default:
            if allButtons.count > 5 {
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
            }
            break;
        }
    }
    
    func patternFound(index: Int) {
        //        print("INDEX: \(index)")
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
            
            UIView.animate(withDuration: 0.75, animations:{
                self.allButtons[index].frame = CGRect(x: x + self.screenWidth, y: self.allButtons[index].frame.origin.y, width: width, height: height)
                self.allButtons[index+1].frame = CGRect(x: x + self.screenWidth, y: self.allButtons[index+1].frame.origin.y, width: width, height: height)
                self.allButtons[index+2].frame = CGRect(x: x + self.screenWidth, y: self.allButtons[index+2].frame.origin.y, width: width, height: height)
                
                let when = DispatchTime.now() + 0.75
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.allButtons[index].removeFromSuperview()
                    self.allButtons[index+1].removeFromSuperview()
                    self.allButtons[index+2].removeFromSuperview()
                    
                    self.allButtons.remove(at: index)
                    self.allButtons.remove(at: index)
                    self.allButtons.remove(at: index)
                    
                    self.moveButtonsUp(i: index)
                    self.patternFound = false
                    
                    self.gameTimer = Timer.scheduledTimer(timeInterval: self.speed, target: self, selector: #selector(self.addBlock), userInfo: nil, repeats: true)
                }
            })
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
        view.bringSubview(toFront: gameOverMessage)
        gameOverLabel.isHidden = false
        gameOverButton.isHidden = false
        gameOverText.isHidden = false
        
        for (_, element) in allButtons.enumerated() {
            element.isEnabled = false
        }
        
        if Int(highScoreText.text!)! < Int(scoreText.text!)! {
            highScoreText.text = scoreText.text
            userDefults.set(highScoreText.text, forKey: "highScore")
            gameOverMessage.isHidden = false
        }
    }
    
    @IBAction func restartGame() {
        //        print("restarting game")
        for (_, element) in allButtons.enumerated() {
            element.removeFromSuperview()
        }
        gameOverLabel.isHidden = true
        gameOverButton.isHidden = true
        gameOverText.isHidden = true
        gameOverMessage.isHidden = true
        
        scoreText.text = "0"
        
        allButtons.removeAll()
        
        updatePattern()
        
        let date = NSDate()
        initialTime = date.timeIntervalSince1970
        
        speed = 2.0
        gameTimer.invalidate() //stop timer
        gameTimer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(self.addBlock), userInfo: nil, repeats: true)
    }
    @IBAction func backToLevels() {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.present(viewController, animated:false, completion:nil)
    }
}

