//
//  Game+CoreDataProperties.swift
//  tic-turing-toe
//
//  Created by Priyank Ahuja on 10/4/24.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var date: Date?
    @NSManaged public var mode: String?
    @NSManaged public var winner: String?

}

extension Game : Identifiable {

}
