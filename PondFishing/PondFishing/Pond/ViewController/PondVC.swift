//
//  PondVC.swift
//  PondFishing
//
//  Created by Matthew Ferguson on 2/11/21.
//  Updated Jul 27, 2021


import UIKit
import Foundation
import CoreData
import DataFlowFunnelCD

class PondVC: UIViewController {
    
    
    @IBOutlet weak var labelTitleAvail: UILabel!
    @IBOutlet weak var labelAvailableInPond: UILabel!
    @IBOutlet weak var buttonReloadPond: UIButton!
    @IBOutlet weak var buttonResetPond: UIButton!
    
    
    //MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        self.uiSetupAndInit()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let delay = DispatchTime.now() + .milliseconds(0)
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.loadModelData()
            self.setupFetchControllers()
        }
        
    }
   
    
    //Mark: Initialization
    
    private func uiSetupAndInit()
    {
        labelTitleAvail.text = "Fish Available in Pond"
        labelAvailableInPond.text = " "
        
        buttonReloadPond.layer.borderWidth = 4.0
        buttonReloadPond.layer.borderColor = UIColor.black.cgColor
        buttonReloadPond.layer.cornerRadius = 8.0
        buttonReloadPond.clipsToBounds = true
        
        buttonResetPond.layer.borderWidth = 4.0
        buttonResetPond.layer.borderColor = UIColor.black.cgColor
        buttonResetPond.layer.cornerRadius = 8.0
        buttonResetPond.clipsToBounds = true
    }

    
    private func setupFetchControllers() {
        do {
             try self.fetchAllPondRecordsRequestController.performFetch()
        } catch {
            // error popup?
            let fetchError = error as NSError
            print("PondVCUnable to Perform Fetch Request: \(fetchError), \(fetchError.localizedDescription)")
        }
    }


    private func loadModelData() {
        
        ///place on the funnel queue
        let coreDataFunnelOperation = BlockOperation {
            let moc = DataFlowFunnel.shared.getPersistentContainerRef().viewContext
            let fetchRequestPond = NSFetchRequest<Pond>(entityName: "Pond")
            moc.performAndWait {
                do{
                    let pond = try moc.fetch(fetchRequestPond)
                    if pond.count > 0 {
                        let availFish = pond[0].numberOfFish
                        self.labelAvailableInPond.text = String(describing: availFish)
                    }
                }catch let error as NSError {
                    print("Failed to execute AppDelegate::removeUserData. \(error), \(error.userInfo)")
                }
            }
        }
        DataFlowFunnel.shared.addOperation(coreDataFunnelOperation) //add to funnel FIFO
    }


    @IBAction func reloadPond() {
        
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
    

    @IBAction func resetPond() {
        
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

    
}


