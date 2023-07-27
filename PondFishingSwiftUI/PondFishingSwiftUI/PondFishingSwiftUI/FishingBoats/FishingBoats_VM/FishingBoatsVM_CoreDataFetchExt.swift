//
//  FishingBoatsVM_CoreDataFetchExt.swift
//  PondFishingSwiftUI
//
//  Created by Matthew Ferguson on 5/25/23.
//

import Foundation
import UIKit
import CoreData
import DataFlowFunnelCD

extension FishingBoatsVM: NSFetchedResultsControllerDelegate
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
                        
                    
                        // BUZ remove?
                        let stringBoatStoreNum = String(boatStorageNum)
                        
                        let boatnode = FishingBoat(boatId: stringBoatId, boatName: stringBoatId, docked: BoatState(rawValue: updatedBoat.state)!, fishStored: boatStorageNum)
                    
                    
//  BUZ                  let boatnode = FishingBoat(boatName: <#T##String#>, docked: BoatState(rawValue: updatedBoat.state)!, fishStored: boatStorageNum)
//
                    
                    
                    
                    
//   BUZ                     let boatnode = FishingBoat(boatId: stringBoatId,
//                                                boatStorage: stringBoatStoreNum,
//                                                state: BoatState(rawValue: updatedBoat.state)! )
                    
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
                            
                            
//                            let boatnode = FishingBoat(id: boatName: <#T##String#>, docked: BoatState(rawValue: updatedBoat.state)!, fishStored: boatStorageNum)
//
//
                            
                            
                            
                            
                            let boat = FishingBoat(boatId: String(describing: tempboatid),
                                                   boatName: String(describing: tempboatid),
                                                   docked: BoatState(rawValue: tempboatState)!,
                                                   fishStored: boatStorageNum)
                            
                            
                            
//                            let boatnode = FishingBoat(boatId: String(tempboatid),
//                                                       boatStorage: String(boatStorageNum),
//                                                       state: BoatState(rawValue: tempboatState)! )
                                                    
                            self.updateBoatsView(withBoatNode: boat)
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

