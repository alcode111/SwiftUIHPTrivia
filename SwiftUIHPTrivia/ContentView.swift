//
//  ContentView.swift
//  SwiftUIHPTrivia
//
//  Created by Ismaïl on 05/05/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var scalePlayButton = false
    @State private var moveBackgroundImage = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("hogwarts")
                    .resizable()
                    .frame(width: geo.size.width * 3, height: geo.size.height)
                    .padding(.top, 3)
                    .offset(x: moveBackgroundImage ?
                            geo.size.width / 1.1 :
                            -geo.size.width / 1.1)
                    .onAppear {
                        withAnimation(.linear(duration: 60)) {
                            moveBackgroundImage.toggle()
                        }
                    }
                
                VStack {
                    VStack {
                        Image(systemName: "bolt.fill")
                            .font(.largeTitle)
                            .imageScale(.large)
                        
                        Text("HP")
                            .font(.custom(Constants.hpFont, size: 70))
                            .padding(.bottom, -50)
                        
                        Text("Trivia")
                            .font(.custom(Constants.hpFont, size: 60))
                    }
                    .padding(.top, 70)
                    
                    Spacer()
                    
                    VStack {
                        Text("Recent scores")
                            .font(.title2)
                        
                        Text("33")
                        Text("27")
                        Text("15")
                    }
                    .font(.title3)
                    .padding(.horizontal)
                    .foregroundStyle(.white)
                    .background(.black.opacity(0.7))
                    .cornerRadius(17)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            //Show game instructions
                        } label: {
                            Image(systemName: "info.circle.fill")
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                                .shadow(radius: 5)
                        }
                        
                        Spacer()
                        
                        Button {
                            // Start new game
                        } label: {
                            Text("Play")
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                                .padding(.vertical, 7)
                                .padding(.horizontal, 50)
                                .background(.brown)
                                .cornerRadius(7)
                                .shadow(radius: 5)
                        }
                        .scaleEffect(scalePlayButton ? 1.2 : 1)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                                scalePlayButton.toggle()
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                                .shadow(radius: 5)
                        }
                        
                        Spacer()
                    }
                    .frame(width: geo.size.width)
                    
                    Spacer()
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
