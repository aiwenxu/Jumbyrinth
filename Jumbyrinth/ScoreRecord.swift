//
//  ScoreRecord.swift
//  Jumbyrinth
//
//  Created by Aiwen Xu on 06/12/2017.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

import UIKit
import os.log

class ScoreRecord: NSObject, NSCoding {
    
    //MARK: Properties
    var score: String
    var date: Date
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
//    static let ArchiveURLLevel1 = DocumentsDirectory.appendingPathComponent("level1")
//    static let ArchiveURLLevel2 = DocumentsDirectory.appendingPathComponent("level2")
//    static let ArchiveURLLevel3 = DocumentsDirectory.appendingPathComponent("level3")
//    static let ArchiveURLLevel4 = DocumentsDirectory.appendingPathComponent("level4")
//    static let ArchiveURLLevel5 = DocumentsDirectory.appendingPathComponent("level5")
    static let ArchiveURLArray = [DocumentsDirectory.appendingPathComponent("level1"),
                                  DocumentsDirectory.appendingPathComponent("level2"),
                                  DocumentsDirectory.appendingPathComponent("level3"),
                                  DocumentsDirectory.appendingPathComponent("level4"),
                                  DocumentsDirectory.appendingPathComponent("level5")]
    
    //MARK: Types
    struct PropertyKeys {
        static let score = "score"
        static let date = "date"
    }
    
    //MARK: Initialization
    init(score: String, date: Date) {
        self.score = score
        self.date = date
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(score, forKey: PropertyKeys.score)
        aCoder.encode(date, forKey: PropertyKeys.date)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let score = aDecoder.decodeObject(forKey: PropertyKeys.score)
//        print("ScoreRecord.swift score: ", score)
        let date = aDecoder.decodeObject(forKey: PropertyKeys.date)
//        print("ScoreRecord.swift date: ", date)
        self.init(score: score as! String, date: date as! Date)
    }
    
    override var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return String.init(format: "%s %s", self.score, dateFormatter.string(from: self.date))
    }
    
}
