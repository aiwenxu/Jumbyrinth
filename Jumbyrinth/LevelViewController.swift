//
//  LevelViewController.swift
//  Jumbyrinth
//
//  Created by Aiwen Xu on 04/12/2017.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

import UIKit

class LevelViewController: UIViewController {

    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet var colorview: ColorfulView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorview.runUpdateTimer()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
