//
//  ScoreRecord.swift
//  Jumbyrinth
//
//  Created by Aiwen Xu on 06/12/2017.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

import UIKit
import os.log

// A class that represents a score record.
class ScoreRecord: NSObject, NSCoding {
    
    //MARK: Properties
    // The amount of time used to complete the game.
    var score: String
    // The date and time the score record is created.
    var date: Date
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    // Separately store the score records from different levels. Keep the URLs in an array.
    static let ArchiveURLArray = [DocumentsDirectory.appendingPathComponent("level1"),
                                  DocumentsDirectory.appendingPathComponent("level2"),
                                  DocumentsDirectory.appendingPathComponent("level3"),
                                  DocumentsDirectory.appendingPathComponent("level4"),
                                  DocumentsDirectory.appendingPathComponent("level5"),
                                  DocumentsDirectory.appendingPathComponent("surprise")]
    
    //MARK: Types
    // A struct that maps the property name to a key string.
    struct PropertyKeys {
        static let score = "score"
        static let date = "date"
    }
    
    //MARK: Initialization
    // Initialize a score record using the specified score and date.
    init(score: String, date: Date) {
        self.score = score
        self.date = date
    }
    
    //MARK: NSCoding
    // Required methods from NSCoding. NSCoding is a way to achieve data persistence.
    // The method to encode a object.
    func encode(with aCoder: NSCoder) {
        aCoder.encode(score, forKey: PropertyKeys.score)
        aCoder.encode(date, forKey: PropertyKeys.date)
    }
    // The method to decode a saved object.
    required convenience init(coder aDecoder: NSCoder) {
        let score = aDecoder.decodeObject(forKey: PropertyKeys.score)
        let date = aDecoder.decodeObject(forKey: PropertyKeys.date)
        self.init(score: score as! String, date: date as! Date)
    }
    
}
