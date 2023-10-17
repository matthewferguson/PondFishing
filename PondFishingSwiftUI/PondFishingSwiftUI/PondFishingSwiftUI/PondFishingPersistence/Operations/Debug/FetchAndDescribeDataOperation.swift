//
//  FetchAndDescribeData.swift
//  PondFishing
//
//  Created by Matthew Ferguson on 2/17/21.
//

import Foundation
import CoreData
import DataFlowFunnelCD

final class FetchAndDescribeDataOperation: Operation {
    
    var boatId: Int64 = 0
    
    override init() {
        super.init()
    }

    override func main() {
        
        guard !isCancelled else { return }

        let managedContext =  DataFlowFunnel.shared.getPersistentContainerRef().viewContext
        
        print("Framework Context PersistentContainer viewContext ConcurrencyType: ")
        switch (managedContext.concurrencyType){
            case .mainQueueConcurrencyType:
                print("         .mainQueueConcurrencyType")
            case .privateQueueConcurrencyType:
                print("         .privateQueueConcurrencyType")
            case .confinementConcurrencyType:
                print("         .confinementConcurrencyType")
            @unknown default:
                fatalError()
        }
        
        let managedContext1 =  DataFlowFunnel.shared.getPersistentContainerRef().viewContext
        let fetchRequest = NSFetchRequest<Boat>(entityName: "Boat")
        managedContext1.performAndWait {
            do{
                print("Framework description call all Boats description")
                let boats = try managedContext1.fetch(fetchRequest)
                for (index, singleBoat) in boats.enumerated()
                {
                    print("------- Single Boat ----------")
                    print("Boat at location index == \(index):")
                    print("     singleBoat.boatId == \(singleBoat.boatId)" )
                    switch singleBoat.state {
                        case BoatState.docked.rawValue:
                            print("     singleBoat.state  == .docked")
                        break
                        case BoatState.fishing.rawValue:
                            print("     singleBoat.state  == .fishing")
                        break
                        default:
                        break
                    }
                    if let storedFish = (singleBoat.boatstorage) {
                        let numberOfFish = storedFish.catchTotal
                        print("     number of fish in this boat = \(numberOfFish)")
                    }
                    else {
                        print("     number of fish in this boat = \(0)")
                    }
                    print("----------------------")
                }
            }catch let error as NSError {
                print("Failed to execute AppDelegate::removeUserData. \(error), \(error.userInfo)")
            }
        }
        
        let fetchRequestPond = NSFetchRequest<Pond>(entityName: "Pond")
        managedContext.performAndWait {
            do{
                print("Framework description call on Pond entity")
                let pond = try managedContext.fetch(fetchRequestPond)
                for (index, pondRecord) in pond.enumerated()
                {
                    print("     ---------- POND ------------")
                    print("     Pond at location index == \(index):")
                    print("         NumberOfFish in Pond = \(String(describing: pondRecord.numberOfFish ))")
                    print("     ----------------------")
                }
            }catch let error as NSError {
                print("Failed to execute AppDelegate::removeUserData. \(error), \(error.userInfo)")
            }
        }
        
        let fetchRequestFishMarket = NSFetchRequest<FishMarket>(entityName: "FishMarket")
        managedContext.performAndWait {
            do{
                print("Framework description call on FishMarket entity")
                let market = try managedContext.fetch(fetchRequestFishMarket)
                for (index, marketRecord) in market.enumerated()
                {
                    print("     ---------- FishMarket ------------")
                    print("     FishMarket at location index == \(index):")
                    print("         NumberOfFish at Fish Market = \(String(describing: marketRecord.numberOfFish ))")
                    print("     ----------------------")
                }
            }catch let error as NSError {
                print("Failed to execute AppDelegate::removeUserData. \(error), \(error.userInfo)")
            }
        }
        
    }
    
    
}
