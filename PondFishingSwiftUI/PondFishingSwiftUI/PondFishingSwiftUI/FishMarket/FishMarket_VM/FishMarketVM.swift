//
//  FishMarketVM.swift
//  PondFishingSwiftUI
//
//  Created by Matthew Ferguson on 10/13/23.
//

import Foundation
import UIKit
import CoreData
import DataFlowFunnelCD

extension FishMarketView
{
    @MainActor class FishMarketVM: NSObject, ObservableObject, NSFetchedResultsControllerDelegate
    {
        @Published var fishCount:String = String()
        
        fileprivate lazy var fetchMarketRequestController: NSFetchedResultsController<FishMarket> = {
            
            let fetchMarketNumberOfFish: NSFetchRequest<FishMarket> = FishMarket.fetchRequest()
            
            let sortDescriptor = NSSortDescriptor(key: "numberOfFish", ascending:false)
            fetchMarketNumberOfFish.sortDescriptors = [sortDescriptor]
            
            //Initialize Fetched Results Controller
            let fetchMarketResultsController = NSFetchedResultsController(
                fetchRequest: fetchMarketNumberOfFish ,
                managedObjectContext: DataFlowFunnel.shared.getPersistentContainerRef().viewContext ,
                sectionNameKeyPath: nil,
                cacheName: nil )
            
            fetchMarketResultsController.delegate = self
            
            return fetchMarketResultsController
            
        }()
        
        
        func setupFetchControllers() {
            do{
                self.fishCount = String("0")
                try self.fetchMarketRequestController.performFetch()
                if let fishMarketObjects = self.fetchMarketRequestController.fetchedObjects {
                    if let fishInMarketRecord = fishMarketObjects.first {
                        self.fishCount = String(describing: fishInMarketRecord.numberOfFish)
                    }
                }
            } catch {
                // error popup?
                let fetchError = error as NSError
                print("PondVC Unable to Perform Fetch Request: \(fetchError), \(fetchError.localizedDescription)")
            }
        }
        
        func updateMarketView(withCount updateCount: Int64) {
            self.fishCount = String(describing: updateCount)
        }

        //MARK: - NSFetchedResultsControllerDelegate
        
        nonisolated func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            //print("FishMarketVM:controllerWillChangeContent")
        }
        
        nonisolated public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            //this area can be used to update UI
            // print("FishMarketVM:controllerDidChangeContent")
        }

        nonisolated public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
        {
            switch (type) {
            case .insert:
                switch anObject {
                case let insertedFishMarketRecord as FishMarket:
                    do {
                        Task {
                            await self.updateMarketView(withCount: insertedFishMarketRecord.numberOfFish)
                        }
                    }
                    break
                default:
                    break
                }
                break //.insert
                
            case .update:
                switch anObject {
                case let updatedFishMarketRecord as FishMarket:
                    do {
                        Task {
                            await self.updateMarketView(withCount: updatedFishMarketRecord.numberOfFish)
                        }
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
