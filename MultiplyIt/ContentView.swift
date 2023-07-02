//
//  ContentView.swift
//  MultiplyIt
//
//  Created by Nowroz Islam on 29/6/23.
//

import SwiftUI

struct ContentView: View {
    let animals: [ImageResource] = [
        .bear,
        .buffalo,
        .chick,
        .chicken,
        .cow,
        .crocodile,
        .dog,
        .duck,
        .elephant,
        .frog,
        .giraffe,
        .goat,
        .gorilla,
        .hippo,
        .horse,
        .monkey,
        .moose,
        .narwhal,
        .owl,
        .panda,
        .parrot,
        .penguin,
        .pig,
        .rabbit,
        .rhino,
        .sloth,
        .snake,
        .walrus,
        .whale,
        .zebra
    ].shuffled()
    
    let colors: [Color] = [
        .cyan,
        .orange,
        .yellow
    ]
    
    let choices: [Int] = [5, 10, 20]
    
    @State private var showingHome = true
    @State private var showingTableChoice = false
    @State private var showingNumberOfQuestions = false
    @State private var showingQuestions = false
    
    @State private var selected: Int? = nil
    @State private var numberOfQuestions = 5
    @State private var numbers: [Int] = []
    @State private var index = 0
    
    @State private var image = Image(.bear)
    
    @State private var answer = 0
    @State private var score = 0
    
    @FocusState private var isFocused: Bool
    
    @State private var shouldSpin = false
    @State private var shouldJerk = false
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    private var playButton: some View {
        Button {
            hideHome()
            showTableChoice()
        } label: {
            Text("Play")
                .font(.title.weight(.semibold))
        }
        .buttonStyle(.borderedProminent)
        .tint(.green)
        .shadow(radius: 3)
    }
    
    private var correctAnswer: Int {
        selected! * numbers[index]
    }
    
    private var home: some View {
        VStack(spacing: 50) {
            Text("Multiply It!")
                .font(.largeTitle.bold())
            
            Image(animals.randomElement()!)
            
            playButton
        }
    }
    
    private var tableChoice: some View {
        VStack(spacing: 30) {
            Text("Select multiplication table")
                .font(.title2.weight(.semibold))
            
            VStack(spacing: 16){
                ForEach(2..<13) { num in
                    Button {
                        withAnimation {
                            selected = num
                        }
                    } label: {
                        Text(num, format: .number)
                            .fontWeight(.bold)
                            .frame(maxWidth: 50)
                            .foregroundStyle(.white)
                            .background(colors[num % colors.count])
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .scaleEffect(Selection.shouldScale(table: num, when: selected) ? 1.5 : 1.0)
                            .opacity(Selection.getOpacity(of: num, when: selected))
                    }
                }
            }
            
            HStack {
                Button {
                    showHome()
                    hideTableChoice()
                } label: {
                    VStack(spacing: 10) {
                        Text("home")
                            .foregroundStyle(.orange)
                        
                        Image(systemName: "arrowshape.left.fill")
                            .font(.title)
                            .foregroundStyle(.orange)
                    }
                }
                
                Spacer()
                
                if selected != nil {
                    Button {
                        hideTableChoice()
                        showNumberOfQuestions()
                    } label: {
                        VStack(spacing: 10) {
                            Text("next")
                                .foregroundStyle(.green)
                            
                            Image(systemName: "arrowshape.right.fill")
                                .font(.title)
                                .foregroundStyle(.green)
                        }
                    }
                }
            }
        }
    }
    
    private var questionNumber: some View {
        VStack {
            Spacer()
            Spacer()
            
            Text("Select number of questions")
                .font(.title2.weight(.semibold))
            
            HStack {
                Button {
                    decreasQuesions()
                } label: {
                    Image(systemName: "arrowtriangle.left.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.cyan)
                }
                
                Spacer()
                
                Text(numberOfQuestions, format: .number)
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Button {
                    increaseQuestions()
                } label: {
                    Image(systemName: "arrowtriangle.right.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.cyan)
                }
            }
            .padding(50)
            
            Spacer()
            
            HStack {
                Button {
                    showTableChoice()
                    hideNumberOfQuestions()
                } label: {
                    VStack(spacing: 10) {
                        Text("back")
                            .foregroundStyle(.orange)
                        
                        Image(systemName: "arrowshape.left.fill")
                            .font(.title)
                            .foregroundStyle(.orange)
                    }
                }
                
                Spacer()
                
                Button {
                    start()
                } label: {
                    VStack(spacing: 10) {
                        Text("start")
                            .foregroundStyle(.green)
                        
                        Image(systemName: "arrowshape.right.fill")
                            .font(.title)
                            .foregroundStyle(.green)
                    }
                }
            }
            
            Spacer()
        }
    }
    
    private var questions: some View {
        VStack(spacing: 50) {
            VStack(spacing: 10) {
                Text("Question no. \(index + 1)")
                    .foregroundStyle(.secondary)
                
                if let selected {
                    Text("\(selected) x \(numbers[index]) = ?")
                        .font(.title.weight(.semibold))
                }
            }
            
            if isFocused == false {
                image
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipped()
                    .rotationEffect(shouldSpin ? .degrees(360) : .degrees(0))
                    .rotationEffect(shouldJerk ? .degrees(-30) : .degrees(0))
            }
            
            
            VStack(spacing: 20) {
                TextField("Answer", value: $answer, format: .number)
                    .font(.title)
                    .padding()
                    .frame(maxWidth: 100)
                    .foregroundStyle(.cyan)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .keyboardType(.decimalPad)
                    .focused($isFocused)
                
                Button {
                    checkAnswer()
                } label: {
                    Text("Confirm")
                        .font(.title)
                }
                .buttonStyle(.borderedProminent)
                .tint(.pink)
            }
        }
        .onAppear {
            image = Image(animals.randomElement()!)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if showingHome {
                    home
                        .transition(
                            .asymmetric(insertion: .slide, removal: .opacity)
                        )
                }
                
                if showingTableChoice {
                    tableChoice
                        .padding(25)
                        .transition(.opacity)
                }
                
                if showingNumberOfQuestions {
                    questionNumber
                        .padding(25)
                        .transition(.opacity)
                }
                
                if showingQuestions {
                    questions
                        .padding(25)
                }
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("Restart") {
                    restart()
                }
            } message: {
                Text(alertMessage)
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        isFocused = false
                    }
                }
            }
        }
    }
    
    func increaseQuestions() {
        if let index = choices.firstIndex(of: numberOfQuestions) {
            if index == choices.count - 1 {
                // do nothing
            } else {
                numberOfQuestions = choices[index + 1]
            }
        }
    }
    
    func decreasQuesions() {
        if let index = choices.firstIndex(of: numberOfQuestions) {
            if index == 0 {
                // do nothing
            } else {
                numberOfQuestions = choices[index - 1]
            }
        }
    }
    
    func hideHome() {
        withAnimation {
            showingHome = false
        }
    }
    
    func showHome() {
        withAnimation {
            showingHome = true
        }
    }
    
    func showTableChoice() {
        withAnimation {
            showingTableChoice = true
        }
    }
    
    func hideTableChoice() {
        withAnimation {
            showingTableChoice = false
        }
    }
    
    func showNumberOfQuestions() {
        withAnimation {
            showingNumberOfQuestions = true
        }
    }
    
    func hideNumberOfQuestions() {
        withAnimation {
            showingNumberOfQuestions = false
        }
    }
    
    func showQuestions() {
        withAnimation {
            showingQuestions = true
        }
    }
    
    func hideQuestions() {
        withAnimation {
            showingQuestions = false
        }
    }
    
    func start() {
        numbers = (1...numberOfQuestions).map( { _ in Int.random(in: 1...10) })
        hideNumberOfQuestions()
        showQuestions()
    }
    
    func checkAnswer() {
        if answer == correctAnswer {
            score += 1
            withAnimation {
                shouldSpin.toggle()
            }
        } else {
            withAnimation {
                shouldJerk.toggle()
            }
        }
        
        if index != numberOfQuestions - 1 {
            withAnimation(.easeIn) {
                index += 1
            }
        } else {
            alertTitle = "Game Over"
            alertMessage = "You have answered \(score) questions correctly!"
            showingAlert = true
        }
    }
    
    func restart() {
        selected = nil
        numberOfQuestions = 5
        index = 0
        numbers = []
        answer = 0
        score = 0
        shouldJerk = false
        shouldSpin = false
        
        hideQuestions()
        showHome()
    }
}

struct Selection {
    static func getOpacity(of table: Int, when selected: Int?) -> Double {
        guard let selected else {
            return 1.0
        }
        
        if selected == table {
            return 1.0
        } else {
            return 0.5
        }
    }
    
    static func shouldScale(table: Int, when selected: Int?) -> Bool {
        if let selected {
            return selected == table
        } else {
            return false
        }
    }
}

#Preview {
    ContentView()
}
