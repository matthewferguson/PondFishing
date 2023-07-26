//
//  FishingBoatsView.swift
//  PondFishingSwiftUI
//
//  Created by Matthew Ferguson on 5/18/23.
//

import SwiftUI
import CoreData
import Foundation

struct FishingBoatsView: View {
    //@Environment(\.managedObjectContext) private var viewContext
    @State private var boats = [
        FishingBoat(boatId: String(1),boatName: "Fishing Trawler", docked: .fishing, fishStored: 0),
        FishingBoat(boatId: String(2),boatName: "Fisning Trawler", docked: .docked, fishStored: 0),
        FishingBoat(boatId: String(3),boatName: "Fisning Walk Around", docked: .docked, fishStored: 0),
        FishingBoat(boatId: String(4),boatName: "Fisning Center Console", docked: .fishing, fishStored: 0),
        FishingBoat(boatId: String(5),boatName: "Fisning Center Console", docked: .docked, fishStored: 0),
        FishingBoat(boatId: String(6),boatName: "Fisning Center Console", docked: .docked, fishStored: 0),
        FishingBoat(boatId: String(7),boatName: "Fisning Skiff", docked: .docked, fishStored: 0),
        FishingBoat(boatId: String(8),boatName: "Fisning Skiff", docked: .docked, fishStored: 0),
        FishingBoat(boatId: String(9),boatName: "Fisning Walk Around", docked: .fishing, fishStored: 0)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(boats, id: \.id) { singleboat in
                        BoatCustomCellView(boatInfo: singleboat)
                            .listRowBackground(singleboat.docked == .fishing ? Color.green : Color.blue)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                var selectedBoat = singleboat
                                if selectedBoat.docked == .docked {
                                    selectedBoat.docked = .fishing
                                } else {
                                    selectedBoat.docked = .docked
                                }
                                
                                if let row = self.boats.firstIndex(where: {$0.id == selectedBoat.id}) {
                                    boats[row] = selectedBoat
                                }
                            }
                    } // For Each
                    .onDelete(perform: deleteItems)
                    .listRowSeparatorTint(.black)
                }// List
            }
            
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItems) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle(Text("Start Fishing (tap)"))
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {

        }
    }
    private func addItems() {
        withAnimation {

        }
    }
}


