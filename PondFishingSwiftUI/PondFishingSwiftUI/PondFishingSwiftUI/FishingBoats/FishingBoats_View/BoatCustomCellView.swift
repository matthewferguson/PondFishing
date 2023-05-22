//
//  BoatCustomCellView.swift
//  PondFishingSwiftUI
//
//  Created by Matthew Ferguson on 5/18/23.
//

import SwiftUI

struct BoatCustomCellView: View {
    var boatInfo: Boat
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(boatInfo.boatName + " permit: " + String(describing: boatInfo.id))
                .font(.headline)
            Spacer()
            Text("Fish Caught and Stored : \(boatInfo.fishStored)")
                .font(.headline)
                .foregroundColor(.black)
            Spacer()
            Text(String(describing:"\(boatInfo.docked)"))
                .font(.headline)
                .foregroundColor(.black)
            Spacer()

        }
    }
}

//struct BoatCustomCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        BoatCustomCellView(boatInfo: <#Boat#>)
//    }
//}
