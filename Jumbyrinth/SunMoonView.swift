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

    
    private func setupUI() {
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        
        
        
        imageView.image = UIImage.init(named: "Sun")
        
        let date = Date()
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: date) + calendar.component(.hour, from: date) * 60
        
        addSubview(imageView)
        currentPoint = CGPoint(x: (CGFloat.init(integerLiteral: minute) / CGFloat.init(integerLiteral: 24 * 60)) * bounds.maxX, y: bounds.maxY/2)
        
        print(minute)
        
        imageView.center = currentPoint
        
        manager.stopUpdatingLocation()

    }
}
