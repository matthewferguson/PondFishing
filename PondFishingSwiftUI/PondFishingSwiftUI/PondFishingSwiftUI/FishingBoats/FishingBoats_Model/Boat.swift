//
//  Boat.swift
//  PondFishingSwiftUI
//
//  Created by Matthew Ferguson on 5/18/23.

import Foundation


//struct BoatNode {
//    let boatId: String
//    let boatStorage: String
//    let state: BoatState
//}



struct FishingBoat: Identifiable {
    var id = UUID()
    var boatId: String
    var boatName: String
    var docked: BoatState
    var fishStored: Int64
}

//type Int64 for use with Core Data
enum BoatState: Int64 {
    case docked  = 1,
         fishing = 2
}
