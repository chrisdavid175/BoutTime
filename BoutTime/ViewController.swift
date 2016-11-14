//
//  ViewController.swift
//  BoutTime
//
//  Created by Chris David on 10/28/16.
//  Copyright © 2016 Chris David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let roundsPerGame = 6
    var roundsPlayed = 0
    var correctRounds = 0
    
    var eventsGame: EventQuiz
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let eventDictionary = try PlistConverter.dictionaryFromFile(resource: "EventList", ofType: "plist")
            let eventList = try EventUnarchiver.eventListFromDictionary(dictionary: eventDictionary)
            self.eventsGame = EventQuiz(eventList: eventList)
            
        } catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
    }



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
        loadRound();

        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

