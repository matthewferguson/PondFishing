//
//  FishingBoatsViewModel+CoreDataFetchExt.swift
//  PondFishing
//
//  Created by Matthew Ferguson on 2/14/21.
//

import Foundation
import UIKit
import CoreData
import DataFlowFunnelCD

extension FishingBoatsViewModel: NSFetchedResultsControllerDelegate
{
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("FishingBoatsViewModel: fetch controllerWillChangeContent")
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       // print("FishingBoatsViewModel: fetch controllerDidChangeContent")
    }
    
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch (type) {
            case .insert:
                switch anObject {
                
                    case let insertedBoat as Boat:
                        switch insertedBoat.state {
                        case BoatState.docked.rawValue:
                                self.installNewBoatView(withMOC: insertedBoat)
                            break
                        case BoatState.fishing.rawValue:
                                self.installNewBoatView(withMOC: insertedBoat)
                            break
                            default:
                            break
                        }
                    break
                    
                    default:
                    break
                }
            break //.insert
        
            case .update:
                
                switch anObject {
                    case let updatedBoat as Boat:
                        guard let boatStorageNum = updatedBoat.boatstorage?.catchTotal else {
                            print("optional processing error")
                            return
                        }
                        
                        let stringBoatId = String(updatedBoat.boatId)
                        
                        let stringBoatStoreNum = String(boatStorageNum)
                        
                        let boatnode = BoatNode(boatId: stringBoatId,
                                                boatStorage: stringBoatStoreNum,
                                                state: BoatState(rawValue: updatedBoat.state)! )
                    
                        self.updateBoatsView(withBoatNode: boatnode)
   
                    case let updatedBoatStorage as BoatCatchStorage:

                        if nil != updatedBoatStorage.associatedBoat {
                    
                            guard let singleboat = updatedBoatStorage.associatedBoat else {
                                print("optional processing error")
                                return
                            }
                            
                            let boatStorageNum = updatedBoatStorage.catchTotal
                            let tempboatid = singleboat.boatId
                            let tempboatState = singleboat.state
                            let boatnode = BoatNode(boatId: String(tempboatid),
                                                        boatStorage: String(boatStorageNum),
                                                        state: BoatState(rawValue: tempboatState)! )
                            self.updateBoatsView(withBoatNode: boatnode)
                        }
                
                    break
                    default:
                    break
                }
            break //.update
        case .delete: break
        case .move: break
        @unknown default:
                fatalError()
        }
    }
}

