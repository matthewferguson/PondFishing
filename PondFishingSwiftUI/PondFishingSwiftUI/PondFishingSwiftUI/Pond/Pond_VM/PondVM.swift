//
//  PondVM.swift
//  PondFishingSwiftUI
//
//  Created by Matthew Ferguson on 10/11/23.
//

import Foundation
import UIKit
import CoreData
import DataFlowFunnelCD

extension PondView
{
    @MainActor class PondVM: NSObject, ObservableObject, NSFetchedResultsControllerDelegate
    {
        @Published var fishCount:String = String()

        fileprivate lazy var fetchAllPondRecordsRequestController: NSFetchedResultsController<Pond> = {
             
             let fetchRequestForNumberOfFish: NSFetchRequest<Pond> = Pond.fetchRequest()
             
             let sortDescriptor = NSSortDescriptor(key: "numberOfFish", ascending:false)
            fetchRequestForNumberOfFish.sortDescriptors = [sortDescriptor]
             
             //Initialize Fetched Results Controller
             let fetchPondRecordRequest = NSFetchedResultsController(
                 fetchRequest: fetchRequestForNumberOfFish,
                 managedObjectContext:DataFlowFunnel.shared.getPersistentContainerRef().viewContext,
                 sectionNameKeyPath: nil,
                 cacheName: nil)

            fetchPondRecordRequest.delegate = self
            return fetchPondRecordRequest
         }()
        

        func setupFetchControllers() {
            do {
                try self.fetchAllPondRecordsRequestController.performFetch()
                let fetchedCount = self.fetchAllPondRecordsRequestController.fetchedObjects!
                if fetchedCount.count > 0 {
                    let availFish = fetchedCount[0].numberOfFish
                    self.fishCount = String(describing: availFish)
                }
            } catch {
                // error popup?
                let fetchError = error as NSError
                print("PondVCUnable to Perform Fetch Request: \(fetchError), \(fetchError.localizedDescription)")
            }
        }

       func reloadPond() {
            let coredataFunnelOperationAddPondValues = BlockOperation
            {
                let moc = DataFlowFunnel.shared.getPersistentContainerRef().viewContext
                let fetchRequestPond : NSFetchRequest<Pond> = Pond.fetchRequest()
                moc.performAndWait {
                    do{
                        let resultsArray:Array<Pond> = try fetchRequestPond.execute()
                        /// Are there any elements and if so add fish to the pond
                        if resultsArray.count > 0 {
                            let singleRecordInPond = resultsArray[0]
                            ///update this (mo) managed object on the exact field.
                            singleRecordInPond.numberOfFish = singleRecordInPond.numberOfFish + 10000
                        }
                        else {
                            // else build new pond moc.
                            let newPond = Pond(context: moc)
                            newPond.numberOfFish = 10000
                        }
                        try moc.save()
                    } catch let error as NSError {
                        print("Could not execute AppDelegate::fetchRequestPond. \(error), \(error.userInfo)")
                    }
                }
            }
            DataFlowFunnel.shared.addOperation(coredataFunnelOperationAddPondValues)
        }
        
        
        func resetPond() {
            
            let operationResetPondValues = BlockOperation
            {
                
                let moc = DataFlowFunnel.shared.getPersistentContainerRef().viewContext
                let fetchRequestPond : NSFetchRequest<Pond> = Pond.fetchRequest()
                moc.performAndWait {
                    do{
                        
                        let resultsArray:Array<Pond> = try fetchRequestPond.execute()
                        // checks for if it exists needed.
                        if resultsArray.count > 0 {
                            let singleRecordInPond = resultsArray[0]
                            singleRecordInPond.numberOfFish = 10000
                        }
                        else {
                            let newPond = Pond(context: moc)
                            newPond.numberOfFish = 10000
                        }
                        try moc.save()
                        
                    } catch let error as NSError {
                        print("Could not execute AppDelegate::fetchRequestPond. \(error), \(error.userInfo)")
                    }
                }
                
            }
            DataFlowFunnel.shared.addOperation(operationResetPondValues)
        }
        
        //MARK: - NSFetchedResultsControllerDelegate
        
        nonisolated func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            //print("PondVM:controllerWillChangeContent")
        }
        
        nonisolated public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            //this area can be used to update UI
           // print("PondVM:controllerDidChangeContent")
        }
        
        
        nonisolated public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
        {
            switch (type) {
                case .insert:
                    switch anObject {
                        case let tempPond as Pond:
                            DispatchQueue.main.async {
                                self.fishCount = String(describing: tempPond.numberOfFish)
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
                                self.fishCount = String(describing: tempPond.numberOfFish)
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
}
