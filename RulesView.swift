import SwiftUI

struct RulesView: View {
  //  @EnvironmentObject var soundSettings: SoundSettings
    
    @State private var playerName: String = ""
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Spacer()
//                    Button(action: {
//                        soundSettings.isSoundEnabled.toggle()
//                        if soundSettings.isSoundEnabled {
//                            SoundManager.shared.playBackgroundMusic(name: "backgroundmusic")
//                        } else {
//                            SoundManager.shared.stopBackgroundMusic()
//                        }
//                    }) {
//                        Image(systemName: soundSettings.isSoundEnabled ? "speaker.wave.3.fill" : "speaker.slash.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 25, height: 25)
//                            .foregroundColor(.white)
//                            .padding()
//                            .background(Color.blue)
//                            .clipShape(Circle())
//                    }
//                    .padding([.top, .trailing], 20)
                }
                
                // The rest of your view
                VStack {
                    Image("gamerulesimage")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300, maxHeight: 120)
                    
                    
                    Group {
                        Text("As Earth reaches out to the cosmos, you, as humanity's envoy, have the unique opportunity to shape a future where humans and aliens thrive together. Your decisions in resource exchanges will pave the way towards a universal ethos of equality and shared prosperity.")
                            .padding()
                       
                        //   .padding()
                        Text("Each alien species presents a unique challenge, requiring a thoughtful approach to resource sharing. Your decisions will shape the outcome of humanity's interstellar relationships, aiming for an equitable and prosperous alliance. This game is a classical representation of Prisoner's Dilemma from Game theory ")
                            .padding()
                    }
                    .foregroundColor(.black)
                    .font(.system(size: 18))
                    
                    // Rules in Detail
                    VStack(alignment: .leading, spacing: 10) {
                        RuleView(number: "1.circle", text: "Equal exchanges with aliens solidify trust and understanding, benefiting both sides (+2 points each).")
                        RuleView(number: "2.circle", text: "Withholding resources from one creates imbalance; the defector gains (+3), the cooperator loses (-1).")
                        RuleView(number: "3.circle", text: "Withholding resources from both sides stunts growth and prosperity yeilding no (0 points).")
                        RuleView(number: "4.circle", text: "Compete in 3-7 rounds across 5 matches against distinct alien strategies")

                        
                    }
                    .padding()
                    .cornerRadius(10)
                    .font(.system(size: 18))
                    .padding()
                    
                    // Player Name Entry
                    TextField("Enter your name:", text: $playerName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(width: 300 ,height: 80)
                        .background(Color.white)
                        .cornerRadius(40)
                    
                    // Proceed Button
                    NavigationLink(destination: GameView(playerName: playerName).background(Color.white)) {
                        Text("Proceed to Game")
                            .foregroundColor(.white)
                            .padding()
                            .background(playerName.isEmpty ? Color.black : Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(playerName.isEmpty)
                }
                .padding(.horizontal)
            }
        }
    }
}

// Helper view for displaying rules
struct RuleView: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: number)
                .foregroundColor(.blue)
                .font(.system(size: 34))
                .bold()
            Text(text)
                .foregroundColor(.black)
        }
    }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        RulesView()
            //.environmentObject(SoundSettings())
    }
}
