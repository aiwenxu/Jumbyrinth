//
//  PopUpViewController.swift
//  Jumbyrinth
//
//  Created by Shenghao Lin on 2017/11/28.
//  Copyright © 2017年 nyu.edu. All rights reserved.
//

import UIKit

// This class is designed for the result pop-up page.
class PopUpViewController: UIViewController {

    @IBOutlet weak var time: UILabel!
    
    //Press again, return to the game screen and reset the game to the default status
    @IBAction func again(_ sender: Any) {
        
        dismiss(animated: false, completion: nil)
        
        let vc = self.presentingViewController as! ViewController
        vc.ballView?.currentPoint = CGPoint(x: 10, y: 10)
        vc.viewDidLoad()
    }
    
    //Return to level selection, which is the grandparent of this screen
    @IBAction func dismiss(_ sender: Any) {
        
        dismiss(animated: false, completion: nil)
        self.presentingViewController!.presentingViewController?.dismiss(animated: false, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
