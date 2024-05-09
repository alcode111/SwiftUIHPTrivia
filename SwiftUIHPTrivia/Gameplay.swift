//
//  Gameplay.swift
//  SwiftUIHPTrivia
//
//  Created by admin on 07/05/2024.
//

import SwiftUI
import AVKit

struct Gameplay: View {
    
    @Environment(\.dismiss) private var dismiss
    @Namespace private var namespace
    @State private var musicPlayer: AVAudioPlayer!
    @State private var sfxPlayer: AVAudioPlayer!
    @State private var animateViewsIn = false
    @State private var correctAnswer = false
    @State private var hintWiggle = false
    @State private var scaleNextButton = false
    @State private var movePointsToScore = false
    @State private var revealHint = false
    @State private var revealBook = false
    @State private var wrongAnswersTapped: [Int] = []

    
    let tempAnswers = [true, false, false, false]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("hogwarts")
                    .resizable()
                    .frame(width: geo.size.width * 3, height: geo.size.height * 1.05)
                    .overlay(Rectangle().foregroundStyle(.black.opacity(0.8)))
                
                VStack {
                    // MARK: Controls
                    HStack {
                        Button("End Game") {
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red.opacity(0.5))
                        
                        Spacer()
                        
                        Text("Score: 33")
                    }
                    .padding()
                    .padding(.vertical, 30)
                    
                    // MARK: Question
                    VStack {
                        if animateViewsIn {
                            Text("Who is Harry Potter?")
                                .font(.custom(Constants.hpFont, size: 50))
                                .multilineTextAlignment(.center)
                                .padding()
                                .transition(.scale)
                                .opacity(correctAnswer ? 0.1 : 1)
                        }
                    }
                    .animation(.easeInOut(duration: animateViewsIn ? 2 : 0), value: animateViewsIn)
                    
                    Spacer()
                    
                    // MARK: Hints
                    HStack {
                        VStack {
                            if animateViewsIn {
                                Image(systemName: "questionmark.app.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                    .foregroundStyle(.cyan)
                                    .rotationEffect(.degrees(hintWiggle ? -13 : -17))
                                    .padding()
                                    .padding(.leading, 20)
                                    .transition(.offset(x: -geo.size.width / 2))
                                    .onAppear {
                                        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
                                            withAnimation(.easeInOut(duration: 0.1).repeatCount(9)) {
                                                hintWiggle.toggle()
                                            }
                                        }
                                    }
                                    .onTapGesture {
                                        withAnimation(.easeOut(duration: 1)) {
                                            revealHint = true
                                        }
                                        
                                        playFlipSound()
                                    }
                                    .rotation3DEffect(.degrees(revealHint ? 1440 : 0), axis: (x: 0, y: 1, z: 0))
                                    .scaleEffect(revealHint ? 5 : 1)
                                    .opacity(revealHint ? 0 : 1)
                                    .offset(x: revealHint ? geo.size.width / 2 : 0)
                                    .overlay(
                                        Text("The Boy Who _____")
                                            .padding(.leading, 33)
                                            .minimumScaleFactor(0.5)
                                            .multilineTextAlignment(.center)
                                            .opacity(revealHint ? 1 : 0)
                                            .scaleEffect(revealHint ? 1.33 : 1)
                                    )
                                    .opacity(correctAnswer ? 0 : 1)
                                    .disabled(correctAnswer)

                            }
                        }
                        .animation(.easeOut(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 2 : 0), value: animateViewsIn)
                        
                        Spacer()
                        
                        VStack {
                            if animateViewsIn {
                                Image(systemName: "book.closed")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50)
                                    .foregroundStyle(.black)
                                    .frame(width: 100, height: 100)
                                    .background(.cyan)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .rotationEffect(.degrees(hintWiggle ? 13 : 17))
                                    .padding()
                                    .padding(.trailing, 20)
                                    .transition(.offset(x: geo.size.width / 2))
                                    .onTapGesture {
                                        withAnimation(.easeOut(duration: 1)) {
                                            revealBook = true
                                        }
                                        
                                        playFlipSound()
                                    }
                                    .rotation3DEffect(.degrees(revealBook ? 1440 : 0), axis: (x: 0, y: 1, z: 0))
                                    .scaleEffect(revealBook ? 5 : 1)
                                    .opacity(revealBook ? 0 : 1)
                                    .offset(x: revealBook ? -geo.size.width / 2 : 0)
                                    .overlay(
                                        Image("hp1")
                                            .resizable()
                                            .scaledToFit()
                                            .padding(.trailing, 33)
                                            .opacity(revealBook ? 1 : 0)
                                            .scaleEffect(revealBook ? 1.33 : 1)
                                    )
                                    .opacity(correctAnswer ? 0.1 : 1)
                                    .disabled(correctAnswer)
                            }
                        }
                        .animation(.easeOut(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 2 : 0), value: animateViewsIn)
                    }
                    .padding()
                    
                    // MARK: Answers
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(1..<5) {i in
                            if tempAnswers[i-1] {
                                VStack {
                                    if animateViewsIn {
                                        if !correctAnswer {
                                            Text("Answer \(i)")
                                                .minimumScaleFactor(0.5)
                                                .multilineTextAlignment(.center)
                                                .padding(10)
                                                .frame(width: geo.size.width / 2.15, height: 80)
                                                .background(.green.opacity(0.5))
                                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                                .transition(.asymmetric(insertion: .scale, removal: .scale(scale: 5).combined(with: .opacity.animation(.easeOut(duration: 0.5)))))
                                                .matchedGeometryEffect(id: "answer", in: namespace)
                                                .onTapGesture {
                                                    withAnimation(.easeOut(duration: 1)) {
                                                        correctAnswer = true
                                                        playCorrectSound()
                                                    }
                                                }
                                        }
                                    }
                                }
                                .animation(.easeOut(duration: animateViewsIn ? 1 : 0).delay(animateViewsIn ? 1.5 : 0), value: animateViewsIn)
                            } else {
                                VStack {
                                    if animateViewsIn {
                                        Text("Answer \(i)")
                                            .minimumScaleFactor(0.5)
                                            .multilineTextAlignment(.center)
                                            .padding(10)
                                            .frame(width: geo.size.width / 2.15, height: 80)
                                            .background(wrongAnswersTapped.contains(i) ? .red.opacity(0.5) : .green.opacity(0.5))
                                            .clipShape(RoundedRectangle(cornerRadius: 25))
                                            .transition(.scale)
                                            .onTapGesture {
                                                withAnimation(.easeOut(duration: 1)) {
                                                    wrongAnswersTapped.append(i)
                                                }
                                                
                                                playWrongSound()
                                                giveWrongFeedback()
                                            }
                                            .scaleEffect(wrongAnswersTapped.contains(i) ? 0.8 : 1)
                                            .disabled(correctAnswer || wrongAnswersTapped.contains(i))
                                            .opacity(correctAnswer ? 0.1 : 1)
                                    }
                                }
                                .animation(.easeOut(duration: animateViewsIn ? 1 : 0).delay(animateViewsIn ? 1.5 : 0), value: animateViewsIn)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .foregroundStyle(.white)
                
                // MARK: Celebration
                VStack {
                    Spacer()
                    
                    VStack {
                        if correctAnswer {
                            Text("5")
                                .font(.largeTitle)
                                .padding(.top, 50)
                                .transition(.offset(y: -geo.size.height / 4))
                                .offset(x: movePointsToScore ? geo.size.width / 2.3 : 0, y: movePointsToScore ? -geo.size.height / 13 : 0)
                                .opacity(movePointsToScore ? 0 : 1)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1).delay(3)) {
                                        movePointsToScore = true
                                    }
                                }
                        }
                    }
                    .animation(.easeInOut(duration: 1).delay(2), value: correctAnswer)
                    
                    Spacer()
                    
                    VStack {
                        if correctAnswer {
                            Text("Brilliant!")
                                .font(.custom(Constants.hpFont, size: 100))
                                .transition(.scale.combined(with: .offset(y: -geo.size.height / 2)))
                                .matchedGeometryEffect(id: "answer", in: namespace)
                        }
                    }
                    .animation(.easeInOut(duration: correctAnswer ? 1 : 0).delay(correctAnswer ? 1 : 0), value: correctAnswer)
                    
                    Spacer()
                    
                    if correctAnswer {
                        Text("Answer 1")
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .padding(10)
                            .frame(width: geo.size.width / 2.15, height: 80)
                            .background(.green.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .scaleEffect(2)
                    }
                    
                    Spacer()
                    Spacer()
                    
                    VStack {
                        if correctAnswer {
                            Button("Next Level>") {
                                animateViewsIn = false
                                correctAnswer = false
                                revealHint = false
                                revealBook = false
                                movePointsToScore = false
                                wrongAnswersTapped = []
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    animateViewsIn = true
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue.opacity(0.5))
                            .font(.largeTitle)
                            .transition(.offset(y: geo.size.height / 3))
                            .scaleEffect(scaleNextButton ? 1.2 : 1)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                                    scaleNextButton.toggle()
                                }
                            }
                        }
                    }
                    .animation(.easeInOut(duration: correctAnswer ? 2.7 : 0).delay(correctAnswer ? 2.7 : 0), value: correctAnswer)
                    
                    Spacer()
                    Spacer()
                    
                }
                .foregroundStyle(.white)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .onAppear {
            animateViewsIn = true
            
//            playMusic()
        }
    }
    
    private func playMusic() {
        let songs = ["let-the-mystery-unfold", "spellcraft", "hiding-place-in-the-forest", "deep-in-the-dell",]
        
        let i = Int.random(in: 0...3)
        
        let sound = Bundle.main.path(forResource: songs[i], ofType: "mp3")
        musicPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        musicPlayer.volume = 0.1
        musicPlayer.numberOfLoops = -1
        musicPlayer.play()
    }
    
    private func playFlipSound() {
        let sound = Bundle.main.path(forResource: "page-flip", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        sfxPlayer.play()
    }
    
    private func playWrongSound() {
        let sound = Bundle.main.path(forResource: "negative-beeps", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        sfxPlayer.play()
    }
    
    private func playCorrectSound() {
        let sound = Bundle.main.path(forResource: "magic-wand", ofType: "mp3")
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        sfxPlayer.play()
    }
    
    private func giveWrongFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}

#Preview {
    Gameplay()
}
