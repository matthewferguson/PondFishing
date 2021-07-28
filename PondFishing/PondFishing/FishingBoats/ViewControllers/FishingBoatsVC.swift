//
//  FishingBoatVC.swift
//  PondFishing
//
//  Created by Matthew Ferguson on 2/11/21.
//
import UIKit
import Foundation

class FishingBoatsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FishingBoatsViewModelDelegate {
    
    private let viewModel = FishingBoatsViewModel()

    static let CELL_REUSE_ID = "FishingBoatCell_ID"
    
    @IBOutlet var myTableView : UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    
    override func viewDidLoad() {
        
        self.viewModel.delegate = self
        
        view.backgroundColor = UIColor.white
        /// delegate and data source
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        ///scroll and other settings to control experience.
        self.myTableView.isScrollEnabled = true
        self.myTableView.allowsMultipleSelection = false
        /// color settings
        self.myTableView.separatorColor = UIColor.white
        self.myTableView.backgroundColor = UIColor.white
    }
    
    
    @IBAction func addFishingBoat() {
        // add through VM interface
        self.viewModel.addNewBoat()
    }
    
    
    //MARK:- Required UITableViewDataSource Support

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.viewModel.rtnManagedBoatsCount())
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var cell = myTableView.dequeueReusableCell(withIdentifier: FishingBoatsVC.CELL_REUSE_ID) as? BoatsTableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style:.default, reuseIdentifier: FishingBoatsVC.CELL_REUSE_ID) as? BoatsTableViewCell
        }

        let node = self.viewModel.managedBoats[indexPath.item]

        cell?.backgroundColor = UIColor.white
        
        
        cell?.boatTitle.text = "Fishing Boat #\(String(describing: node.boatId))"
        cell?.storageSize.text = "Boat Fish Stored : \(String(describing: node.boatStorage))"
        
        cell?.stateView.layer.borderWidth = 1.0
        cell?.stateView.layer.borderColor = UIColor.black.cgColor
        cell?.stateView.layer.cornerRadius = 16.0
        cell?.stateView.clipsToBounds = true
        
        switch (node.state) {
            case BoatState.docked:
                cell?.stateView.backgroundColor = UIColor(red:139/255,green:187/255,blue:247/255, alpha: 1.0)
            break
            case BoatState.fishing:
                cell?.stateView.backgroundColor = UIColor(red:181/255,green:245/255,blue:166/255, alpha: 1.0)
            break
        }
        return cell!
    }
    
    //MARK:- UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let node = self.viewModel.managedBoats[indexPath.item]
        guard let boatId = Int64(node.boatId) else {
            return
        }
        self.viewModel.toggleBoatState(at: boatId)
    }
    
    func reloadTableViewFromViewModel() {
        self.myTableView.reloadData()
    }
    
}
