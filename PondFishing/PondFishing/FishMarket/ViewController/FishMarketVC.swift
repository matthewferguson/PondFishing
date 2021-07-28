//
//  FishMarketVC.swift
//  PondFishing
//
//  Created by Matthew Ferguson on 2/11/21.
//

import UIKit
import Foundation
import CoreData
import DataFlowFunnelCD

class FishMarketVC: UIViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelNumberSold: UILabel!

    var filteredNumber: [String] = []
    
    override func viewDidLoad() {
        self.labelNumberSold.text = "0"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupFetchControllers()
    }
    
    
    private func setupFetchControllers() {
        do{
            try self.fetchMarketRequestController.performFetch()
            let fishMarketObjects = self.fetchMarketRequestController.fetchedObjects!
            if fishMarketObjects.count == 1 {
                let fishInMarketRecord = fishMarketObjects[0]
                self.labelNumberSold.text = String(describing: fishInMarketRecord.numberOfFish)
            }
        } catch {
            // error popup?
            let fetchError = error as NSError
            print("PondVC Unable to Perform Fetch Request: \(fetchError), \(fetchError.localizedDescription)")
        }
    }
  
    
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
    
}
