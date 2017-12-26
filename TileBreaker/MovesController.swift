//
//  MovesController.swift
//  TileBreaker
//
//  Created by GGR on 12/25/17.
//  Copyright © 2017 ggr. All rights reserved.
//
import UIKit
import SpriteKit

class MovesController: UIViewController {
    
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
    @IBOutlet weak var pauseButton: UIButton!
    
    var isHighLighted:Bool = false
    var firstColor: UIColor!
    var firstButton: UIButton!
    
    let colorArray = [UIColor(red:0.76, green:0.71, blue:0.93, alpha:1.0), UIColor(red:0.08, green:0.35, blue:0.40, alpha:1.0), UIColor(red:0.60, green:0.15, blue:0.35, alpha:1.0), UIColor(red:0.69, green:0.98, blue:0.97, alpha:1.0), UIColor(red:0.90, green:0.98, blue:0.62, alpha:1.0)]
    
    let tripleColor = UIColor(red:0.96, green:0.27, blue:0.85, alpha:1.0) //pink
    let patternColor = UIColor(red:0.52, green:0.97, blue:0.49, alpha:1.0) //green
    
    var allButtons = [UIButton] ()
    var patternButtons = [UIButton] ()
    
    var patternFound:Bool = false
    var inPause = false
    var moving = false
    var pausingGame = false
    
    //Screen Sizes and Constants
    let screenSize = UIScreen.main.bounds
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var xConst: CGFloat!
    var heightConst: CGFloat!
    var widthConst: CGFloat!
    
    var level: Int!
    
    let userDefults = UserDefaults.standard //returns shared defaults object
    
    var label: UILabel!
    
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    var blurEffectView: UIVisualEffectView!
    var resumeButton: UIButton!
    
    //suggested buttons
    var buttonOneSuggestion: UIButton!
    var buttonTwoSuggestion: UIButton!
    var isSuggesting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (level) == nil {
            level = 1
        }
        
        //check if highscore has been stored
        switch level {
        case 1:
            if let highScoreEasy = userDefults.value(forKey: "highScoreEasy") {
                highScoreText.text = String(describing: highScoreEasy)
            }
            break
        case 2:
            if let highScoreMedium = userDefults.value(forKey: "highScoreMedium") {
                highScoreText.text = String(describing: highScoreMedium)
            }
            break
        case 3:
            if let highScoreHard = userDefults.value(forKey: "highScoreHard") {
                highScoreText.text = String(describing: highScoreHard)
            }
            break
        default: //default to level one
            if let highScoreEasy = userDefults.value(forKey: "highScoreEasy") {
                highScoreText.text = String(describing: highScoreEasy)
            }
        }
        
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
        
        
        //set attributes of buttons
        gameOverLabel.layer.borderColor = UIColor.black.cgColor
        gameOverLabel.layer.borderWidth = 3.0;
        
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        resumeButton = UIButton(frame: CGRect(x: 20, y: 20, width: screenWidth, height: screenHeight))
        resumeButton.center = self.view.center
        resumeButton.titleLabel?.font =  UIFont(name: "HelveticaNeue-Bold" , size: 35)
        resumeButton.addTarget(self, action: #selector(pauseGame), for: .touchUpInside)
        resumeButton.setTitle("RESUME", for: .normal)
        
        updatePattern()
        
        for _ in 0...10 {
            addBlock()
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
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
        print("adding block")
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
        
        if allButtons.count > 15 {
            checkHelp()
        } else if isSuggesting {
            if (buttonOneSuggestion != nil) {
                buttonOneSuggestion.layer.removeAllAnimations()
            }
            if (buttonTwoSuggestion != nil) {
                buttonTwoSuggestion.layer.removeAllAnimations()
            }
            isSuggesting = false
        }
    }
    
    //highlights two suggested switches when the player is close to losing
    func checkHelp() {
        isSuggesting = true
        var bomb = false
        var target = false
        var knife = false
        var i = 0
        for (index, element) in allButtons.enumerated() {
            if (element.titleLabel?.text) != nil {
                switch (element.titleLabel!.text)![((element.titleLabel!.text)!.startIndex)] {
                case "⏸": //always choose pause over all tiles
                    element.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0,
                                   options: .allowUserInteraction, animations: { [] in
                                    element.transform = .identity
                    }, completion: nil)
                    buttonOneSuggestion = element
                    buttonTwoSuggestion = nil
                    return
                case "💣":
                    bomb = true
                    i = index
                    break
                case "💥":
                    target = true
                    if !bomb {
                        i = index
                    }
                    break
                case "🗡":
                    knife = true
                    if !bomb && !target{
                        i = index
                    }
                    break
                default:
                    break
                }
            }
        }
        if bomb {
            allButtons[i].transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0,
                           options: .allowUserInteraction, animations: { [] in
                            self.allButtons[i].transform = .identity
            }, completion: nil)
            buttonOneSuggestion = allButtons[i]
            buttonTwoSuggestion = nil
        } else if target {
            var color1 = 0
            var color2 = 0
            var color3 = 0
            var index1 = 0
            var index2 = 0
            var index3 = 0
            for (index, element) in allButtons.enumerated() {
                if element.backgroundColor == patternButtons[0].backgroundColor {
                    color1 = color1 + 1
                    index1 = index
                } else if element.backgroundColor == patternButtons[1].backgroundColor {
                    color2 = color2 + 1
                    index2 = index
                } else if element.backgroundColor == patternButtons[2].backgroundColor {
                    color3 = color3 + 1
                    index3 = index
                }
            }
            var finalIndex = 0
            if color1 > color2 && color1 > color3 {
                finalIndex = index1
            } else if color2 > color1 && color2 > color3 {
                finalIndex = index2
            } else {
                finalIndex = index3
            }
            allButtons[finalIndex].transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0,
                           options: .allowUserInteraction, animations: { [] in
                            self.allButtons[finalIndex].transform = .identity
            }, completion: nil)
            allButtons[i].transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0,
                           options: .allowUserInteraction, animations: { [] in
                            self.allButtons[i].transform = .identity
            }, completion: nil)
            buttonOneSuggestion = allButtons[i]
            buttonTwoSuggestion = allButtons[finalIndex]
        } else if knife {
            allButtons[allButtons.count-1].transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0,
                           options: .allowUserInteraction, animations: { [] in
                            self.allButtons[self.allButtons.count-1].transform = .identity
            }, completion: nil)
            allButtons[i].transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1.0,
                           options: .allowUserInteraction, animations: { [] in
                            self.allButtons[i].transform = .identity
            }, completion: nil)
            buttonOneSuggestion = allButtons[i]
            buttonTwoSuggestion = allButtons[allButtons.count-1]
            
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
             //TODO TO OTHER
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
        print("moving down")
        let height = (screenHeight/20)
        for index in 0...allButtons.count-1 {
            let y = height * CGFloat(index)
            let x = allButtons[index].frame.origin.x
            UIView.animate(withDuration: 0.1, animations:{
                self.allButtons[index].frame = CGRect(x: x, y: y, width: self.widthConst, height: self.heightConst)
            })
            //            UIView.animate(withDuration: (speed+0.1), animations:{
            //                self.allButtons[index].frame = CGRect(x: x, y: y, width: self.widthConst, height: self.heightConst)
            //            })
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
                pauseClicked(sender: sender)
                return
            } else if (sender.titleLabel!.text)![((sender.titleLabel!.text)!.startIndex)] == "💣" { //explode two tiles +-
                bombClicked(sender: sender)
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
            addBlock()
            addBlock()
        }
    }
    
    func bombClicked(sender: UIButton) {
        var deleteButtons = [UIButton] ()
        let index = allButtons.index(of: sender)!
        for i in index-2...index+2 {
            if i < 0 || i > allButtons.count-1 {
                
            } else {
                deleteButtons.append(allButtons[i])
            }
        }
        
        UIButton.animate(withDuration: 0.75) { //eliminate bomb tile and radius of 2 tiles
            for (_, element) in deleteButtons.enumerated() {
                element.backgroundColor = UIColor.black //switch colors
                element.frame = CGRect(x: self.xConst + self.screenWidth, y: element.frame.origin.y, width: self.widthConst, height: self.heightConst)
                let newScore = Int(self.scoreText.text!)! + 1
                self.scoreText.text = String(newScore)
                
            }
        }
        
        for (_, element) in deleteButtons.enumerated() {
            element.removeFromSuperview()
            allButtons = allButtons.filter {$0 != element}
        }
        
        moveButtonsDown()
        
        if isHighLighted { //unclick button
            UIButton.animate(withDuration: 0.05) { //move button back to regular x position
                sender.frame = CGRect(x: self.xConst, y: sender.frame.origin.y, width: self.widthConst, height: self.heightConst)
            }
            isHighLighted = false
        }
    }
    
    func pauseClicked(sender: UIButton) {
        inPause = true
        UIButton.animate(withDuration: 0.75) { //eliminate pause tile
            sender.backgroundColor = UIColor.black //switch colors
            sender.frame = CGRect(x: self.xConst + self.screenWidth, y: sender.frame.origin.y, width: self.widthConst, height: self.heightConst)
        }
        
        sender.removeFromSuperview()
        allButtons = allButtons.filter {$0 != sender}
        moveButtonsDown()
        
        if isHighLighted { //unclick button
            UIButton.animate(withDuration: 0.05) { //move button back to regular x position
                sender.frame = CGRect(x: self.xConst, y: sender.frame.origin.y, width: self.widthConst, height: self.heightConst)
            }
            isHighLighted = false
        }
    }
    
    func handleSwitch(sender: UIButton!) {
        var emoji = ""
        var senderBool = false
        var firstBool = false
        if (sender.titleLabel?.text) == nil && (firstButton.titleLabel?.text) == nil {
            normalSwitch(sender: sender)
            return
        }
        if (sender.titleLabel?.text) != nil {
            emoji = (sender.titleLabel?.text)!
            senderBool = true
        }
        if (firstButton.titleLabel?.text) != nil {
            emoji = (firstButton.titleLabel?.text)!
            firstBool = true
        }
        
        switch emoji[emoji.startIndex] {
        case "🗡": // delete both tiles
            if firstBool && senderBool {
                return
            }
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
            if firstBool && senderBool {
                return
            }
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
            
            if colorButtons.count > 1 {
                for index in 0...colorButtons.count-1 {
                    colorButtons[index].removeFromSuperview()
                    allButtons = allButtons.filter {$0 != colorButtons[index]}
                }
            }
            
            isHighLighted = false //reset
            checkPattern()
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
            if allButtons.count > 8 { //check if at least there is one of each color half way - 1 tiles down
                var first = false
                var second = false
                var third = false
                var fourth = false
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
                    case colorArray[3]?:
                        fourth = true
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
                } else if !fourth {
                    return 3
                } else {
                    return Int(arc4random_uniform(UInt32(4)))
                }
            } else {
                return Int(arc4random_uniform(UInt32(4)))
            }
        } else { //five colors
            if allButtons.count > 7 { //check if at least there is one of each color half way - 2 tiles down
                var first = false
                var second = false
                var third = false
                var fourth = false
                var fifth = false
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
                    case colorArray[3]?:
                        fourth = true
                        break
                    case colorArray[4]?:
                        fifth = true
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
                } else if !fourth {
                    return 3
                } else if !fifth {
                    return 4
                } else {
                    return Int(arc4random_uniform(UInt32(5)))
                }
            } else {
                return Int(arc4random_uniform(UInt32(5)))
            }
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
        let newScore = Int(scoreText.text!)! + 1
        scoreText.text = String(newScore)
        patternFound = true
        if level == 1 {
            let temp1 = allButtons[index]
            let temp2 = allButtons[index+1]
            let temp3 = allButtons[index+2]
            
            temp1.backgroundColor = UIColor.black
            temp2.backgroundColor = UIColor.black
            temp3.backgroundColor = UIColor.black
            
            UIView.animate(withDuration: 0.75, animations:{
                temp1.frame = CGRect(x: self.xConst + self.screenWidth, y: temp1.frame.origin.y, width: self.widthConst, height: self.heightConst)
                temp2.frame = CGRect(x: self.xConst + self.screenWidth, y: temp2.frame.origin.y, width: self.widthConst, height: self.heightConst)
                temp3.frame = CGRect(x: self.xConst + self.screenWidth, y: temp3.frame.origin.y, width: self.widthConst, height: self.heightConst)
                
                let when = DispatchTime.now() + 0.75
                DispatchQueue.main.asyncAfter(deadline: when) {
                    temp1.removeFromSuperview()
                    temp2.removeFromSuperview()
                    temp3.removeFromSuperview()
                    
                    self.allButtons = self.allButtons.filter {$0 != temp1}
                    self.allButtons = self.allButtons.filter {$0 != temp2}
                    self.allButtons = self.allButtons.filter {$0 != temp3}
                    
                    self.moveButtonsDown()
                    self.patternFound = false
                }
            })
        } else if level == 2 {
            let temp1 = allButtons[index]
            let temp2 = allButtons[index+1]
            let temp3 = allButtons[index+2]
            let temp4 = allButtons[index+3]
            
            temp1.backgroundColor = UIColor.black
            temp2.backgroundColor = UIColor.black
            temp3.backgroundColor = UIColor.black
            temp4.backgroundColor = UIColor.black
            
            UIView.animate(withDuration: 0.75, animations:{
                temp1.frame = CGRect(x: self.xConst + self.screenWidth, y: temp1.frame.origin.y, width: self.widthConst, height: self.heightConst)
                temp2.frame = CGRect(x: self.xConst + self.screenWidth, y: temp2.frame.origin.y, width: self.widthConst, height: self.heightConst)
                temp3.frame = CGRect(x: self.xConst + self.screenWidth, y: temp3.frame.origin.y, width: self.widthConst, height: self.heightConst)
                temp4.frame = CGRect(x: self.xConst + self.screenWidth, y: temp4.frame.origin.y, width: self.widthConst, height: self.heightConst)
                
                let when = DispatchTime.now() + 0.75
                DispatchQueue.main.asyncAfter(deadline: when) {
                    temp1.removeFromSuperview()
                    temp2.removeFromSuperview()
                    temp3.removeFromSuperview()
                    temp4.removeFromSuperview()
                    
                    self.allButtons = self.allButtons.filter {$0 != temp1}
                    self.allButtons = self.allButtons.filter {$0 != temp2}
                    self.allButtons = self.allButtons.filter {$0 != temp3}
                    self.allButtons = self.allButtons.filter {$0 != temp4}
                    
                    self.moveButtonsDown()
                    self.patternFound = false
                }
            })
        } else {
            let temp1 = allButtons[index]
            let temp2 = allButtons[index+1]
            let temp3 = allButtons[index+2]
            let temp4 = allButtons[index+3]
            let temp5 = allButtons[index+4]
            
            temp1.backgroundColor = UIColor.black
            temp2.backgroundColor = UIColor.black
            temp3.backgroundColor = UIColor.black
            temp4.backgroundColor = UIColor.black
            temp5.backgroundColor = UIColor.black
            
            UIView.animate(withDuration: 0.75, animations:{
                temp1.frame = CGRect(x: self.xConst + self.screenWidth, y: temp1.frame.origin.y, width: self.widthConst, height: self.heightConst)
                temp2.frame = CGRect(x: self.xConst + self.screenWidth, y: temp2.frame.origin.y, width: self.widthConst, height: self.heightConst)
                temp3.frame = CGRect(x: self.xConst + self.screenWidth, y: temp3.frame.origin.y, width: self.widthConst, height: self.heightConst)
                temp4.frame = CGRect(x: self.xConst + self.screenWidth, y: temp4.frame.origin.y, width: self.widthConst, height: self.heightConst)
                temp5.frame = CGRect(x: self.xConst + self.screenWidth, y: temp5.frame.origin.y, width: self.widthConst, height: self.heightConst)
                
                let when = DispatchTime.now() + 0.75
                DispatchQueue.main.asyncAfter(deadline: when) {
                    temp1.removeFromSuperview()
                    temp2.removeFromSuperview()
                    temp3.removeFromSuperview()
                    temp4.removeFromSuperview()
                    temp5.removeFromSuperview()
                    
                    self.allButtons = self.allButtons.filter {$0 != temp1}
                    self.allButtons = self.allButtons.filter {$0 != temp2}
                    self.allButtons = self.allButtons.filter {$0 != temp3}
                    self.allButtons = self.allButtons.filter {$0 != temp4}
                    self.allButtons = self.allButtons.filter {$0 != temp5}
                    
                    self.moveButtonsDown()
                    self.patternFound = false
                }
            })
        }
    }
    
    func gameOver() { //tiles have reached bottom of screen
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
            switch level {
            case 1:
                highScoreText.text = scoreText.text
                userDefults.set(highScoreText.text, forKey: "highScoreEasy")
                gameOverMessage.isHidden = false
                break
            case 2:
                highScoreText.text = scoreText.text
                userDefults.set(highScoreText.text, forKey: "highScoreMedium")
                gameOverMessage.isHidden = false
                break
            case 3:
                highScoreText.text = scoreText.text
                userDefults.set(highScoreText.text, forKey: "highScoreHard")
                gameOverMessage.isHidden = false
                break
            default:
                highScoreText.text = scoreText.text
                userDefults.set(highScoreText.text, forKey: "highScoreEasy")
                gameOverMessage.isHidden = false
            }
        }
    }
    
    @IBAction func restartGame() {
        for (_, element) in allButtons.enumerated() {
            element.removeFromSuperview()
        }
        gameOverLabel.isHidden = true
        gameOverButton.isHidden = true
        gameOverText.isHidden = true
        gameOverMessage.isHidden = true
        
        scoreText.text = "0"
        
        allButtons.removeAll()
        
        for _ in 0...10 {
            addBlock()
        }
        
        updatePattern()
    }
    
    @IBAction func backToLevels() {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.present(viewController, animated:false, completion:nil)
    }
    
    @IBAction func pauseGame() {
        if !pausingGame {
            pauseButton.setTitle("PLAY", for: .normal)
            pausingGame = true
            
            view.addSubview(blurEffectView)
            view.addSubview(resumeButton)
            
        } else {
            blurEffectView.removeFromSuperview()
            resumeButton.removeFromSuperview()
            pauseButton.setTitle("PAUSE", for: .normal)
            pausingGame = false
        }
    }
    
}


