//
//  ContentView.swift
//  TestGame
//
//  Created by Nikolai Lipski on 8.03.24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .ignoresSafeArea()
            
            ZStack {
                
            }
            
            VStack {
                Rectangle()
                    .foregroundColor(.white)
                    .frame(height: 300)
                
                Spacer()
                
                Rectangle()
                    .foregroundColor(.white)
                    .frame(height: 100)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
