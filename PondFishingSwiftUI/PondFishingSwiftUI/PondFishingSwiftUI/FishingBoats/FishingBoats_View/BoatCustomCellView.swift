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
        //HStack {
        //Spacer()
        VStack(alignment: .leading) {
            Spacer()
            Text(boatInfo.boatName)
            Text("Fish Caught and Stored : \(boatInfo.fishStored)")
                .font(.subheadline)
                .foregroundColor(.black)
            Text(String(describing:"\(boatInfo.docked)")).font(.subheadline).foregroundColor(.black)
            Spacer()
        }
    }
}

//struct BoatCustomCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        BoatCustomCellView(boatInfo: <#Boat#>)
//    }
//}
