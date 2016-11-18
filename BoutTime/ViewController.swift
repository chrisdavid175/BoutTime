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
    // FIXME: Remove image var
    //let successButton = UIImage(named: Bundle.main.path(forResource: "next_round_success", ofType: "png"))
    let successButton = UIImage(named: "next_round_success.png")
    let failButton = UIImage(named: "next_round_fail.png")
    
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
    @IBOutlet weak var shakeLabel: UILabel!
    @IBOutlet weak var timerOrButton: UIButton!
    
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
        
        let eventLabelCornerRadius = 5
        let clipsToBounds = true
        event1Label.layer.cornerRadius = CGFloat(eventLabelCornerRadius)
        event2Label.layer.cornerRadius = CGFloat(eventLabelCornerRadius)
        event3Label.layer.cornerRadius = CGFloat(eventLabelCornerRadius)
        event4Label.layer.cornerRadius = CGFloat(eventLabelCornerRadius)
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
        let tempEvent1 = eventsGame.eventRound[event1Index]
        let tempEvent2 = eventsGame.eventRound[event2Index]
        eventsGame.eventRound[event1Index] = tempEvent2
        eventsGame.eventRound[event2Index] = tempEvent1
        
    }
    
    @IBAction func event1DownButton() {
        swapEvents(event1Index: 0, event2Index: 1)
        loadEventLabels()
    }

    @IBAction func event2UpButton() {
        swapEvents(event1Index: 1, event2Index: 0)
        loadEventLabels()
    }
    
    @IBAction func event2DownButton() {
        swapEvents(event1Index: 1, event2Index: 2)
        loadEventLabels()
    }
    
    @IBAction func event3UpButton() {
        swapEvents(event1Index: 2, event2Index: 1)
        loadEventLabels()
    }
    
    @IBAction func event3DownButton() {
        swapEvents(event1Index: 2, event2Index: 3)
        loadEventLabels()
    }
    
    @IBAction func event4UpButton() {
        swapEvents(event1Index: 3, event2Index: 2)
        loadEventLabels()
    }
 
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if eventsGame.checkEventRoundOrder() {
                correctRounds += 1
                timerOrButton.setImage(successButton, for: .normal)
                //timerOrButton.setImage(UIImage(named: "next_round_success.png"), for: .normal)
            } else {
                timerOrButton.setImage(failButton, for: .normal)
            }
            roundsPlayed += 1
            self.shakeLabel.text = "Tap events to learn more"
            //REMOVE:
            //FIXME
            // FIXME: For loop check to remove
            for event in eventsGame.eventRound {
                print(event.date)
            }
            //timerOrButton.setBackgroundImage(successButton, for: .normal)
        }
    }
    
    

}

