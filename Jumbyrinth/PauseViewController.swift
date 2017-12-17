//
//  PauseViewController.swift
//  Jumbyrinth
//
//  Created by Shenghao Lin on 2017/11/29.
//  Copyright © 2017年 nyu.edu. All rights reserved.
//

import UIKit

// This class is designed for the pause pop-up screen
class PauseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Return to level selection, which is the grandparent of this screen
    @IBAction func ReturnPushed(_ sender: Any) {
        let vc = self.presentingViewController!.presentingViewController!
        vc.dismiss(animated: false, completion: nil)
    }
    
    //Resume the game. Should resume the timer and reactivate the ball movement
    @IBAction func resumePushed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let vc = self.presentingViewController as! ViewController
        vc.view.alpha = 1
        vc.playBall()
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
