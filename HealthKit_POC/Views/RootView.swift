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
            
            NavigationStack {
                DiaryView()
                    .navigationTitle("Dairy")
            }
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

struct RooView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
