//
//  ContentViewModel.swift
//  TestGame
//
//  Created by Nikolai Lipski on 8.03.24.
//

import Foundation
import Combine
import SwiftUI

struct BallModel: Hashable {
    var id: Int
    var color: Color
    var offset: CGFloat
}

final class ContentViewModel: ObservableObject {
    private var amountOfHandlingBallViews = 5
    private var currentIndex = 0
    var currentRound = 1
    var availableLives = 3
    var roundSeconds: Int {
        30 - currentRound * 5
    }
    
    @Published var models: [BallModel] = []
    
    @Published var isModelOneAnimating = false
    @Published var isModelTwoAnimating = false
    @Published var isModelThreeAnimating = false
    @Published var isModelFourAnimating = false
    @Published var isModelFiveAnimating = false
    
    private var randomColor: Color {
        let colors: [Color] = [.yellow, .green, .black, .pink, .red]
        return colors.randomElement() ?? .white
    }
    
    private var randomXOffset: CGFloat {
        CGFloat((-150...150).random)
    }
    
    lazy var timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    lazy var roundTimer = Timer.scheduledTimer(timeInterval: TimeInterval(roundSeconds), target: self, selector: #selector(roundFinished), userInfo: nil, repeats: false)
    
    
    init() {
        models = generateInitialBalls()
    }
    
    @objc func fireTimer() {
        let index = currentIndex
        let ball = generateBall(id: index)
        
        models[currentIndex] = ball
        withAnimation(.linear(duration: 3)) {
            updateState(for: index, isAnimating: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: { [weak self] in
            self?.updateState(for: index, isAnimating: false)
        })
        
        currentIndex += 1
        if currentIndex > 4 {
            currentIndex = 0
        }
    }
    
    @objc func roundFinished() {
        
    }
    
    func getObject(for id: Int) -> Bool {
        if id == 0 {
            return isModelOneAnimating
        } else if id == 1 {
            return isModelTwoAnimating
        } else if id == 2 {
            return isModelThreeAnimating
        } else if id == 3 {
            return isModelFourAnimating
        } else if id == 4 {
            return isModelFiveAnimating
        }
        
        return false
    }

    func updateState(for id: Int, isAnimating: Bool) {
        if id == 0 {
            isModelOneAnimating = isAnimating
        } else if id == 1 {
            isModelTwoAnimating = isAnimating
        } else if id == 2 {
            isModelThreeAnimating = isAnimating
        } else if id == 3 {
            isModelFourAnimating = isAnimating
        } else if id == 4 {
            isModelFiveAnimating = isAnimating
        }
    }
    
    private func generateInitialBalls() -> [BallModel] {
        var models: [BallModel] = []
        for i in 0..<amountOfHandlingBallViews {
            models.append(generateBall(id: i))
        }
        return models
    }
    
    func generateBall(id: Int) -> BallModel {
        BallModel(id: id, color: randomColor, offset: randomXOffset)
    }
    
    func onAppear() {
        timer.fire()
    }
}
