//
//  PauseViewController.swift
//  Jumbyrinth
//
//  Created by Shenghao Lin on 2017/11/29.
//  Copyright © 2017年 nyu.edu. All rights reserved.
//

import UIKit

class PauseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resumePushed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let vc = self.presentingViewController as! ViewController
        vc.playBall()
        print(vc.ballView?.accelleration as Any)
        print(vc.ballView?.currentPoint as Any)
        
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
