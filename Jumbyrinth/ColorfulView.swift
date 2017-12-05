//
//  ColorfulView.swift
//  Jumbyrinth
//
//  Created by Shenghao Lin on 2017/12/4.
//  Copyright © 2017年 nyu.edu. All rights reserved.
//

import UIKit

class ColorfulView: UIView {
    
    struct Static {
        
        static var red = 0.08
        static var green = 0.67
        static var blue = 0.90
        
        static var now = "Blue"
    }
    
    var timer = Timer()
    
    func runTimer() {
        
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        
    }
    
    
    @objc func updateTimer() {
        
        if (Static.now == "Blue") {
            Static.blue += 0.0009
            Static.red -= 0.0006
            Static.green -= 0.0003
        }
        if (Static.now == "Red") {
            Static.blue -= 0.0003
            Static.red += 0.0009
            Static.green -= 0.0006
        }
        if (Static.now == "Green") {
            Static.blue -= 0.0006
            Static.red -= 0.0003
            Static.green += 0.0009
        }
        
        if (Static.red > 0.95) {
            Static.red = 0.95
            Static.now = "Blue"
            print("Blue")
        }
        if (Static.red < 0.05) {
            Static.red = 0.05
        }
        
        if (Static.green > 0.95) {
            Static.green = 0.95
            Static.now = "Red"
            print("Red")
        }
        if (Static.green < 0.05) {
            Static.green = 0.05
        }
        
        if (Static.blue > 0.95) {
            Static.blue = 0.95
            Static.now = "Green"
            print("Green")
        }
        if (Static.blue < 0.05) {
            Static.blue = 0.05
        }
        
        self.backgroundColor = UIColor.init(red: CGFloat(Static.red), green: CGFloat(Static.green), blue: CGFloat(Static.blue), alpha: 1.0)
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
