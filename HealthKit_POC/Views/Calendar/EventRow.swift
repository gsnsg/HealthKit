//
//  EventRow.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 12/13/23.
//

import SwiftUI

struct EventRow: View {
    private let foodName = "Chicken Biryani"
    private let numOfImages = 10
    private let protein = 10
    private let carbs = 10
    private let fats = 10
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text(foodName)
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                Spacer()
                Text("\(numOfImages) Image/'s")
                    .font(.system(size: 15))
            }
            
            Text("Protein - \(10)gms, Carbs - \(10)gms, Fats - \(10)gms")
                .font(.system(size: 15))
                .padding(.top, 12)
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 40)
        .border(Color.gray, width: 1)
        .padding(.horizontal, 20)
    }
}

#Preview {
    List {
        ForEach(0 ..< 10) { _ in
            EventRow()
        }
    }
    .listStyle(.plain)
}
