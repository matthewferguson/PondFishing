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
    
    @Environment(\.managedObjectContext) private var viewContext
    private var items:[String] = ["Fishing Boat ID 0","Fishing Boat ID 1"]
    
    //@available(iOS 13.6, *)
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    Text("\(item)")
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
//                ToolbarItem {
//                    //Button(action: addItem) {
//                    Button(action: nil) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
            }
            Text("Select an item")
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {

        }
    }
    
    
}


extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}



