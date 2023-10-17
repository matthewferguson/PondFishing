//
//  PondVC+CoreDataFetchExtension.swift
//  PondFishing
//
//  Created by Matthew Ferguson on 2/11/21.
//

import Foundation
import UIKit
import CoreData
import DataFlowFunnelCD

extension PondVC: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("PondVC:controllerWillChangeContent")
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //this area can be used to update UI
       // print("PondVC:controllerDidChangeContent")
    }
    
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch (type) {
            case .insert:
                switch anObject {
                    case let tempPond as Pond:
                        DispatchQueue.main.async {
                            self.labelAvailableInPond.text = String(describing: tempPond.numberOfFish)
                        }
                    break
                    default:
                    break
                }
            break //.insert
        
            case .update:
                switch anObject {
                    case let tempPond as Pond:
                        DispatchQueue.main.async {
                            self.labelAvailableInPond.text = String(describing: tempPond.numberOfFish)
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

