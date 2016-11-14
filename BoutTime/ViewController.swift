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



    @IBOutlet weak var event1Label: UILabel!
    @IBOutlet weak var event2Label: UILabel!
    @IBOutlet weak var event3Label: UILabel!
    @IBOutlet weak var event4Label: UILabel!
    
    //var eventLabels = [ event1Label, event2Label, event3Label, event4Label ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatLabels()
        loadRound()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Helper Methods

    func formatLabels() {
        /*
        for label in eventLabels {
            label.layer.cornerRadius = 5
            label.clipsToBounds = true
        }
        */
        
        eventLabelCornerRadius = 5
        clipsToBounds = true
        event1Label.layer.cornerRadius = eventLabelCornerRadius
        event2Label.layer.cornerRadius = eventLabelCornerRadius
        event3Label.layer.cornerRadius = eventLabelCornerRadius
        event4Label.layer.cornerRadius = eventLabelCornerRadius
        event1Label.clipsToBounds = clipsToBounds
        event2Label.clipsToBounds = clipsToBounds
        event3Label.clipsToBounds = clipsToBounds
        event4Label.clipsToBounds = clipsToBounds
        
    }
    
    func loadRound() {
        eventsGame.resetRound()
        loadEventLabels()
    }
    
    func loadEventLabels() {
        event1Label.text = eventsGame.eventRound[0].name
        event2Label.text = eventsGame.eventRound[1].name
        event3Label.text = eventsGame.eventRound[2].name
        event4Label.text = eventsGame.eventRound[3].name
    }
    
    func swapEvents(event1Index: Int, event2Index: Int) {
        tempEvent1 = eventGames.eventRound[event1Index]
        tempEvent2 = eventGames.eventRound[event2Index]
        eventGames.eventRound[event1Index] = tempEvent2
        eventGames.eventRound[event2Index] = tempEvent1
        
    }
    
    @IBAction func event1Label() {
    }
    

}

