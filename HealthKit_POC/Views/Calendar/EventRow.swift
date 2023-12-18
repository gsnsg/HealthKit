//
//  EventRow.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 12/13/23.
//

import SwiftUI

struct EventRow: View {
    
    let entry: EventRowDataSource
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(entry.name ?? "N/A")
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                Spacer()
                Text("\(entry.uiImages.count) Image/'s")
                    .fontWeight(.bold)
                    .font(.system(size: 15))
            }
            
            Text("Protein - \(entry.protein ?? "0")gms, Carbs - \(entry.carbs ?? "0")gms, Fats - \(entry.fats ?? "0")gms")
                .font(.system(size: 15))
                .padding(.top, 12)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(entry.uiImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                }
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 40)
        .border(Color.gray, width: 1)
        .padding(.horizontal, 20)
    }
}
