//
//  ConcurrentFishingForSingleBoatOperation.swift
//  PondFishing
//
//  Created by Matthew Ferguson on 2/18/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD

final class ConcurrentFishingForSingleBoatOperation: Operation {
    
    var boatId: Int64 = 0
    var moveBoatToDocked: Bool = false
    var moveStoredCatchToMarket: Bool = false
    var castTheNetsAndFish: Bool = false
    var tempCapturedBoatCatch:Int64? = 0
    
    
    init( newBoatId:Int64) {
        self.boatId = newBoatId
        self.tempCapturedBoatCatch = Int64(0)
        super.init()
    }

    private func checkPondStockAboveMinimumLevel(count:Int64)->Bool {
        if count < 1000{
            return false
        } else {
            return true
        }
    }
    
    private func emptyTheNetsAndFillTheBoatStorage()->Void {
        
        let managedContext =  DataFlowFunnel.shared.getPersistentContainerRef().viewContext
        
        let fetchRequestForBoat: NSFetchRequest<Boat> = Boat.fetchRequest()
        
        // (Optional ) add predicate descriptors
        let predicate = NSPredicate(format: "boatId == %d", Int64(self.boatId) )
        fetchRequestForBoat.predicate = predicate
    
        // (Required) Add Sort Descriptors
        let sortBoatDescriptor = NSSortDescriptor(key: "boatId", ascending: true)
        fetchRequestForBoat.sortDescriptors = [sortBoatDescriptor]
        
        managedContext.performAndWait {
            do{
                let resultsArray = try fetchRequestForBoat.execute()
                if (resultsArray.count) == 1 {
                    let boat = resultsArray[0]
                    boat.boatstorage?.catchTotal = boat.boatstorage!.catchTotal + Int64(50)
                }
                try managedContext.save()
            } catch let error as NSError {
                print("Could not execute . \(error), \(error.userInfo)")
            }
        }
    }
    
    
    
    private func pullFromThePond()->Void {
        
        let managedContext =  DataFlowFunnel.shared.getPersistentContainerRef().viewContext
        
        let fetchRequestForPond: NSFetchRequest<Pond> = Pond.fetchRequest()
        
        // (Required) Add Sort Descriptors
        let sortPondDescriptor = NSSortDescriptor(key: "numberOfFish", ascending: true)
        fetchRequestForPond.sortDescriptors = [sortPondDescriptor]
        
        managedContext.performAndWait {
            do{
                let resultsArray = try fetchRequestForPond.execute()
                if (resultsArray.count) == 1 {
                    let pond = resultsArray[0]
                    pond.numberOfFish = pond.numberOfFish - 50
                }
                try managedContext.save()
            } catch let error as NSError {
                print("Could not execute . \(error), \(error.userInfo)")
            }
        }
        
    }
    
    
    
    
    private func dockTheBoat()->Void {
        
        let managedContext =  DataFlowFunnel.shared.getPersistentContainerRef().viewContext
        
        let fetchRequestForSpecificBoatRecords: NSFetchRequest<Boat> = Boat.fetchRequest()
        
        // (Optional ) add predicate descriptors
        let predicate = NSPredicate(format: "boatId == %d", Int64(self.boatId) )
        fetchRequestForSpecificBoatRecords.predicate = predicate
    
        // (Required) Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "boatId", ascending: true)
        fetchRequestForSpecificBoatRecords.sortDescriptors = [sortDescriptor]
        
        managedContext.performAndWait {
            do{
                
                let resultsArray = try fetchRequestForSpecificBoatRecords.execute()
                if (resultsArray.count) == 1 {
                    let targetboat = resultsArray[0]
                    targetboat.state = BoatState.docked.rawValue
                    try managedContext.save()
                }
            } catch let error as NSError {
                print("Could not execute . \(error), \(error.userInfo)")
                return //return out of this operation
            }
        }
    }
    
    
    private func boatStorageToMarket()->Void {
      
        
        let managedContext =  DataFlowFunnel.shared.getPersistentContainerRef().viewContext
        
        let fetchRequestForSpecificBoatRecords: NSFetchRequest<Boat> = Boat.fetchRequest()
        
        // (Optional ) add predicate descriptors
        let predicate = NSPredicate(format: "boatId == %d", Int64(self.boatId) )
        fetchRequestForSpecificBoatRecords.predicate = predicate
    
        // (Required) Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "boatId", ascending: true)
        fetchRequestForSpecificBoatRecords.sortDescriptors = [sortDescriptor]
        
        managedContext.performAndWait {
            do{
                    let resultsArray = try fetchRequestForSpecificBoatRecords.execute()
                    for myBoat in resultsArray {
                        self.tempCapturedBoatCatch = myBoat.boatstorage?.catchTotal ?? Int64(0)
                        myBoat.boatstorage?.catchTotal = Int64(0)
                        try managedContext.save()
                    }
                   
            } catch let error as NSError {
                print("Could not execute . \(error), \(error.userInfo)")
                //return //return out of this operation
            }
        }
    
       // now move this boatid catch into the fish market
        
        let fetchRequestForFishMarketRecords: NSFetchRequest<FishMarket> = FishMarket.fetchRequest()
        
        // (Required) Add Sort Descriptors
        let sortDescriptorFishMarket = NSSortDescriptor(key: "numberOfFish", ascending: true)
        fetchRequestForFishMarketRecords.sortDescriptors = [sortDescriptorFishMarket]
        
        managedContext.performAndWait {
            do{
                    let resultsArray = try fetchRequestForFishMarketRecords.execute()
                    for myFishMarket in resultsArray {
                        myFishMarket.numberOfFish = myFishMarket.numberOfFish + self.tempCapturedBoatCatch!
                    }
                    try managedContext.save()
            } catch let error as NSError {
                print("Could not execute . \(error), \(error.userInfo)")
                //return //return out of this operation
            }
        }
    }
    
    
    private func pondAndBoatMaintenance()->Void {
        
        let managedContext =  DataFlowFunnel.shared.getPersistentContainerRef().viewContext
        let fetchRequestForPond: NSFetchRequest<Pond> = Pond.fetchRequest()
        
        // (Required) Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "numberOfFish", ascending: true)
        fetchRequestForPond.sortDescriptors = [sortDescriptor]
        
        managedContext.performAndWait {
            do{
                
                let resultsArray = try fetchRequestForPond.execute()
                if (resultsArray.count) == 1 {
                    
                    let currentFishStock = resultsArray[0].numberOfFish
                    
                    if self.checkPondStockAboveMinimumLevel(count: currentFishStock) {
                        // we have enough fish in the pond
                        self.moveBoatToDocked = false
                        self.moveStoredCatchToMarket = false
                        self.castTheNetsAndFish = true
                        
                    } else {
                        
                        self.moveBoatToDocked = true
                        self.moveStoredCatchToMarket = true
                        self.castTheNetsAndFish = false
                        
                    }
                } else {
                    /// pond error, should have at least one row/record
                    /// therefore gracefully flow over the other business logic
                    self.moveBoatToDocked = false
                    self.moveStoredCatchToMarket = false
                    self.castTheNetsAndFish = false
                
                }
            } catch let error as NSError {
                print("ConcurrentFishingForSingleBoatOperation:pondAndBoatMaintenance Could not execute managedContext. \(error), \(error.userInfo)")
            }
        }
    }
    
    override func main()
    {
        guard !isCancelled else { return }
        self.pondAndBoatMaintenance()
        
        // ****************************************
        // if we need to empty the boatid of catch and load the catch into the market we start that process
        // here.
        // ****************************************
        if (self.moveStoredCatchToMarket) {
            self.boatStorageToMarket()
        }

        // ***********************************
        // Now that the boatId has been empty of fish stock, moved to market, we need to dock this boat
        // until it can be commanded back out to a fishing state.
        // when this block is run , boat is updated through Core Data to .docked, and then this operation is cancelled
        // ***********************************
        if (self.moveBoatToDocked){
            self.dockTheBoat()
        }
    
        // ***********************************
        // if the pond has fish and boat has not been processed for the docking state, then
        // we need to continue to fish 50 at a time from the pond (cast our nets) and load the
        // boatId with the fish count removed from the pond.
        // ***********************************
        if (self.castTheNetsAndFish) {
            self.pullFromThePond()
            self.emptyTheNetsAndFillTheBoatStorage()
        }
    }
    
}
