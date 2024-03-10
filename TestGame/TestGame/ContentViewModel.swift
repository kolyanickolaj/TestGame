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
    private var passCounter = 0
    private lazy var roundStartDate: Date = Date()
    
    var maxRounds = 3
    var currentRound = 1
    var availableLives = 3
    var maxPoints = 3
    var currentPoints = 0
    lazy var roundColor: Color = randomColor
     
    private var roundDuration: Double {
        Double(60 - currentRound * 5)
    }
    
    private var fallingDuration: Double {
        Double(3 - 0.6 * Double(currentRound))
    }
    
    private var sendingBallsFrequency: Int {
        5 - currentRound
    }
    
    @Published var models: [BallModel] = []
    @Published var roundTimeLeft: Int = 0
    @Published var isGameOver = false
    @Published var isWin = false
    @Published var isGameInProcess = false
    @Published var isModelOneAnimating = false
    @Published var isModelTwoAnimating = false
    @Published var isModelThreeAnimating = false
    @Published var isModelFourAnimating = false
    @Published var isModelFiveAnimating = false
    
    private var randomColor: Color {
        [.yellow, .green, .black, .orange, .gray, .purple, .red].randomElement() ?? .white
    }
    
    let ballDiameter: CGFloat = 50
    
    var screenSize: CGRect {
        UIScreen.main.bounds
    }
    
    private var offsetX: Int {
        Int(screenSize.width / 2 - ballDiameter)
    }
    
    private var randomXOffset: CGFloat {
        CGFloat((-offsetX...offsetX).random)
    }
    
    private lazy var timer: Timer? = setupTimer()
    private lazy var roundTimer: Timer? = setupRoundTimer()
    
    init() {
        models = generateInitialBalls()
    }
    
    func getState(for id: Int) -> Bool {
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
    
    func ballTapped(model: BallModel) {
        guard !isGameOver else { return }
        
        updateState(for: model.id, isAnimating: false)
        if model.color == roundColor {
            currentPoints += 1
        } else {
            availableLives -= 1
        }
        
        if currentPoints == maxPoints {
            if currentRound == maxRounds {
                isWin = true
                stopGame()
            } else {
                currentRound += 1
                setupNewRound()
            }
        }
        
        if availableLives == 0 {
            stopGame()
        }
    }
    
    func onStart() {
        isGameInProcess = true
        if isGameOver {
            restartGame()
        } else {
            passCounter = sendingBallsFrequency - 1
            timer?.fire()
            roundTimer?.fire()
        }
    }
    
    private func updateState(for id: Int, isAnimating: Bool) {
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
    
    private func restartGame() {
        passCounter = sendingBallsFrequency - 1
        currentRound = 1
        isWin = false
        isGameOver = false
        availableLives = 3
        setupNewRound()
    }
    
    private func stopGame() {
        isGameOver = true
        isGameInProcess = false
        roundTimer?.invalidate()
        roundTimer = nil
    }
    
    private func setupNewRound() {
        passCounter = sendingBallsFrequency - 1
        currentPoints = 0
        roundColor = randomColor
        roundStartDate = Date()
        roundTimer = setupRoundTimer()
    }
    
    private func generateInitialBalls() -> [BallModel] {
        var models: [BallModel] = []
        for i in 0..<amountOfHandlingBallViews {
            models.append(generateBall(id: i))
        }
        return models
    }
    
    private func generateBall(id: Int) -> BallModel {
        BallModel(id: id, color: randomColor, offset: randomXOffset)
    }
    
    private func setupTimer() -> Timer {
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    private func setupRoundTimer() -> Timer {
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(fireRoundTimer), userInfo: nil, repeats: true)
    }
    
    @objc 
    private func fireTimer() {
        passCounter += 1
        guard passCounter == sendingBallsFrequency, !isGameOver else { return }
        
        passCounter = 0
        let index = currentIndex
        let ball = generateBall(id: index)
        
        models[currentIndex] = ball
        withAnimation(.linear(duration: fallingDuration)) {
            updateState(for: index, isAnimating: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + fallingDuration, execute: { [weak self] in
            self?.updateState(for: index, isAnimating: false)
        })
        
        currentIndex += 1
        if currentIndex > 4 {
            currentIndex = 0
        }
    }
    
    @objc 
    private func fireRoundTimer() {
        guard !isGameOver else { return }
        
        let timeLeft = Int(roundStartDate.addingTimeInterval(roundDuration).timeIntervalSinceNow)
        if timeLeft >= 0 {
            roundTimeLeft = timeLeft
        } else {
            stopGame()
        }
    }
}
