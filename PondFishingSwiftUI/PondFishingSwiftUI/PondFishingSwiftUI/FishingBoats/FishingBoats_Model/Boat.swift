//
//  Boat.swift
//  PondFishingSwiftUI
//
//  Created by Matthew Ferguson on 5/18/23.

import Foundation


struct BoatNode: Identifiable{
    var id = UUID()
    var boatId: String
    var boatStorage: String
    var state: BoatState
}

//type Int64 for use with Core Data
enum BoatState: Int64 {
    case docked  = 1,
         fishing = 2
}
