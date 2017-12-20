//
//  ViewController.swift
//  Jumbyrinth
//
//  Created by Shenghao Lin on 2017/11/16.
//  Copyright © 2017年 nyu.edu. All rights reserved.
//

import UIKit
import CoreMotion

// The class designed for the actual game scene
class ViewController: UIViewController {
    
    var levelNumber: Int = 0
    
    var manager = CMMotionManager()
    
    var set = false
    
    var ballView : BallView?
    var sunView : SunMoonView?

    @IBOutlet weak var timeDisplay: UILabel!
    @IBOutlet weak var sun: UIView!
    @IBOutlet weak var playground: UIView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet var colorvie: ColorfulView!
    
    //timer to record the result
    var seconds : Int = 0
    var timer = Timer()
    
    override func viewDidLoad() {
        
        //Start to update background color
        colorvie.runUpdateTimer()
        
        //Level label initialization
        if levelNumber == 6 {
            levelLabel.text = "Level X"
        }
        else {
            levelLabel.text = String(format: "Level %d", levelNumber)
        }
        
        seconds = 0
        self.view.alpha = 1
        
        super.viewDidLoad()
        
        //Check if the the playground has already been initialized
        //if not yet, initialize it, including ballview and sunview
        if (!set) {
            
            ballView = BallView.init(frame: playground.bounds, levelNumber: levelNumber)
            sunView = SunMoonView.init(frame: sun.bounds)
            set = true
        }
        playBall()
    }
    
    // when pause is pressed, pause the game (stop the timer and DeviceMotion update)
    @IBAction func pausePushed(_ sender: Any) {
        
        self.view.alpha = 0.5
        self.manager.stopDeviceMotionUpdates()
        self.timer.invalidate()
        
        //set the pause staus to be true
        self.ballView?.pause = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Start the game
    // Start to collect data from deviceMotion and start to update the ball location accordingly
    // Update method referenced from: https://github.com/Stanbai/sensorDemo
    public func playBall() {
        
        //Start to record time
        runTimer()
        
        //maze and ball setup
        ballView!.backgroundColor = UIColor.clear
        self.playground.addSubview(ballView!)
        self.sun.addSubview(sunView!)
        
        manager.deviceMotionUpdateInterval = 0.005
        
        manager.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
            
            //Use gravity for x-y direct on the phone screeen for ball accerleration
            //and the acceleration on y-axis on the phone screen for jump
            self.ballView!.accelleration = (motion?.gravity)!
            self.ballView!.jump = (motion?.userAcceleration)!
    
            //update data periodically
            DispatchQueue.main.async {
                
                //update ball location
                self.ballView!.updateLocation(multiplier: 3000)
                
                //check the ball location to see if the game is over
                if ((self.ballView!.currentPoint.x < self.ballView!.bounds.maxX)&&(self.ballView!.currentPoint.x > self.ballView!.bounds.maxX - 20)&&(self.ballView!.currentPoint.y < self.ballView!.bounds.maxY)&&(self.ballView!.currentPoint.y > self.ballView!.bounds.maxY - 20)) {
                    
                        //when game is over, stop ball movement and time record
                        self.manager.stopDeviceMotionUpdates()
                        self.timer.invalidate()
                    
                        //save score
                        let score = self.timeDisplay.text!
                        let currentDateTime = Date()
                        print(score)
                        print(currentDateTime)
                        let newScore = ScoreRecord(score: score, date: currentDateTime)
                        self.saveScore(newScore: newScore)
                    
                        //pop up the result scene
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scoreDisplay") as! PopUpViewController

                        self.view.alpha = 0.3
                        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                        self.present(vc, animated: true, completion: nil)
                    
                        vc.time.text = self.timeDisplay.text!
                        self.ballView?.pause = true
                }
            }
        }
    }
    
    // Timer setup
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    // Timer record update and display
    @objc func updateTimer() {
        seconds += 1
        timeDisplay.text = timeString(time: TimeInterval(seconds))
    }
    
    // Timer converter
    func timeString(time:TimeInterval) -> String {
        let m = Int(time) / 6000
        let s = Int(time) / 100 % 60
        let ms = Int(time) % 100
        return String(format: "%02d:%02d:%02d", m, s, ms)
    }
    
    // Get the final score and save to disk.
    private func saveScore(newScore: ScoreRecord) {
        
        // Load the previously saved scores.
        var scores = loadSavedScores()
        
        // If it is not nil, append the new score. Otherwise, instantiate an array and add the new score.
        if (scores != nil) {
            scores?.append(newScore)
        }
        else {
            scores = [ScoreRecord]()
            scores?.append(newScore)
        }
        
        // Sort the score.
        scores?.sort(by: { $0.score < $1.score })
        
        // If the number of saved scores exceed 10, only keep the top 10.
        if scores!.count > 10 {
            scores = Array(scores![0...9])
        }
        
        // Save the score array.
        saveScoreArray(scores: scores!)
    }
    
    // Load the saved scores according to the URL defined in ScoreRecord class.
    private func loadSavedScores() -> [ScoreRecord]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ScoreRecord.ArchiveURLArray[levelNumber - 1].path) as? [ScoreRecord]
    }
    
    // Save the updated scores according to the URL defined in ScoreRecord class.
    private func saveScoreArray(scores: [ScoreRecord]) {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(scores, toFile: ScoreRecord.ArchiveURLArray[levelNumber - 1].path)
        if isSuccessfulSave {
            print("save successful")
        }
        else {
            print("save fails")
        }
    }
    
}
