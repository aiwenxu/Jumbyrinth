//
//  SunMoonView.swift
//  Jumbyrinth
//
//  Created by Shenghao Lin on 2017/11/28.
//  Copyright © 2017年 nyu.edu. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

// The class designed to control the sun/moon icon on the buttom of the screen
class SunMoonView: UIView {
    
    // Location service used to get the location and further to read current weather info in this place
    
    var imageWidth : CGFloat = 80
    var imageHeight : CGFloat = 80
    var imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    
    var currentPoint = CGPoint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // The method using given weather data from url to draw sun/moon icon
    private func loadWeather(data : Data) {
        
        drawSunAndMoon(sunrise: defaultSunrise(), sunset: defaultSunset())
    }
    
    //The actual drawing methond the sun/moon icon
    func drawSunAndMoon(sunrise : Date, sunset : Date) {
        
        //if currently during day
        if ((sunrise.compare(Date()) == ComparisonResult.orderedAscending)&&(sunset.compare(Date()) == ComparisonResult.orderedDescending)) {
            self.imageView.image = UIImage.init(named: "Sun");
            print("sun")
            self.currentPoint = CGPoint(x: (-CGFloat(sunrise.timeIntervalSinceNow)) / CGFloat(sunset.timeIntervalSince(sunrise)) * bounds.maxX, y: bounds.maxY/2)
            print(currentPoint)
        }
            
        //if current time is before after today's sunrise
        else if (sunrise.compare(Date()) == ComparisonResult.orderedDescending){
            self.imageView.image = UIImage.init(named: "Moon");
            print("Moon")
            self.currentPoint = CGPoint(x: (1 - (CGFloat(sunrise.timeIntervalSinceNow)) / (CGFloat(86400) -  CGFloat(sunset.timeIntervalSince(sunrise)))) * bounds.maxX, y: bounds.maxY/2)
            print(currentPoint)
        }
            
        //if current time is after today's sunset
        else {
            self.imageView.image = UIImage.init(named: "Moon");
            print("Moon")
            self.currentPoint = CGPoint(x: (CGFloat(-sunset.timeIntervalSinceNow) / (CGFloat(86400) -  CGFloat(sunset.timeIntervalSince(sunrise)))) * bounds.maxX, y: bounds.maxY/2)
            print(currentPoint)
        }
    }
    
    // Set today's 6:00 pm to be default sunset time
    func defaultSunset() -> Date  {
        
        let now = Date()
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        components.hour = 18
        components.minute = 0
        return Calendar.current.date(from: components)!
    }
    
    // Set today's 6:00 am to be default sunrise time
    func defaultSunrise() -> Date  {
        
        let now = Date()
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        components.hour = 6
        components.minute = 0
        return Calendar.current.date(from: components)!
    }
    
    // Initialize this view and draw the sun/moon icon in the proper position
    func setupUI() {
        
        currentPoint = CGPoint(x: -100, y: bounds.maxY/2)
        drawSunAndMoon(sunrise: defaultSunrise(), sunset: defaultSunset())
        
        addSubview(self.imageView)
        self.imageView.center = self.currentPoint
    }
}
