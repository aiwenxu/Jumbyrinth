//
//  LeaderboardTableViewController.swift
//  Jumbyrinth
//
//  Created by Aiwen Xu on 06/12/2017.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

import UIKit

// The view controller for each page of the leaderboard.
class LeaderboardTableViewController: UITableViewController {
    
    // The label that indicates there are no saved scores yet.
    @IBOutlet weak var noScoreLabel: UILabel!
    // The label displaying the level name.
    @IBOutlet weak var levelboardTitle: UILabel!
    
    // If the back button is pressed, the view controller is dismissed and the app returns to the menu.
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // Initialize the level number.
    var levelNumber = 0
    
    // Initialize an array of the score records.
    var records : [ScoreRecord]? = [ScoreRecord]()
    
    override func viewDidLoad() {
        
        // Disable the selection feature in the table since the leaderboard is static.
        tableView.allowsSelection = false
        
        // Set the background to be colorful and run it so that it color changes over time.
        self.tableView.backgroundView = ColorfulView()
        (self.tableView.backgroundView as! ColorfulView).updateTimer()
        (self.tableView.backgroundView as! ColorfulView).runUpdateTimer()
        self.tableView.separatorColor = UIColor.clear
        
        // Initialize the level number.
        initializeLevelNumber()
        
        // Load the saved score records.
        records = loadSavedScores()
        
        // Configure the label which displays the name of the level.
        if (levelNumber < 6){
            levelboardTitle.text = String.init(format: "Level %d", levelNumber)
        }
        else {
            levelboardTitle.text = String("Level X")
        }
        
        // If there are previously saved scores, set the label indicating "No scores yet!" to transparent.
        if records != nil {
            noScoreLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        }
        
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Load the saved scores according to the level number by using the URL stored in the score record class.
    private func loadSavedScores() -> [ScoreRecord]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: ScoreRecord.ArchiveURLArray[levelNumber - 1].path) as? [ScoreRecord]
    }
    
    // Read from the restoration id (from the storyboard) and set the level number according to the id.
    private func initializeLevelNumber() {
        let levelText: String = self.restorationIdentifier!
        let start = levelText.index(levelText.startIndex, offsetBy: 5)
        let end = levelText.endIndex
        self.levelNumber = Int(String(levelText[start..<end]))!
    }
    
    
    // MARK: - Table view data source
    // Required methods.
    override func numberOfSections(in tableView: UITableView) -> Int {
        // The number of sections of the table is always 1.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // The number of rows equal to the number of records.
        // If the record array is nil, then return 0.
        if records == (nil) {
            return 0
        }
        //If there is a record array, return the number of entries in the array.
        else {
            return (records?.count)!
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue cells and reuse.
        let cellIdentifier = "ScoreTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ScoreTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ScoreTableViewCell.")
        }
        
        // Fetch the appropriate score record according to the index path.
        let record = records![indexPath.row]
        
        // Format the date appropriately.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        // Display the score and the date in the cell.
        cell.scoreLabel.text = record.score
        cell.dateLabel.text = dateFormatter.string(for: record.date)
        
        // Set the background color to be transparent.
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
