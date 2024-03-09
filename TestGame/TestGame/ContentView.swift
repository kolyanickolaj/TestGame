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
                ForEach(viewModel.models, id: \.self) { model in
                    VStack {
                        Button {
                            viewModel.updateState(for: model.id, isAnimating: false)
                            print("Tap id = \(model.id)")
                        } label: {
                            Circle()
                                .foregroundColor(model.color)
                                .frame(height: 50)
                        }
                    }
                    .offset(x: model.offset, y: viewModel.getObject(for: model.id) ? 150 : -150)
                }
            }
            
            VStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                    
                    VStack {
                        Text("Round 1")
                            .padding(.top, 10)
                        
                        HStack {
                            Text("Collected: 0 of 5")
                            
                            Spacer()
                        }
                        
                        HStack {
                            Text("Lives available: 2")
                            
                            Spacer()
                        }
                        
                        Text("TARGET")
                            .padding(.top, 10)
                        
                        Circle()
                            .foregroundColor(.red)
                            .frame(height: 50)
                        
                        Text("00:13")
                            .padding(.top, 10)
                    }
                    .padding(.horizontal, 20)
                }
                .frame(height: 300)
                
                Spacer()
//                    .allowsHitTesting(false)
                
                Rectangle()
                    .foregroundColor(.white)
                    .frame(height: 100)
            }
            .ignoresSafeArea()
        }
        .onAppear() {
            viewModel.onAppear()
        }
    }
}

#Preview {
    ContentView()
}

extension Range where Bound: FixedWidthInteger {
    var random: Bound { .random(in: self) }
    func random(_ n: Int) -> [Bound] { (0..<n).map { _ in random } }
}

extension ClosedRange where Bound: FixedWidthInteger  {
    var random: Bound { .random(in: self) }
    func random(_ n: Int) -> [Bound] { (0..<n).map { _ in random } }
}
