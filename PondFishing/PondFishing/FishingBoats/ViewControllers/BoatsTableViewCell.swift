//
//  BoatsTableViewCell.swift
//  PondFishing
//
//  Created by Matthew Ferguson on 2/16/21.
//

import Foundation
import UIKit


public class BoatsTableViewCell: UITableViewCell {
    
    @IBOutlet var boatTitle:UILabel!
    @IBOutlet var storageSize:UILabel!
    @IBOutlet var stateView:UIView!
    
    override public func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
