//
//  ViewController.swift
//  Match The Members
//
//  Created by Maggie Yi on 2/9/20.
//  Copyright © 2020 MDB. All rights reserved.
//

import Foundation
import UIKit

/* for sidebar customization of round corners */
/* source: https://stackoverflow.com/a/45089222/12082028 */

@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

class MainVC: UIViewController {

    //Mark: Properties
    @IBOutlet weak var name1: UIButton!
    @IBOutlet weak var name2: UIButton!
    @IBOutlet weak var name3: UIButton!
    @IBOutlet weak var name4: UIButton!
    @IBOutlet weak var statsButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var memberImage: UIImageView!
    
    // Mark: Main
    /* for buttons */
    var answerIs = ""
    var correctAns = false
    var buttons = [UIButton]()
    var nameList = [String]()
    var currList = [String]()
    
    /* for timer */
    var timer = Timer()
    var timeLimit = 5
    var isPaused = false
    var isTimeRunning = false
    
    /* for score */
    var score = 0 {
        didSet {
            scoreLabel.sizeToFit()
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var scoreCount = 0
    var correctFire = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isPaused{
                   print("Paused? \(isPaused)")
                   toPause(isPaused)
               }
    }
    
    func reset(_ pauseBool: Bool){
        self.isPaused = pauseBool
    }
    
    @IBAction func statsPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "toResultVC", sender: self)
    }
    
    func start() {
        /*restart timer */
        resetTimer()
        
        /* restart button */
        roundButtons()
        restartButton()
        
        answerIs = Constants.names.randomElement()!
        memberImage.image = Constants.getImageFor(name: answerIs)
        
        randomButton()
        setTimer()
        correctCheck()
    }
    
    /* Timer */
    @IBAction func toResult(_ sender: Any) {
        if !isPaused{
            toPause(isPaused)
        }
        self.performSegue(withIdentifier: "toStatsVC", sender: self)
        navigationController?.popViewController(animated: true)
    }
        
    /* Button Settings: Properties */
    
    /*** Generate random buttons  ***/
    func randomButton(){
        buttons = [name1, name2, name3, name4]
        buttons.shuffle()
        //assign right name to button
        buttons.removeFirst().setTitle(answerIs, for: .normal)
    
        //wrong answer buttons
        var nameList = Constants.names
        nameList.shuffle()
        nameList.remove(at: nameList.firstIndex(of: answerIs)!)
        
        for nameX in buttons {
            nameX.setTitle(nameList.removeFirst(), for:.normal)
        }
    }
    
    /*** Button initializing look  ***/
    func restartButton() {
        buttons = [name1, name2, name3, name4]
        for nameX in buttons{
            nameX.backgroundColor = UIColor.systemBlue
            nameX.setTitleColor(.systemYellow, for: .normal)
            nameX.isEnabled = true
        }
    }
    /*** Button design: round corners  ***/
    func roundButtons() {
        //name buttons
        //buttons = [name1Button, name2Button, name3Button, name4Button]
        //for nameX in buttons {
        //    buttons.layer.cornerRadius = 4
        //}
        
        //score label layer
        scoreLabel.layer.cornerRadius = 4
    }
    
    /*** Enable buttons  ***/
    func enableButton() {
        buttons = [name1, name2, name3, name4]
        for nameX in buttons {
            nameX.isEnabled = true
        }
    }
    
    /*** Disable buttons  ***/
    func disableButton() {
        buttons = [name1, name2, name3, name4]
        for nameX in buttons {
            nameX.isEnabled = false
        }
    }
    
    /* Button Settings: Actions */
    
    /*** Right and Wrong Answer UI Reaction  ***/
    func clickedButton(_ button: UIButton!){
        timer.invalidate()
        disableButton()
        if button.titleLabel!.text == answerIs{
            button.backgroundColor = UIColor(red: 0/255.0, green: 174/255.0, blue: 30/255.0, alpha: 1.0)
            button.setTitleColor(.white, for: .normal)
            tempList(answerIs, "Nice, correct")
            score += 1
            correctCheck()
            scoreLabel.sizeToFit()
            correctFire = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.start()
            }
        } else{
            button.backgroundColor = UIColor(red: 155/255.0, green: 0/255.0, blue: 30/255.0, alpha: 1.0)
            button.setTitleColor(.white, for: .normal)
            correctCheck()
            score = 0
            scoreLabel.sizeToFit()
            correctFire = false
            adjustColor()
        }
    }
    
    func tempList(_ name: String, _ result: String){
        if currList.count == 3 {
            currList.removeLast()
        }
        currList.insert("\(name): \(result)", at: 0)
    }
    
    func adjustColor(){
        buttons = [name1,name2, name3, name4]
        tempList(answerIs, "Incorrect")
        for button in buttons{
            if button.titleLabel!.text == answerIs{
                button.backgroundColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 30/255.0, alpha: 1.0)
                button.setTitleColor(.white, for: .normal)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.start()
        }
    }
    
    /* Clicking Actions */
    
    @IBAction func name1(_ sender: Any) {
        clickedButton(name1)
    }

    @IBAction func name2(_ sender: Any) {
        clickedButton(name2)
    }
    
    @IBAction func name3(_ sender: Any) {
        clickedButton(name3)
    }
    
    @IBAction func name4(_ sender: Any) {
        clickedButton(name1)
    }
    
    
    /* Score Tracking */
    
    func correctCheck() {
        if score > scoreCount{
            scoreCount = score
        }
    }
    
    /* Timer Functionalities */
    @IBAction func pauseCurr(_ sender: Any) {
        toPause(isPaused)
    }
    
    func toPause(_ pauseTF: Bool = false) {
        isPaused = !isPaused
        if !pauseTF {
            disableButton()
            pauseButton.setImage(UIImage(named: "resumeButton.png") , for: .normal)
            isTimeRunning = false
            timer.invalidate()
        } else {
            enableButton()
            pauseButton.setImage(UIImage(named: "pause.fill"), for: .normal)
            setTimer()
        }
    }
    
    @objc func updateTimer(){
        if timeLimit > 0{
            timeLimit -= 1
            timeLabel.text = "\(timeLimit)"
        } else if timeLimit == 0{
            correctCheck()
            score = 0
            isTimeRunning = false
            timer.invalidate()
            adjustColor()
        }
    }
    
    func setTimer(){
        isTimeRunning = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    func resetTimer(){
        isTimeRunning = false
        timer.invalidate()
        timeLimit = 5
        timeLabel.text = "\(timeLimit)"
    }
     
    /* Segue Override*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? ResultVC, segue.identifier == "toResultVC" {
            //self.performSegue(withIdentifier: "toResultVC", sender: self)
            destinationVC.longest = scoreCount
            destinationVC.currList = currList
            print(currList)
            destinationVC.isPaused = isPaused
            destinationVC.gameController = self
        }
    }
    
}
