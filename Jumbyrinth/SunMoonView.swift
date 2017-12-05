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

class SunMoonView: UIView, CLLocationManagerDelegate {
    
    var manager:CLLocationManager!
    
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

    private func loadWeather(data : Data) {
        
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            let sys = json["sys"] as! [String:AnyObject]
            let sunset = Date(timeIntervalSince1970: sys["sunset"] as! Double)
            let sunrise = Date(timeIntervalSince1970: sys["sunrise"] as! Double)
            
            drawSunAndMoon(sunrise: sunrise, sunset: sunset)
            
            //TODO: change icon based on the weather
            
        }
        catch {
            
            drawSunAndMoon(sunrise: defaultSunrise(), sunset: defaultSunset())
            
            print("no data loaded")
        }
       
    }
    
    func drawSunAndMoon(sunrise : Date, sunset : Date) {
        if ((sunrise.compare(Date()) == ComparisonResult.orderedAscending)&&(sunset.compare(Date()) == ComparisonResult.orderedDescending)) {
            self.imageView.image = UIImage.init(named: "Sun");
            print("sun")
            self.currentPoint = CGPoint(x: (-CGFloat(sunrise.timeIntervalSinceNow)) / CGFloat(sunset.timeIntervalSince(sunrise)) * bounds.maxX, y: bounds.maxY/2)
            print(currentPoint)
        }
        else if (sunrise.compare(Date()) == ComparisonResult.orderedDescending){
            self.imageView.image = UIImage.init(named: "Moon");
            print("Moon")
            self.currentPoint = CGPoint(x: (1 - (CGFloat(sunrise.timeIntervalSinceNow)) / (CGFloat(86400) -  CGFloat(sunset.timeIntervalSince(sunrise)))) * bounds.maxX, y: bounds.maxY/2)
            print(currentPoint)
        }
        else {
            self.imageView.image = UIImage.init(named: "Moon");
            print("Moon")
            self.currentPoint = CGPoint(x: (CGFloat(-sunset.timeIntervalSinceNow) / (CGFloat(86400) -  CGFloat(sunset.timeIntervalSince(sunrise)))) * bounds.maxX, y: bounds.maxY/2)
            print(currentPoint)
        }
    }
    
    func defaultSunset() -> Date  {
        
        let now = Date()
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        components.hour = 18
        components.minute = 0
        return Calendar.current.date(from: components)!
        
    }
    
    func defaultSunrise() -> Date  {
        
        let now = Date()
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        components.hour = 6
        components.minute = 0
        return Calendar.current.date(from: components)!
        
    }
    
    private func setupUI() {
        
        currentPoint = CGPoint(x: -100, y: bounds.maxY/2)
    
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        

        
        let loc = manager.location?.coordinate
        
        if (loc != nil) {
            
            do {
                let weatherUrl = URL(string: String(format: "https://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&APPID=705a4acb14b320b3657d6cd1e9206db6", Double((loc?.latitude)!), Double((loc?.longitude)!)))
                let data = try Data(contentsOf: weatherUrl!)
                self.loadWeather(data: data)
            }
            catch {
                
                drawSunAndMoon(sunrise: defaultSunrise(), sunset: defaultSunset())
                
                print("no data loaded")
            }
        }
        else {
            
            drawSunAndMoon(sunrise: defaultSunrise(), sunset: defaultSunset())
            
            print("no data loaded")
        }
        
        addSubview(self.imageView)
        
        self.imageView.center = self.currentPoint
        
        
        manager.stopUpdatingLocation()

    }
}
