//
//  FishingBoatDemarcation+CoreDataFetchExt.swift
//  PondFishing
//
//  Created by Matthew Ferguson on 2/15/21.
//

import Foundation
import UIKit
import CoreData
import DataFlowFunnelCD


extension FishingBoatDemarcation: NSFetchedResultsControllerDelegate
{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("controllerWillChangeContent")
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //this area can be used to update UI
       // print("controllerDidChangeContent")
    }
    
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                           didChange anObject: Any,
                           at indexPath: IndexPath?,
                           for type: NSFetchedResultsChangeType,
                           newIndexPath: IndexPath?) {
        
        switch (type)
        {
            // ****** INSERT *******
            case .insert:
                switch anObject {
                    case let insertedBoat as Boat:
                        switch insertedBoat.state {
                            case BoatState.docked.rawValue:
                                
                            break
                            case BoatState.fishing.rawValue:
                                
                            break
                            default:
                            break
                        }
                    break
                        
                    default:
                    break
                }
            break //break .insert
        
            // ****** UPDATE *******
            case .update:
                switch anObject
                {
                    case let updatedBoat as Boat:
                        switch updatedBoat.state {
                            case BoatState.docked.rawValue:
                                let delay = DispatchTime.now() + .seconds(0)
                                DispatchQueue.global().asyncAfter(deadline: delay) {
                                    self.cancelAFishingOperation(with: updatedBoat.boatId)
                                }
                            break
                            case BoatState.fishing.rawValue:
                                let delay = DispatchTime.now() + .milliseconds(0)
                                DispatchQueue.global().asyncAfter(deadline: delay) {
                                    self.startAFishingOperations(with: updatedBoat.boatId)
                                }
                            break
                            default:
                            break
                        }
                    break
                    default:
                    break
                }
            break //break .update
        
            // ****** DELETE *******
            case .delete:
                switch anObject {
                    case _ as Boat:
                    break
                    default:
                    break
                }
            break //.delete
        
            // ****** MOVE ********
            case .move: break
            @unknown default:
                fatalError()
        }// switch
    }
}

