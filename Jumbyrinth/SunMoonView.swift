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

//TODO: read weather data

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
            
            if ((sunrise.compare(Date()) == ComparisonResult.orderedAscending)&&(sunset.compare(Date()) == ComparisonResult.orderedDescending)) {
                self.imageView.image = UIImage.init(named: "Sun");
                self.currentPoint = CGPoint(x: (-CGFloat(sunrise.timeIntervalSinceNow)) / CGFloat(sunset.timeIntervalSince(sunrise)) * bounds.maxX, y: bounds.maxY/2)
                print(currentPoint)
            }
            else {
                self.imageView.image = UIImage.init(named: "Moon");
                self.currentPoint = CGPoint(x: (1 - (CGFloat(sunrise.timeIntervalSinceNow)) / (CGFloat(86400) -  CGFloat(sunset.timeIntervalSince(sunrise)))) * bounds.maxX, y: bounds.maxY/2)
                print(currentPoint)
            }
            
            //TODO: change icon based on the weather
            
        }
        catch {
            print("no data loaded")
        }
       
    }
    
    
    private func setupUI() {
        
        currentPoint = CGPoint(x: -100, y: bounds.maxY/2)
    
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        let loc = manager.location?.coordinate
        
        let weatherUrl = URL(string: String(format: "https://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&APPID=705a4acb14b320b3657d6cd1e9206db6", Double((loc?.latitude)!), Double((loc?.longitude)!)))
        
        do {
            let data = try Data(contentsOf: weatherUrl!)
            self.loadWeather(data: data)
        }
        catch {}
        
        addSubview(self.imageView)
        
        self.imageView.center = self.currentPoint
        
        //print(minute)
        
        manager.stopUpdatingLocation()

    }
}
