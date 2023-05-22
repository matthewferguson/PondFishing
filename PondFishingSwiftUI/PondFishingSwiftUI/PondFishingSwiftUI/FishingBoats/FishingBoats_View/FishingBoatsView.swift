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
        Boat(boatName: "Trawler", docked: .fishing, fishStored: 2050),
        Boat(boatName: "Trawler", docked: .docked, fishStored: 3050),
        Boat(boatName: "Walk Around", docked: .docked, fishStored: 4050),
        Boat(boatName: "Center Console", docked: .fishing, fishStored: 5050),
        Boat(boatName: "Center Console", docked: .docked, fishStored: 6050),
        Boat(boatName: "Center Console", docked: .docked, fishStored: 7050),
        Boat(boatName: "Skiff", docked: .docked, fishStored: 8050),
        Boat(boatName: "Skiff", docked: .docked, fishStored: 9050),
        Boat(boatName: "Walk Around", docked: .fishing, fishStored: 10050)
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


