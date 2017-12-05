//
//  MainViewController.swift
//  Jumbyrinth
//
//  Created by Shenghao Lin on 2017/12/4.
//  Copyright © 2017年 nyu.edu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    @IBOutlet var colorview: ColorfulView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.colorview.runTimer()
        

        // Do any additional setup after loading the view.
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
