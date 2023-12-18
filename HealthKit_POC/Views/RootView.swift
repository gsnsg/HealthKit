//
//  RooView.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 9/3/23.
//

import SwiftUI

struct RootView: View {
    
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
                    .navigationTitle("Summary")
            }
            .tabItem {
                Label("Health", systemImage: "heart.fill")
            }
            
            CalendarView()
                .tabItem {
                    Label("Nutrition", systemImage: "fork.knife.circle")
                }
            
            
            NavigationStack {
                UserDetailView()
                    .navigationTitle("User Details")
            }
            .tabItem {
                Label("Me", systemImage: "person.fill")
            }
        }
        .tint(.red)
    }
}

#Preview {
    RootView()
        .preferredColorScheme(.light)
}
