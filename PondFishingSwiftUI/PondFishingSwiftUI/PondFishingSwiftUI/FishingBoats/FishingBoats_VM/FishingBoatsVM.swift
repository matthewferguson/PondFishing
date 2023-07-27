//
//  FishingBoatsVM.swift
//  PondFishingSwiftUI
//
//  Created by Matthew Ferguson on 5/25/23.
//

import Foundation
import UIKit
import CoreData
import DataFlowFunnelCD



protocol FishingBoatsViewModelDelegate: NSObject {
    func reloadTableViewFromViewModel()
}



public class FishingBoatsVM: NSObject {

    //
    weak var delegate: FishingBoatsViewModelDelegate?
    var managedBoats: [FishingBoat] = []

    fileprivate lazy var fetchBoatsRequestController: NSFetchedResultsController<Boat> = {
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
    
    
    
    override init() {
        super.init()
        managedBoats = []
        self.setupFetchControllers()
    }


    
    private func setupFetchControllers() {
        do {
            try self.fetchBoatsRequestController.performFetch()
            let boats = self.fetchBoatsRequestController.fetchedObjects!
            for (singleBoat) in boats {
                
                if let managedBoat = managedBoats.first(where: { Int64($0.boatId) == singleBoat.boatId }){
                    let bs = singleBoat.boatstorage! as BoatCatchStorage
                    let insertedBoat = FishingBoat(boatId: managedBoat.boatId , boatName: String(describing: managedBoat.boatId), docked: BoatState(rawValue: managedBoat.docked.rawValue)!, fishStored: managedBoat.fishStored)

//                    let insertedBoat = FishingBoat(boatId: String(describing: managedBoat.boatId),
//                                                boatStorage: String(describing: bs.catchTotal),
//                                                state: BoatState(rawValue: managedBoat.state.rawValue)!)
                    //self.managedBoats[Int(managedBoat.boatId)!] = insertedBoat
                    
                    //self.delegate?.reloadTableViewFromViewModel()
                }

            }
        } catch {
            // error popup?
            let fetchError = error as NSError
            print("PondVCUnable to Perform Fetch Request: \(fetchError), \(fetchError.localizedDescription)")
        }
        
        do {
            try self.fetchBoatStorageRequestController.performFetch()
            let boatsStorage = self.fetchBoatStorageRequestController.fetchedObjects!
            for (singleStorage) in boatsStorage {
                
                let boat = singleStorage.associatedBoat
                if let managedBoat = managedBoats.first(where: { Int64($0.boatId) == boat?.boatId }){
                    
                    //let bs = b.boatstorage! as BoatCatchStorage
                    
                    let insertedBoat = FishingBoat( boatId:String(describing: managedBoat.boatId),
                                                    boatName: String(describing: managedBoat.boatId),
                                                    docked: BoatState(rawValue:managedBoat.docked.rawValue)!,
                                                    fishStored: managedBoat.fishStored)
                    
                    self.managedBoats[Int(managedBoat.boatId)!] = insertedBoat
                    self.delegate?.reloadTableViewFromViewModel()
                }
                
            }
        } catch {
            // error popup?
            let fetchError = error as NSError
            print("PondVCUnable to Perform Fetch Request: \(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    
    func toggleBoatState(at index: Int64) {
        
        let toggleFishingBoatStateOperation = ToggleFishingBoatStateOperation(newBoatId: Int64(index))
        DataFlowFunnel.shared.addOperation(toggleFishingBoatStateOperation)
        DataFlowFunnel.shared.addOperation(FetchAndDescribeDataOperation())
        
    }
    
    
    func updateBoatsView(withBoatNode updatedBoat: FishingBoat) {
        
        if let managedBoat = managedBoats.first(where: { $0.boatId == updatedBoat.boatId }) {
            self.managedBoats[Int(managedBoat.boatId)!] = updatedBoat
        }
        self.delegate?.reloadTableViewFromViewModel()
    }
    
    func addNewBoat() {
        if managedBoats.count < 9 {
            let candidateID = managedBoats.count
            let addNewBoatOperation = AddFishingBoatOperation(newBoatId: Int64(candidateID))
            DataFlowFunnel.shared.addOperation(addNewBoatOperation)
            //let describeCurrentData = FetchAndDescribeDataOperation()
            //DataFlowFunnel.shared.addOperation(describeCurrentData)
        }
    }
    
    
    func installNewBoatView(withMOC newboat: Boat) {
        
        var stagedNewBoat = FishingBoat(boatId: String(describing: newboat.boatId), boatName: String(describing: newboat.boatId), docked: BoatState(rawValue: newboat.state)!, fishStored: 0)
        
//        var stagedNewBoat = FishingBoat(boatId: String(describing: newboat.boatId), boatStorage: "0", state: BoatState(rawValue: newboat.state)!)
        
        if let bs = newboat.boatstorage {
            
            stagedNewBoat = FishingBoat(boatId: String(describing: newboat.boatId), boatName: String(describing: newboat.boatId), docked: BoatState(rawValue: newboat.state)!, fishStored: bs.catchTotal)
            
            
            //            stagedNewBoat = FishingBoat(boatId: String(describing: newboat.boatId), boatName: String(describing: newboat.boatId), boatStorage: String(describing: bs.catchTotal), state: BoatState(rawValue: newboat.state)!, docked: BoatState(rawValue: newboat.state)! )
        }
        
        //self.managedBoats.append(<#T##newElement: Boat##Boat#>)
        
        self.managedBoats.append(stagedNewBoat)
        self.managedBoats = self.managedBoats.sorted (by: {$0.boatId < $1.boatId})
        self.delegate?.reloadTableViewFromViewModel()
    }
    
    func rtnManagedBoatsCount()->Int {
        return (self.managedBoats.count)
    }
    
    func rtnBoatNode(at index:Int)->FishingBoat {
        return self.managedBoats[index]
    }
    
}
