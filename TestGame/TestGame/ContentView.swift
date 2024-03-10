//
//  ContentView.swift
//  TestGame
//
//  Created by Nikolai Lipski on 8.03.24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @StateObject var viewModel = ContentViewModel()
    
    private var topViewHeight: CGFloat = 300
    private var bottomViewHeight: CGFloat = 100
    
    var topYBallOffset: CGFloat {
        topViewHeight + safeAreaInsets.top - viewModel.ballDiameter - viewModel.screenSize.height / 2
    }
    
    var bottomYBallOffset: CGFloat {
        viewModel.screenSize.height / 2 - bottomViewHeight - safeAreaInsets.bottom + viewModel.ballDiameter
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .ignoresSafeArea()
            
            ZStack {
                ForEach(viewModel.models, id: \.self) { model in
                    Circle()
                        .foregroundColor(model.color)
                        .frame(height: viewModel.ballDiameter)
                        .offset(x: model.offset, y: viewModel.getState(for: model.id) ? bottomYBallOffset : topYBallOffset)
                        .simultaneousGesture(
                          TapGesture()
                              .onEnded { _ in
                                  viewModel.ballTapped(model: model)
                              }
                         )
                }
            }
            
            VStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("Round \(viewModel.currentRound) of \(viewModel.maxRounds)")
                            .padding(.top, 10)
                            .foregroundColor(.black)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Collected: \(viewModel.currentPoints) of \(viewModel.maxPoints)")
                                    .foregroundColor(.black)
                                
                                Text("Lives available: \(viewModel.availableLives)")
                                    .foregroundColor(.black)
                            }
                            
                            Spacer()
                            
                            Button {
                                viewModel.onStart()
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.blue)
                                    
                                    Text(viewModel.isGameOver
                                         ? "Restart"
                                         : "Start")
                                        .foregroundColor(.white)
                                }
                                .frame(width: 90, height: 40)
                                .opacity(viewModel.isGameInProcess ? 0 : 1)
                            }
                        }
                        .padding(.top, 10)
                        
                        Text("TARGET")
                            .padding(.top, 10)
                            .foregroundColor(.black)
                        
                        Circle()
                            .foregroundColor(viewModel.roundColor)
                            .frame(height: viewModel.ballDiameter)
                        
                        Text(viewModel.roundTimeLeft > 9
                             ? "00:\(viewModel.roundTimeLeft)"
                             : "00:0\(viewModel.roundTimeLeft)")
                        .foregroundColor(.black)
                        .padding(.top, 10)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                }
                .frame(height: topViewHeight)
                
                Spacer()
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .ignoresSafeArea()
                    
                    VStack {
                        if viewModel.isGameOver {
                            Text(viewModel.isWin
                                 ? "You win!"
                                 : "Game over")
                                .font(.system(size: 20, weight: .black))
                                .foregroundColor(.black)
                                .padding(.top, 10)
                            
                            Spacer()
                        }
                    }
                }
                .frame(height: bottomViewHeight)
            }
        }
    }
}

#Preview {
    ContentView()
}
