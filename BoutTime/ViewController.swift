//
//  ViewController.swift
//  BoutTime
//
//  Created by Chris David on 10/28/16.
//  Copyright © 2016 Chris David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Event1Label: UILabel!
    @IBOutlet weak var Event2Label: UILabel!
    @IBOutlet weak var Event3Label: UILabel!
    @IBOutlet weak var Event4Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Event1Label.layer.cornerRadius = 5
        Event2Label.layer.cornerRadius = 5
        Event3Label.layer.cornerRadius = 5
        Event4Label.layer.cornerRadius = 5
        Event1Label.clipsToBounds = true
        Event2Label.clipsToBounds = true
        Event3Label.clipsToBounds = true
        Event4Label.clipsToBounds = true
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

