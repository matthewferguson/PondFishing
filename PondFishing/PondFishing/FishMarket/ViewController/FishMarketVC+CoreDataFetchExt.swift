//
//  FishMarketVC+CoreDataFetchExt.swift
//  PondFishing
//
//  Created by Matthew Ferguson on 2/21/21.
//

import Foundation
import UIKit
import CoreData
import DataFlowFunnelCD

extension FishMarketVC: NSFetchedResultsControllerDelegate
{
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("FishMarketVC: fetch controllerWillChangeContent")
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
       //print("FishMarketVC: fetch controllerDidChangeContent")
    }
    
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch (type) {
            case .insert:
                switch anObject {
                    case let insertedFishMarketRecord as FishMarket:
                        //print("FishMarketVC:insert:\(insertedFishMarketRecord)")
                        self.labelNumberSold.text = String(describing: insertedFishMarketRecord.numberOfFish)
                    break
                    default:
                    break
                }
            break //.insert
        
            case .update:
                switch anObject {
                    case let updatedFishMarketRecord as FishMarket:
                        //print("FishMarketVC:update:\(updatedFishMarketRecord)")
                        self.labelNumberSold.text = String(describing: updatedFishMarketRecord.numberOfFish)
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

