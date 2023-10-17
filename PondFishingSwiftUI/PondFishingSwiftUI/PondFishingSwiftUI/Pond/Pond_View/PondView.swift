//
//  PondView.swift
//  PondFishingSwiftUI
//
//  Created by Matthew Ferguson on 10/11/23.
//

import SwiftUI

struct PondView: View {
    
    @StateObject private var viewModel = PondVM()
    
    var body: some View {
        VStack{
            Spacer()
            Spacer()
            Text("Fish Available in Pond")
            Spacer()
            Text(viewModel.fishCount)
            Spacer()
            Button {
                viewModel.reloadPond()
            } label: {
                Text("Load Fish")
                    .padding()
                    .overlay( RoundedRectangle(cornerRadius: 8)
                                .stroke(.blue, lineWidth: 4) )
                    .padding()
            }
            Button {
                viewModel.resetPond()
            } label: {
                Text("Reset Pond")
                    .padding()
                    .overlay( RoundedRectangle(cornerRadius: 8)
                                .stroke(.blue, lineWidth: 4) )
                    .padding()
            }
            Spacer()
            Spacer()
        }
        .onAppear {
            viewModel.setupFetchControllers()
        }
    }
}

#Preview {
    PondView()
}
