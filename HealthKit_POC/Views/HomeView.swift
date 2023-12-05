//
//  ContentView.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 8/28/23.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var homeViewModel = HomeViewModel()
    
    var body: some View {
        List {
            ForEach(homeViewModel.getDataTypes(), id: \.self) { dataType in
                Text(dataType)
            }
            Button {
                homeViewModel.exportHealthData()
            } label: {
                Text("Export Health Data")
            }
            .disabled(homeViewModel.isExportButtonDisabled)
        }
        .fileExporter(
            isPresented: $homeViewModel.exportData,
            documents: homeViewModel.getCsvFiles(),
            contentType: .commaSeparatedText
        ) { result in
            homeViewModel.fileExportedCompletion(result: result)
        }
        .onAppear {
            homeViewModel.startSetup()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
