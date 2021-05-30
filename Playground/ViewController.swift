//
//  ViewController.swift
//  Playground
//
//  Created by lyj on 2020/10/25.
//  Copyright © 2020 lyj. All rights reserved.
//

import UIKit
import AXVisionSDK

class ViewController: UIViewController {
    @IBOutlet weak var SLAMBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onGoSLAM(_ sender: Any) {
        performSegue(withIdentifier: "goSLAM", sender: self)
    }
}

