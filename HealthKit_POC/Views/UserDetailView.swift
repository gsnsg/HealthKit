//
//  UserDetailView.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 10/31/23.
//

import SwiftUI

class UserDetailViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var userId: String = ""
    
    init() {
        userName = UserDefaultsManager.shared.getValue(for: .userName) ?? ""
        userId = UserDefaultsManager.shared.getValue(for: .userId) ?? ""
    }
    
    func updateUserInfo() {
        UserDefaultsManager.shared.setValue(for: .userName, value: userName)
        UserDefaultsManager.shared.setValue(for: .userId, value: userId)
    }
}


struct UserDetailView: View {
    @StateObject private var userDetailViewModel = UserDetailViewModel()
    
    @State private var showAlert = false
    
    private let nameLabelText = "User Name"
    private let userIdLabelText = "User ID"
    private let updateUserInfoButtonText = "Update Info"
    private let updateSuccessfulText = "User Info updated successfully!"
    
    
    var body: some View {
        List {
            Section(header: Text(nameLabelText)) {
                TextField(nameLabelText, text: $userDetailViewModel.userName)
            }
            
            Section(header: Text(userIdLabelText)) {
                TextField(userIdLabelText, text: $userDetailViewModel.userId)
            }
            
            HStack {
                Spacer()
                Button {
                    userDetailViewModel.updateUserInfo()
                    showAlert.toggle()
                } label: {
                    Text(updateUserInfoButtonText)
                }
                Spacer()
            }
        }
        .alert(updateSuccessfulText, isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}
