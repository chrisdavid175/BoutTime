//
//  EventQuiz.swift
//  BoutTime
//
//  Created by Chris David on 10/29/16.
//  Copyright © 2016 Chris David. All rights reserved.
//

import Foundation




// Protocols

protocol EventQuizType {
    var eventList: [EventType] { get }
    var eventRound: [EventType] { get set }
    
    func getRandomEvent() -> EventType
    func resetRound()
}

protocol EventType  {
    var name: String { get }
    var url: String { get }
    var date: Date { get }
    
    func getName() -> String
    func getURL() -> String
    func getDate() -> Date
}

/*
protocol VendingMachineType {
    var selection: [VendingSelection] { get }
    var inventory: [VendingSelection: ItemType] { get set }
    var amountDeposited: Double { get set }
    
    init(inventory: [VendingSelection: ItemType])
    func vend(selection: VendingSelection, quantity: Double) throws
    func deposit(amount: Double)
    func itemForCurrentSelection(selection: VendingSelection) -> ItemType?
}

protocol ItemType {
    var price: Double { get }
    var quantity: Double { get set }
}
*/

// Error Types

enum EventError: Error {
    case InvalidResource
    case ConversionError
    case InvalidKey
}

/*
enum InventoryError: Error {
    case InvalidResource
    case ConversionError
    case InvalidKey
}
*/
/*
enum VendingMachineError: Error {
    case InvalidSelection
    case OutOfStock
    case InsufficientFunds(required: Double)
}
*/

// Helper Classes
class PlistConverter {
    class func dictionaryFromFile(resource: String, ofType type: String) throws -> [String : AnyObject] {
        
        guard let path = Bundle.main.path(forResource: resource, ofType: type) else {
            throw EventError.InvalidResource
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path), let castDictionary = dictionary as? [String: AnyObject] else {
            throw EventError.ConversionError
        }
        
        return castDictionary
    }
}

/*
class PlistConverter {
    class func dictionaryFromFile(resource: String, ofType type: String) throws -> [String : AnyObject] {
        
        guard let path = NSBundle.mainBundle().pathForResource(resource, ofType: type) else {
            throw InventoryError.InvalidResource
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path), let castDictionary = dictionary as? [String: AnyObject] else {
            throw InventoryError.ConversionError
        }
        
        return castDictionary
    }
    
}
*/

class EventUnarchiver {
    class func eventListFromDictionary(dictionary: [String: AnyObject]) throws -> [EventType] {
        
        var eventList: [EventType] = []
        
        for (key, value) in dictionary {
            if let eventDictionary = value as?  [String: AnyObject], let url = eventDictionary["url"] as? String, let date = eventDictionary["date"] as? Date {
                let name = key
                let event = Event(name: name, url: url, date: date)
                eventList.append(event)
                
            }
        }
        return eventList
    }
}

/*
class InventoryUnarchiver {
    class func vendingInventoryFromDictionary(dictionary: [String: AnyObject]) throws -> [VendingSelection: ItemType] {
        
        var inventory: [VendingSelection: ItemType] = [:]
        
        for (key, value) in dictionary {
            if let itemDict = value as?  [String: Double], let price = itemDict["price"], let quantity = itemDict["quantity"] {
                let item = VendingItem(price: price, quantity: quantity)
                guard let key = VendingSelection(rawValue: key) else {
                    throw InventoryError.InvalidKey
                }
                inventory.updateValue(item, forKey: key)
            }
        }
        return inventory
    }
}
*/
// Concrete Types

struct Event: EventType, Equatable {
    var name: String
    var url: String
    var date: Date
    
    init(name: String, url: String, date: Date) {
        self.name = name
        self.url = url
        self.date = date
    }
    
    func getName() -> String {
        return name
    }
    
    func getURL() -> String {
        return url
    }
    
    func getDate() -> Date {
        return date
    }
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return
            lhs.name == rhs.name &&
            lhs.url == rhs.url &&
            lhs.date == rhs.date
    }
    
}

class eventQuiz: EventQuizType {
    var eventList: [EventType]
    var eventRound: [EventType] = []
    
    init(eventList: [EventType]) {
        self.eventList = eventList
    }
    
    func getRandomEvent() -> Event {
        let randomEvent = eventList[Int(arc4random_uniform(UInt32(eventList.count)))]
        return randomEvent
    }
    
    func resetRound() {
        var eventsPerRound = 4
        var newEvent: Event
        // Reset eventRound
        eventRound = []
        
        // Populate eventRound with 4 new and unique events
        while eventsPerRound > 0 {
            repeat {
                newEvent = getRandomEvent()
            } while ( eventRound.contains { event in
                if newEvent == event {
                    return true
                } else {
                    return false
                }
            })
            
            eventRound.append(newEvent)
            eventsPerRound = eventsPerRound - 1
        }
    }
}


/*
enum VendingSelection: String {
    case Soda
    case DietSoda
    case Chips
    case Cookie
    case Sandwich
    case Wrap
    case CandyBar
    case PopTart
    case Water
    case FruitJuice
    case SportsDrink
    case Gum
    
    func icon() -> UIImage {
        if let image = UIImage(named: self.rawValue) {
            return image
        } else {
            return UIImage(named: "Default")!
        }
    }
}


struct VendingItem: ItemType {
    let price: Double
    var quantity: Double
}

class VendingMachine: VendingMachineType {
    
    let selection: [VendingSelection] = [.Soda, .DietSoda, .Chips, .Cookie, .Sandwich, .Wrap, .CandyBar, .PopTart, .Water, .FruitJuice, .SportsDrink, .Gum]
    var inventory: [VendingSelection: ItemType]
    var amountDeposited: Double = 10
    
    required init(inventory: [VendingSelection : ItemType]) {
        self.inventory = inventory
    }
    
    func vend(selection: VendingSelection, quantity: Double) throws {
        guard var item = inventory[selection] else {
            throw VendingMachineError.InvalidSelection
        }
        
        guard item.quantity > 0 else {
            throw VendingMachineError.OutOfStock
        }
        
        item.quantity -= quantity
        inventory.updateValue(item, forKey: selection)
        
        let totalPrice = item.price * quantity
        if amountDeposited >= totalPrice {
            amountDeposited -= totalPrice
        } else {
            let amountRequired = totalPrice - amountDeposited
            throw VendingMachineError.InsufficientFunds(required: amountRequired)
        }
    }
    
    func itemForCurrentSelection(selection: VendingSelection) -> ItemType? {
        return inventory[selection]
    }
    
    func deposit(amount: Double) {
        amountDeposited += amount
    }
    
}
*/
