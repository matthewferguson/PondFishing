//
//  CastNetsOperation.swift
//  PondFishing
//
//  Created by Matthew Ferguson on 2/19/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD


// FUTURE DEVELOPMENT - building a background OperationQueue with Priorities on Operations.
//  this is part of that future R&D. 

final class CastNetsOperation: Operation {
    
    var boatId: Int64 = 0
    
    init( newBoatId:Int64) {
        super.init()
    }

    override func main() {
        guard !isCancelled else { return }
        print("CastNetsOperation")
    }
}
