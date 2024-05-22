//
//  ContentView.swift
//  muglan
//
//  Main View
//  Created by Mohit Paudyal on 5/17/24.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel = MainViewViewModel()
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserID.isEmpty {
            // if the user is signed in
            accountView
        } else {
            LoginView()
        }
    }
    
    @ViewBuilder
    var accountView: some View {
        TabView{
            JobListView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            DraftJobListView()
                .tabItem {
                    Label("Draft", systemImage: "note.text")
                }
            ProfileView(userID: viewModel.currentUserID)
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
    
    
}

#Preview {
    MainView()
}
