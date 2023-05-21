//
//  Boat.swift
//  PondFishingSwiftUI
//
//  Created by Matthew Ferguson on 5/18/23.
//

import Foundation

struct Boat: Identifiable {
    var id = UUID()
    var boatName: String
    var docked: BoatState
    var fishStored: Int64
}

//type Int64 for use with Core Data
enum BoatState: Int64 {
    case docked  = 1,
    fishing
}
