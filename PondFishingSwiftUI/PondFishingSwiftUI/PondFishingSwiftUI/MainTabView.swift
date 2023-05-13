//
//  MainTabView.swift
//  PondFishingSwiftUI
//
//  Created by Matthew Ferguson on 5/12/23.
//

import Foundation
import SwiftUI


struct MainTabView: View {
    var body: some View {
        TabView {
            ContentView()
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "square.and.arrow.down")
                    Text("Pond")
                }
            
            Text("Fishing Boats Control")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .tabItem {
                                Image(systemName: "figure.fishing")
                                Text("Fishing Boats").font(.system(size: 30, weight: .bold, design: .rounded))
                            }
            Text("Fish Market")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .tabItem {
                                Image(systemName: "square.and.arrow.up")
                                Text("Fish Market")
                            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            ContentView()
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "square.and.arrow.down")
                    Text("Pond")
                }
            
            Text("Fishing Boats Control")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .tabItem {
                                Image(systemName: "figure.fishing")
                                Text("Fishing Boats").font(.system(size: 30, weight: .bold, design: .rounded))
                            }
            Text("Fish Market")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .tabItem {
                                Image(systemName: "square.and.arrow.up")
                                Text("Fish Market")
                            }
        }
    }
}
