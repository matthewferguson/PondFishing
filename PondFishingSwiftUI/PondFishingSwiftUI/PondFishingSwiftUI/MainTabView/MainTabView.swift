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
            PondView()
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "square.and.arrow.down")
                    Text("Pond").font(.system(size: 30, weight: .bold, design: .rounded))
            }
            FishingBoatsView()
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "figure.fishing")
                    Text("Fishing Boats Control")
                }
            FishMarketView()
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
            Text("Pond")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "square.and.arrow.down")
                    Text("Pond").font(.system(size: 30, weight: .bold, design: .rounded))
                }
            FishingBoatsView()
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "figure.fishing")
                    Text("Fishing Boats Control")
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

