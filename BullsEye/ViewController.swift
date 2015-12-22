//
//  ViewController.swift
//  BullsEye
//
//  Created by tb on 12/13/15.
//  Copyright © 2015 tb. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
  
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var roundLabel: UILabel!
  
  var currentValue: Int = 50
  var targetValue: Int = 0
  var score: Int = 0
  var round: Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()

    // Center button images
    let thumbImageNormal = UIImage(named: "SliderThumb-Normal")
    slider.setThumbImage(thumbImageNormal, forState: .Normal)
    
    let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")
    slider.setThumbImage(thumbImageHighlighted, forState: .Highlighted)
    
    let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    if let trackLeftImage = UIImage(named: "SliderTrackLeft") {
      let trackLeftResizable = trackLeftImage.resizableImageWithCapInsets(insets)
      slider.setMinimumTrackImage(trackLeftResizable, forState: .Normal)
    }
    
    if let trackRightImage = UIImage(named: "SliderTrackRight") {
      let trackRightResizable = trackRightImage.resizableImageWithCapInsets(insets)
      slider.setMaximumTrackImage(trackRightResizable, forState: .Normal)
    }
    
    // Init others
    startNewGame()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  
  /// startNewRound() - Initialized & starts a new round
  ///
  func startNewRound() {
    targetValue = 1 + Int(arc4random_uniform(100))
    currentValue = 50
    //slider.value = Float(currentValue)
    round += 1
  }
  
  /// updateLabels() - Updates all UI labels in one place
  ///
  func updateLabels() {
    targetLabel.text = "\(targetValue)"
    scoreLabel.text = "\(score)"
    roundLabel.text = "\(round)"
    slider.value = Float(currentValue)
  }
  
  /// calcDifference() - Calculates difference of currentValue & targetValue
  ///
  func calcDifference() -> Int {
    return abs(targetValue - currentValue)
  }
  
  /// calcMessage - Determines message to feed back to user
  ///
  func calcMessage(difference: Int) -> String {
    // Init default message
    var returnMessage = "Better luck next time <80"
    
    if (difference == 0)
    {
      returnMessage = "Perfect! 100"
    }
    else if (difference < 10)
    {
      returnMessage = "Almost! 90+"
    }
    else if (difference < 20)
    {
      returnMessage = "Close! 80+"
    }
    
    return returnMessage
  }
  
  /// calcScore - calculates score
  ///
  func calcScore(points: Int) {
    // Get base score
    score += points
    
    // Bonus for perfect score
    if (points == 100)
    {
      score += 100
    }
  }
  
  /// startNewGame - starts a new game
  ///
  func startNewGame() {
    currentValue = 50
    targetValue = 0
    score = 0
    round = 0
    
    startNewRound()
    updateLabels()
  }
  
  ///
  ///
  @IBAction func showAlert() {
    let difference = calcDifference()
    let points = 100 - difference
    calcScore(points)
    
    // Define message
    let myMessage = calcMessage(difference)
    
    // General alert message, style
    let alert = UIAlertController(title: "Hello, World",
      message: myMessage,
      preferredStyle: .Alert)
    
    // Buttons, actions to take
    let action = UIAlertAction(title: "OK",
      style: .Default,
      handler: { action in
                  // Start again - Geek note: this is a "closure"
                  self.startNewRound()
                  self.updateLabels()
                })
    
    // Add button to alert
    alert.addAction(action)
    
    // Show alert
    presentViewController(alert, animated: true, completion: nil)
  }
  
  ///
  ///
  @IBAction func sliderMoved(slider: UISlider) {
    // DEBUG
    print("The value of the slider is now: \(Int(slider.value))")
    
    self.currentValue = Int(slider.value)
  }
  
  @IBAction func startOver() {
    startNewGame()
    
    // Do a cool transition - crossfade
    let transition = CATransition()
    transition.type = kCATransitionFade
    transition.duration = 1
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    view.layer.addAnimation(transition, forKey: nil)
  }
}

