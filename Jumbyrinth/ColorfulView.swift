//
//  ColorfulView.swift
//  Jumbyrinth
//
//  Created by Shenghao Lin on 2017/12/4.
//  Copyright © 2017年 nyu.edu. All rights reserved.
//

import UIKit

// The class designed to control color changing
class ColorfulView: UIView {
    
    // Struct to contain static variables, as swift does not allow static variable defined in a normal class
    // static variable makes the color consistent through screens
    struct Static {
        
        //color variable
        static var red = 0.08
        static var green = 0.67
        static var blue = 0.90
        
        //color changing mode
        static var now = "Blue"
    }
    
    // timer to trigger automatic color variable changing and background color changing accordingly
    var timer = Timer()
    var updateTime = Timer()
    
    // color variable changing
    func runTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: (#selector(ColorfulView.updateTimer)), userInfo: nil, repeats: true)
        
    }
    
    // color change showing
    func runUpdateTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: (#selector(ColorfulView.updateColor)), userInfo: nil, repeats: true)
    }
    
    // change the color variables
    // there are three modes of color changing mode: "Blue" "Red" "Green"
    // for each color among blue, red and green, the upper bound is 0.95 and the lower bound is 0.05
    // Once any of upper bounds above is reached, the color changing mode switches
    @objc func updateTimer() {
        
        //color changing mode "Blue"
        if (Static.now == "Blue") {
            Static.blue += 0.00015
            Static.red -= 0.00010
            Static.green -= 0.00005
        }
        
        //color changing mode "Red"
        if (Static.now == "Red") {
            Static.blue -= 0.00005
            Static.red += 0.00015
            Static.green -= 0.0001
        }
        
        //color changing mode "Green"
        if (Static.now == "Green") {
            Static.blue -= 0.0001
            Static.red -= 0.00005
            Static.green += 0.00015
        }
        
        //boundary handler
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
    }

    // force the view to change its background color according to the variables
    @objc func updateColor() {
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
