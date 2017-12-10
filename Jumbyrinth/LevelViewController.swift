//
//  LevelViewController.swift
//  Jumbyrinth
//
//  Created by Aiwen Xu on 04/12/2017.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

import UIKit

// The view controller for the level page.
class LevelViewController: UIViewController {

    // If the back button is pressed, the level view is dismissed and the app returns to the menu.
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // The colorful background.
    @IBOutlet var colorview: ColorfulView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Run the colorful background so that its color changes over time.
        colorview.runUpdateTimer()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Let the destination view controller know which button is pressed so that it can render different levels. Set the level number in the
    // destination view controller depending on which button is pressend and which segue is triggered.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! ViewController;
        
        if segue.identifier == "level1" {
            vc.levelNumber = 1
        }
        else if segue.identifier == "level2" {
            vc.levelNumber = 2
        }
        else if segue.identifier == "level3" {
            vc.levelNumber = 3
        }
        else if segue.identifier == "level4" {
            vc.levelNumber = 4
        }
        else if segue.identifier == "level5" {
            vc.levelNumber = 5
        }
        else if segue.identifier == "surprise" {
            vc.levelNumber = 6
        }
        
    }

}
