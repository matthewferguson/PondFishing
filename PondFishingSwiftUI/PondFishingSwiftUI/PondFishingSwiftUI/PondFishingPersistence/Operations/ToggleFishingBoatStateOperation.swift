//
//  ToggleFishingBoatStateOperation.swift
//  PondFishing
//
//  Created by Matthew Ferguson on 2/17/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD

final class ToggleFishingBoatStateOperation: Operation {
    
    var boatId: Int64 = 0
    
    init( newBoatId:Int64) {
        self.boatId = newBoatId
        super.init()
    }

    override func main() {
        
        guard !isCancelled else { return }

        let managedContext =  DataFlowFunnel.shared.getPersistentContainerRef().viewContext
       
        let fetchRequestForSpecificBoatRecords: NSFetchRequest<Boat> = Boat.fetchRequest()
        
        // (Optional ) add predicate descriptors
        let predicate = NSPredicate(format: "boatId == %ld", self.boatId )
        fetchRequestForSpecificBoatRecords.predicate = predicate
    
        // (Required) Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "boatId", ascending: true)
        fetchRequestForSpecificBoatRecords.sortDescriptors = [sortDescriptor]
        
        managedContext.performAndWait {
            do{
                let resultsArray = try fetchRequestForSpecificBoatRecords.execute()
                for myBoat in resultsArray {
                    let boatState = myBoat.state
                    switch boatState {
                        case BoatState.docked.rawValue:
                            myBoat.state = BoatState.fishing.rawValue
                        break
                        case BoatState.fishing.rawValue:
                            myBoat.state = BoatState.docked.rawValue
                        break
                        default:
                        break
                    }
                    try managedContext.save()
                }
            } catch let error as NSError {
                print("Could not execute . \(error), \(error.userInfo)")
            }
        }
    }
    
    
}
