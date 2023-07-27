//
//  AddFishingBoatOperation.swift
//  PondFishing
//
//  Created by Matthew Ferguson on 2/16/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD




final class AddFishingBoatOperation: Operation {
    
    var boatId: Int64 = 0
    
    init( newBoatId:Int64) {
        self.boatId = newBoatId
        super.init()
    }

    override func main() {
        
        guard !isCancelled else { return }


        let managedContext = DataFlowFunnel.shared.getPersistentContainerRef().viewContext

        let newBoat:Boat = Boat(context: managedContext)
        ///init properties
        newBoat.boatId = self.boatId
        newBoat.state = BoatState.docked.rawValue
        
        let newStorage = BoatCatchStorage(context: managedContext)
        newStorage.catchTotal = 0
        newBoat.boatstorage = newStorage
        newStorage.associatedBoat = newBoat
        
        managedContext.performAndWait
        {
            do{
                try managedContext.save()
            } catch let error as NSError {
                print("Error on saving the Boat MO in LoginUserDataOperation: == \(error),\(error.userInfo)")
            }
        }
        managedContext.reset()
    }
    
    
}
