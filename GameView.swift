
import SwiftUI
import SwiftData
import AVFoundation 

struct GameView: View {
    
    
    @Environment(\.modelContext) private var context
    
    var playerName: String
    
    @State private var isResourceViewRendered = false

    
    @State private var eventAlienImage: String? = nil
    
    @State private var showMatchEndOverlay = false
    @ObservedObject private var soundSettings = SoundSettings() 
    
    @StateObject private var gameSession = GameSession()
    let womanImages = ["woman1","woman3","woman2"] 
    let alienImageSets = [
        ["alwayscooperatealien1", "alwayscooperatealien2","alwayscooperatealien3"],
        ["titfortatalien1", "titfortatalien2","titfortatalien3"],
        ["alwayscheatalien1", "alwayscheatalien2","alwayscheatalien3"],
        ["friedmanalien1", "friedmanalien2","friedmanalien3"],
        ["sneakyalien1", "sneakyalien2","sneakyalien3"],
    ]
    
    @State private var currentWomanImageIndex = 0
    @State private var currentAlienImageIndex = 0
    @State private var currentGraph: String = "chartfirst" 
    @State private var floatingOffset: CGFloat = 0
    @State private var showLeaderboard = false
    @State private var isBlinkingImage = false
    @State private var alienState: AlienState = .normal
    @State private var alienType: AlienType = .titfortat
    
    
    var body: some View {
        
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            if gameSession.matchCount < 5 {
                VStack {
                    
                    
                    Text("Match: \(gameSession.matchCount+1)").foregroundColor(.white).padding(.bottom, -25) .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold()
                    HStack {
                        Spacer()
                        if (!gameSession.hasCooperatedInLanguageRound  && gameSession.currentRound > 1 && gameSession.matchCount < 1){
                            VStack{
                                Text("1.  Clear communication is paramount ,Shall we begin anew with positive affirmations?").foregroundColor(.blue)
                                    .bold()
                            }   .frame(width: 620, height: 42, alignment: .center)
                                .background(Color.white) 
                                .cornerRadius(10)
                                .padding()
                                .offset(x:-70)
                                .font(.system(size: 14))
                            
                        }
                        
                        Button(action: toggleSound) {
                            Image(systemName: soundSettings.isSoundEnabled ? "speaker.wave.3.fill" : "speaker.slash.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        .padding(.trailing, -5)
                                    
                        
                        Button(action: {
                            gameSession.restartGame()
                            resetView()
                        })
                        {
                            Image(systemName: "arrow.clockwise.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.white)
                                .padding()
                        } .offset(x: -165, y: 0) 
                        
                    }
                    .padding(.bottom, -35) 
                    
                    HStack  {
                        //  Text("Round: \(gameSession.currentRound)").foregroundColor(.white)
                        Text("\(playerName) : \(gameSession.humanPoints)").foregroundColor(.green)
                            .font(.system(size: 40, weight: .bold))
                            .frame(width: 290, alignment: .leading) 
                        Text("|").foregroundColor(.black).font(.system(size: 40, weight: .bold))
                        Text("           Alien : \(gameSession.alienPoints)").foregroundColor(.green).font(.system(size: 40, weight: .bold))
                        //   Text("Alien Strategy: \(gameSession.currentAlienType.rawValue)").foregroundColor(.white)
                            .frame(width: 290, alignment: .leading) 
                    }
                    
                    //                    ScrollView(.horizontal){
                    HStack (spacing :560){
                        if !gameSession.humanResources.isEmpty {
                            let humanResource = gameSession.humanResources[gameSession.currentHumanResourceIndex]
                            ResourceView(resource: humanResource, foregroundColor: .green, backgroundColor: .black)
                            
                        }
                        //  Spacer()
                        if !gameSession.alienResources.isEmpty {
                            
                            
                            let alienimage = gameSession.alienResources[gameSession.currentAlienResourceIndex].imageName
                            let alienResource = gameSession.alienResources[gameSession.currentAlienResourceIndex]
                            let alienResourceName = gameSession.hasCooperatedInLanguageRound ? alienResource.name : gameSession.aliengibberishResources[gameSession.currentAlienResourceIndex].name
                            let alienResourceAbout = gameSession.hasCooperatedInLanguageRound ? alienResource.about : gameSession.aliengibberishResources[gameSession.currentAlienResourceIndex].about
                            
                            let displayResource = Resource(name: alienResourceName, category: alienResource.category, about: alienResourceAbout, id: alienResource.id, imageName: alienimage )
                            ResourceView(resource: displayResource, foregroundColor: .green, backgroundColor: .black)
                        }
                        
                        
                    }
                    
                    
                    .padding()
                    
                    HStack(spacing: 90)  {
                        
                        Image(womanImages[currentWomanImageIndex])
                            .resizable()
                            .scaledToFit()
                            .frame(width:280)
                            .offset(y: floatingOffset)
                            .offset(x:70,y:0)
                            .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true), value: floatingOffset)
                            .onAppear {
                                floatingOffset = 10
                                Timer.scheduledTimer(withTimeInterval:2, repeats: true) { _ in
                                    withAnimation {
                                        self.currentWomanImageIndex = (self.currentWomanImageIndex + 1) % self.womanImages.count
                                    }
                                }
                                
                            }
                        
                        
                    
                        
                        Image(currentGraph)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400)
                            .offset(x:-10,y:-100)
                            .overlay(matchEndOverlay())

                            
                     
                     
           
                        Image(eventAlienImage ?? getCurrentAlienImages()[currentAlienImageIndex])
                            .resizable()
                            .scaledToFit()
                            .frame(width:290)
                        
                            .offset(x:-80,y:0)
                         .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: currentAlienImageIndex)
                            .onAppear {
                                // Set up the timer for cycling through images
                                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                    withAnimation {
                                        // Update image index to cycle through the current set
                                        self.currentAlienImageIndex = (self.currentAlienImageIndex + 1) % getCurrentAlienImages().count
                                    }
                                }
                            }
                        
                        
                    }
                    
                    VStack {
                        HStack(spacing: 130) { 
                            Button(action: {
                                playRoundWithAction(.cooperate)
                            }) {
                                Text("Cooperate")
                                    .frame(minWidth: 0, maxWidth: .infinity) 
                                    .padding() 
                                    .background(Color.blue) 
                                    .foregroundColor(.white) 
                                    .cornerRadius(5)
                                    .bold() 
                                
                            }
                            .frame(width: 140,height: 20 ) 
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            .bold()
                            
                            
                            Button(action: {
                                playRoundWithAction(.cheat)
                            }) {
                                Text("Defect")
                                    .frame(minWidth: 0, maxWidth: .infinity) 
                                    .padding() 
                                    .background(Color.blue) 
                                    .foregroundColor(.white) 
                                    .cornerRadius(5) 
                                    .bold() 
                            }
                            .frame(width: 140,height: 20 ) 
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            .bold()
                        }
                        .offset(y:-30)
                        // .padding(.horizontal) 
                    }
                    .frame(maxWidth: .infinity) 
                }
                
            } else {
                
                ConclusionView(playerName: playerName, humanscore: gameSession.humanPoints, alienscore: gameSession.alienPoints, gameSession: gameSession)
                
            }
            
        }
    }
    
    func saveScore() {
        
            let score = PlayerScore(playerName: playerName, humanScore: gameSession.humanPoints, alienScore: gameSession.alienPoints)
        
        context.insert(score)
        
        do {
            try context.save()
            print("Test data inserted successfully.")
        } catch {
            print("Failed to save test data: \(error)")
        }
    }
    
    
    
    //    func deleteScore(_ score : ScoreEntry){
    //        context.delete(score)
    //    }
    
    private func triggerAlienEventImage(imageName: String) {
        eventAlienImage = imageName
        // Set a timer to clear the event image after 2 seconds
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            withAnimation {
                self.eventAlienImage = nil
            }
        }
    }
    
    private func toggleSound() {
        soundSettings.isSoundEnabled.toggle()
        if soundSettings.isSoundEnabled {
            SoundManager.shared.playBackgroundMusic(name: "backgroundmusic")
        } else {
            SoundManager.shared.stopBackgroundMusic()
        }
    }

    
    
    private func getCurrentAlienImages() -> [String] {
        let index = min(gameSession.matchCount, alienImageSets.count - 1)
        return alienImageSets[index]
    }
    
    private func playRoundWithAction(_ action: Action) {
        SoundManager.shared.playSoundEffect(name: "clicksound")
        gameSession.playRound(humanAction: action)
        
        //        if  gameSession.matchCount == 0 && gameSession.currentRound == 1 &&
        //            gameSession.hasCooperatedInLanguageRound == false && action == .cooperate {
        //            triggerAlienEventImage(imageName: "languageRoundFlag")
        //        }
        
        if  gameSession.matchCount == 1 && gameSession.currentRound == 3  {
            print(gameSession.matchCount)
            print(gameSession.currentRound)
            triggerAlienEventImage(imageName: "sneezu")
            SoundManager.shared.playSoundEffect(name: "sneeze")
            
            
            
        }
        
        if gameSession.currentRound > gameSession.totalRounds {
            showMatchEndOverlay = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.showMatchEndOverlay = false
            }
        }
        
        
        if gameSession.matchCount == 5   {
            // Save the score here
            print(gameSession.matchCount)
            print(gameSession.isLastRoundOfCurrentMatch())
            print("im pribtibg is its saving")
            
            saveScore()
        }
        
        
        self.updateGraphImage()
        
        
    }
    
    private func resetView() {
        currentWomanImageIndex = 0
        currentGraph = "chartfirst"
    }
    
    func matchEndOverlay() -> some View {
        Group {
            if showMatchEndOverlay {
                Rectangle()
                    .foregroundColor(.white) 
                    .frame(width: 400, height: 300)
                    .cornerRadius(12)
                    .overlay(
                        VStack(spacing: 10) {
                            Text("Match")
                                .foregroundColor(.blue)
                                .font(.system(size: 60))
                            Text("\(gameSession.matchCount+1)")
                                .foregroundColor(.black)
                               .font(.system(size: 40))
                               .bold()
                           
                        }
                    ).offset(y: -80)
            }
        }
    }


    
    
    private func updateGraphImage() {
        if let lastHumanAction = gameSession.lastHumanAction, let lastAlienAction = gameSession.lastAlienAction {
            switch (lastHumanAction, lastAlienAction) {
            case (.cooperate, .cooperate):
                currentGraph = "bothcooperate"
            case (.cheat, .cooperate):
                currentGraph = "humancheat"
            case (.cooperate, .cheat):
                currentGraph = "aliencheat"
            case (.cheat, .cheat):
                currentGraph = "bothcheat"
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { 
                self.currentGraph = "chartfirst"
            }
            
        } 
    }
}

extension AlienType: CustomStringConvertible {
    var description: String {
        switch self {
        case .titfortat: return "Tit for Tat"
        case .alwaysCooperate: return "Always Cooperate"
        case .alwaysdefect: return "Always Defect"
        case .friedman: return "Friedman"
        case .sneaky: return "Sneaky"
        }
    }
}



struct ResourceView: View {
    let resource: Resource
    let foregroundColor: Color
    let backgroundColor: Color
    @State private var isAlternateImage = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() 
    
    var body: some View {
        VStack(alignment: .leading) {
            
            
            Text(resource.name)
                .font(.headline)
                .foregroundColor(.white) 
                .frame(maxWidth: .infinity) 
                .lineLimit(5) 
            
            
            
            Text(resource.about)
                .font(.caption)
                .foregroundColor(foregroundColor) 
                .lineLimit(5) 
                .padding(.bottom, -25) 
            
            Image(isAlternateImage ? "\(resource.imageName)2" : resource.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .offset(x:20 ,y:10)
                .background(Color.clear) 
            
                .onReceive(timer) { _ in
                    withAnimation {
                        isAlternateImage.toggle()
                    }
                }
        }
        .padding([.horizontal, .top])
        .frame(width: 200, height: 205, alignment: .center) 
        .background(backgroundColor)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 1.2) 
        )
        .onAppear {
            _ = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
                withAnimation {
                    self.isAlternateImage.toggle()
                }
            }
          
        }
    }
}



struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(playerName: "human")
        //.environmentObject(SoundSettings())
        
    }
}




