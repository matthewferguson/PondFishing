//
//  FishingBoatDemarcation.swift
//  PondFishing
//
//  Created by Matthew Ferguson on 2/15/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD

struct ActiveFishingBoat {
    var boatId:Int64
}

class FishingBoatDemarcation : NSObject {
    
    var isRunningOperations:Bool = false
    var monitoredOperations:[ActiveFishingBoat] = []

    fileprivate lazy var fetchAllUsersRequestController: NSFetchedResultsController<Boat> = {
         let fetchRequestForUsers: NSFetchRequest<Boat> = Boat.fetchRequest()
        
         let sortDescriptor = NSSortDescriptor(key: "boatId", ascending:false)
         fetchRequestForUsers.sortDescriptors = [sortDescriptor]
        
         //Initialize Fetched Results Controller
         let fetchAllUsersRecordRequest = NSFetchedResultsController(
             fetchRequest: fetchRequestForUsers,
             managedObjectContext:DataFlowFunnel.shared.getPersistentContainerRef().viewContext,
             sectionNameKeyPath: nil,
             cacheName: nil)

         fetchAllUsersRecordRequest.delegate = self
         return fetchAllUsersRecordRequest
     }()
    
    
    
    fileprivate lazy var fetchBoatStorageRequestController: NSFetchedResultsController<BoatCatchStorage> = {
         let fetchRequestForBoatStorage: NSFetchRequest<BoatCatchStorage> = BoatCatchStorage.fetchRequest()
        
         let sortDescriptor = NSSortDescriptor(key: "catchTotal", ascending:false)
        fetchRequestForBoatStorage.sortDescriptors = [sortDescriptor]
        
         //Initialize Fetched Results Controller
         let fetchBoatStorageRecordRequest = NSFetchedResultsController(
             fetchRequest: fetchRequestForBoatStorage,
             managedObjectContext:DataFlowFunnel.shared.getPersistentContainerRef().viewContext,
             sectionNameKeyPath: nil,
             cacheName: nil)

        fetchBoatStorageRecordRequest.delegate = self
         return fetchBoatStorageRecordRequest
    }()
    
    override init(){
        super.init()
        monitoredOperations = []
        self.setupFetchControllersDemarc()
    }
    
    private func setupFetchControllersDemarc() {
        do {
             try self.fetchAllUsersRequestController.performFetch()
        } catch {
            // error popup?
            let fetchError = error as NSError
            print("FishingBoatDemarcation Unable to Perform Fetch Request: \(fetchError), \(fetchError.localizedDescription)")
        }
        
        do {
             try self.fetchBoatStorageRequestController.performFetch()
        } catch {
            // error popup?
            let fetchError = error as NSError
            print("FishingBoatDemarcation Unable to Perform Fetch Request: \(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    public func runBoatOperations() {
        var isRunning:Bool = true
        var tempArray:[ActiveFishingBoat] = []
        while(isRunning) {
            tempArray = Array(monitoredOperations)
            if tempArray.count > 0 {
                for (activeboat) in tempArray {
                    let boatid = activeboat.boatId
                    let activefishingOperation = ConcurrentFishingForSingleBoatOperation(newBoatId: boatid)
                    let delay = DispatchTime.now() + .milliseconds(0)
                    DispatchQueue.global().asyncAfter(deadline: delay) {
                        DataFlowFunnel.shared.addOperation(activefishingOperation)
                    }
                }
                
            } else {
                isRunning = false
            }
            DataFlowFunnel.shared.waitUntilAllOperationsAreFinished()
            // sleep for 200 milliseconds
            Thread.sleep(forTimeInterval: Double(0.2))
        }
    }

    func startAFishingOperations(with boatId: Int64) {
        
        let activeBoat = ActiveFishingBoat(boatId: boatId)
        if let locationIndex = monitoredOperations.firstIndex(where: { $0.boatId == boatId } ) {
            _ = locationIndex // at some point this is needed for maintenance of boats that exists
        } else {
            monitoredOperations.append(activeBoat)
            if monitoredOperations.count == 1{
                self.runBoatOperations()
            }
        }
    }
    
    func cancelAFishingOperation(with boatId: Int64) {
        if let locationIndex = monitoredOperations.firstIndex(where: { $0.boatId == boatId } ) {
            monitoredOperations.remove(at: locationIndex)
        }
    }
    
}
