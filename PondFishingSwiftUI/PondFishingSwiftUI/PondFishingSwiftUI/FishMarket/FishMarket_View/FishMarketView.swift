//
//  FishMarketView.swift
//  PondFishingSwiftUI
//
//  Created by Matthew Ferguson on 10/13/23.
//

import SwiftUI

struct FishMarketView: View {
    @StateObject private var viewModel = FishMarketVM()
    var body: some View {
        VStack{
            Spacer()
            Text("Fish Sold to Market")
            Text(viewModel.fishCount)
            Spacer()
        }
        .onAppear {
            viewModel.setupFetchControllers()
        }
    }
}



#Preview {
    FishMarketView()
}
