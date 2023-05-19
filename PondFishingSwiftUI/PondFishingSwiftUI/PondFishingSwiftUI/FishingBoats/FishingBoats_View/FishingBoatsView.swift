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
    
    @State private var selectedIndex: Int64? // temp holding place
    
    //@Environment(\.managedObjectContext) private var viewContext
    
    private var boats = [
        Boat(boatName: "Boat #1", docked: .docked, fishStored: 2050),
        Boat(boatName: "Boat #2", docked: .docked, fishStored: 3050),
        Boat(boatName: "Boat #3", docked: .docked, fishStored: 4050),
        Boat(boatName: "Boat #4", docked: .docked, fishStored: 5050),
        Boat(boatName: "Boat #5", docked: .docked, fishStored: 6050),
        Boat(boatName: "Boat #6", docked: .docked, fishStored: 7050),
        Boat(boatName: "Boat #7", docked: .docked, fishStored: 8050),
        Boat(boatName: "Boat #8", docked: .docked, fishStored: 9050),
        Boat(boatName: "Boat #9", docked: .docked, fishStored: 10050)
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(boats) { singleboat in
                    BoatCustomCellView(boatInfo: singleboat)
                        .listRowBackground(Color.white)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            let selected = index
                            print(selected)// says it is a function
                        }
                } // For Each
                .onDelete(perform: deleteItems)
            }// List
            
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
            .navigationTitle(Text("Start Fishing with a Tap"))
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


