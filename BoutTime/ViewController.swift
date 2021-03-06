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
    let successButton = UIImage(named: "next_round_success.png")
    let failButton = UIImage(named: "next_round_fail.png")
    var timer: Timer?
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
    @IBOutlet weak var event1DButton: UIButton!
    @IBOutlet weak var event2UButton: UIButton!
    @IBOutlet weak var event2DButton: UIButton!
    @IBOutlet weak var event3UButton: UIButton!
    @IBOutlet weak var event3DButton: UIButton!
    @IBOutlet weak var event4UButton: UIButton!
    @IBOutlet weak var timerOrButton: UIButton!
    @IBOutlet weak var yourScoreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var webViewExitButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet var tapGestureEvent1: UITapGestureRecognizer!
    @IBOutlet var tapGestureEvent2: UITapGestureRecognizer!
    @IBOutlet var tapGestureEvent3: UITapGestureRecognizer!
    @IBOutlet var tapGestureEvent4: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatLabels()
        loadRound()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Reorder events based on which buttons are clicked
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
 
    // Overrides functions to detect the shake gesture, and then checks the order of the events
    override func becomeFirstResponder() -> Bool {
        return true
    }
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            eventCheck()
        }
    }
    
    // Presents score if 6 rounds have been played. Otherwise, it loads the next round
    @IBAction func nextRound() {
        if roundsPlayed == roundsPerGame {
            presentScore()
        } else {
            loadRound()
        }
    }
    
    // Sets a 60 sec timer display, and checks the event order if time runs out
    func resetTimer() {
        var roundTime = 60
        let minutes = String(format: "%01d", roundTime / 60)
        let seconds = String(format: "%02d", roundTime % 60)
        timerOrButton.setImage(nil, for: .normal)
        shakeLabel.text = "Order events in ascending order\ntop to bottom\nShake to complete"
        timerOrButton.isEnabled = false
        timerOrButton.setTitle("\(minutes):\(seconds)", for: .normal)
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            roundTime -= 1
            let minutes = String(format: "%01d", roundTime / 60)
            let seconds = String(format: "%02d", roundTime % 60)
            self.timerOrButton.setTitle("\(minutes):\(seconds)", for: .normal)
            if roundTime == 0 {
                self.eventCheck()
            }
        }
    }
    
    // Starts a new game and resets the rounds
    @IBAction func playAgain() {
        roundsPlayed = 0
        toggleVisibilityOfScoreItems(status: true)
        toggleVisibilityOfRoundItems(status: false)
        loadRound()
    }
    
    // Exits the webview
    @IBAction func exitWebView() {
        toggleVisibilityOfWebViewItems(status: true)
        toggleVisibilityOfScoreItems(status: true)
        toggleVisibilityOfRoundItems(status: false)
    }
    
    // Launches a web view based on which event label is tapped
    @IBAction func event1Tap(_ sender: UITapGestureRecognizer) {
        launchURL(index: 0)
    }
    @IBAction func event2Tap(_ sender: UITapGestureRecognizer) {
        launchURL(index: 1)
    }
    @IBAction func event3Tap(_ sender: UITapGestureRecognizer) {
        launchURL(index: 2)
    }
    @IBAction func event4Tap(_ sender: UITapGestureRecognizer) {
        launchURL(index: 3)
    }
    
    // Hide everything and present the score and play again button
    func presentScore() {
        toggleVisibilityOfRoundItems(status: true)
        scoreLabel.text = "\(correctRounds)/\(roundsPerGame)"
        toggleVisibilityOfScoreItems(status: false)
    }
    
    // Function to launch more info on an event in Web view
    func launchURL(index: Int) {
        toggleVisibilityOfScoreItems(status: true)
        toggleVisibilityOfRoundItems(status: true)
        toggleVisibilityOfWebViewItems(status: false)
        if let url = NSURL(string: eventsGame.eventRound[index].url) {
            //UIApplication.shared.openURL(url as URL)
            //UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            let request = NSURLRequest(url: url as URL)
            webView.loadRequest(request as URLRequest)
            
        }
    }

    // MARK: - Helper Methods
    
    // Used a function to handheld the formatting of labels
    func formatLabels() {
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
    
    // Prepares and loads the round
    func loadRound() {
        toggleVisibilityOfScoreItems(status: true)
        toggleVisibilityOfWebViewItems(status: true)
        toggleEventLabelTap(status: false)
        toggleEventButtons(status: true)
        eventsGame.resetRound()
        loadEventLabels()
        resetTimer()
    }
    
    // Populates each label with the event from the eventRound
    func loadEventLabels() {
        event1Label.text = eventsGame.eventRound[0].name
        event2Label.text = eventsGame.eventRound[1].name
        event3Label.text = eventsGame.eventRound[2].name
        event4Label.text = eventsGame.eventRound[3].name
    }
    
    // Function to swap event positions
    func swapEvents(event1Index: Int, event2Index: Int) {
        let tempEvent1 = eventsGame.eventRound[event1Index]
        let tempEvent2 = eventsGame.eventRound[event2Index]
        eventsGame.eventRound[event1Index] = tempEvent2
        eventsGame.eventRound[event2Index] = tempEvent1
    }
    
    // Check if order of events is in ascendign order based on positions
    // Increment the number of rounds played
    // Display appropriate button image based on correctnesss
    // Disable event buttons from trying to reorder and recheck
    // Enable tap on labels
    func eventCheck() {
        if self.eventsGame.checkEventRoundOrder() {
            self.correctRounds += 1
            self.timerOrButton.setImage(self.successButton, for: .normal)
        } else {
            self.timerOrButton.setImage(self.failButton, for: .normal)
        }
        self.roundsPlayed += 1
        self.timerOrButton.isEnabled = true
        self.shakeLabel.text = "Tap events to learn more"
        
        toggleEventLabelTap(status: true)
        toggleEventButtons(status: false)

    }
    
    // Functions to help toggle various items enabled/disabled or hidden/shown
    func toggleEventButtons(status: Bool) {
        event1DButton.isEnabled = status
        event2UButton.isEnabled = status
        event2DButton.isEnabled = status
        event3UButton.isEnabled = status
        event3DButton.isEnabled = status
        event4UButton.isEnabled = status
    }
    func toggleVisibilityOfScoreItems(status: Bool) {
        yourScoreLabel.isHidden = status
        scoreLabel.isHidden = status
        playAgainButton.isHidden = status
    }
    func toggleVisibilityOfRoundItems(status: Bool) {
        event1Label.isHidden = status
        event2Label.isHidden = status
        event3Label.isHidden = status
        event4Label.isHidden = status
        event1DButton.isHidden = status
        event2UButton.isHidden = status
        event2DButton.isHidden = status
        event3UButton.isHidden = status
        event3DButton.isHidden = status
        event4UButton.isHidden = status
        timerOrButton.isHidden = status
        shakeLabel.isHidden = status
    }
    func toggleVisibilityOfWebViewItems(status: Bool) {
        webViewExitButton.isHidden = status
        webView.isHidden = status
    }
    func toggleEventLabelTap(status: Bool) {
        tapGestureEvent1.isEnabled = status
        tapGestureEvent2.isEnabled = status
        tapGestureEvent3.isEnabled = status
        tapGestureEvent4.isEnabled = status
    }
    

}

