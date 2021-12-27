//
//  Sorter.swift
//  LeCoreData
//
//  Created by bilal on 27/12/2021.
//

import Foundation


struct Sorter {
    
    
    func byAlphabetical(_ race: Race) -> [Animal] {
        if let animals = race.animals?.allObjects as? [Animal] {
            let sorted = animals.sorted(by: {$0.name! < $1.name!})
            return sorted
        } else {
            return []
        }
    }
    
}
