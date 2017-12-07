//
//  LeaderboardTableViewController.swift
//  Jumbyrinth
//
//  Created by Aiwen Xu on 06/12/2017.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

import UIKit

class LeaderboardTableViewController: UITableViewController {
    
    @IBOutlet weak var noScoreLabel: UILabel!
    @IBOutlet weak var levelboardTitle: UILabel!
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //read the storyboard id
    var levelNumber = 0
    
    var records : [ScoreRecord]? = [ScoreRecord]()
    
    private func loadSavedScores() -> [ScoreRecord]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ScoreRecord.ArchiveURLArray[levelNumber - 1].path) as? [ScoreRecord]
    }
    
    private func initializeLevelNumber() {
        let levelText: String = self.restorationIdentifier!
        let start = levelText.index(levelText.startIndex, offsetBy: 5)
        let end = levelText.endIndex
        self.levelNumber = Int(String(levelText[start..<end]))!
    }
    
    override func viewDidLoad() {
        
        self.tableView.backgroundView = ColorfulView()
        (self.tableView.backgroundView as! ColorfulView).updateTimer()
        (self.tableView.backgroundView as! ColorfulView).runUpdateTimer()
        
        self.tableView.separatorColor = UIColor.clear
        
        initializeLevelNumber()
        records = loadSavedScores()
        if (levelNumber < 6){
            levelboardTitle.text = String.init(format: "Level %d", levelNumber)
        }
        else {
            levelboardTitle.text = String("Level X")
        }
        
        if records != nil {
            noScoreLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        }
//        if records == nil {
//            let fakeRecord = ScoreRecord(score: "No score yet", date: Date())
//            records?.append(fakeRecord)
//            print("added fake score")
//        }
        
        super.viewDidLoad()
        
//        let colorView = ColorfulView()
//        self.tableView.addSubview(colorView)
//        self.tableView.sendSubview(toBack: colorView)
//        colorView.runUpdateTimer()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if records == (nil) {
            return 0
        }
        else {
            return (records?.count)!
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ScoreTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ScoreTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let record = records![indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        cell.scoreLabel.text = record.score
        cell.dateLabel.text = dateFormatter.string(for: record.date)
        cell.backgroundColor = UIColor.clear
        
        
        return cell
        
        

    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
