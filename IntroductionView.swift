import SwiftUI

struct IntroductionView: View {
 //   @EnvironmentObject var soundSettings: SoundSettings
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                HStack(spacing: 15) {
                    Text("What is")
                        .font(.title)
                        .foregroundColor(.black)
                    
                    Image("trusthires")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 90)
                    
                    Text("?")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .padding()
                
                Text("Trust is a fundamental aspect of human relationships and societal structures, evolving significantly from the era of hunter-gatherers to the complex societies we live in today. It's a mechanism for reducing complexity in social interactions, allowing individuals and groups to collaborate, share resources, and build communities. However, the decision to trust is fraught with complexity and risk, particularly in competitive or uncertain environments.")
                    .padding()
                    .foregroundColor(.black)
                    .font(.system(size: 18))
                
                NavigationLink(destination: RulesView().background(Color.white)) {
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                        .padding()
                } .onAppear{
                    SoundManager.shared.playBackgroundMusic(name: "backgroundmusic")
                }
                
                Spacer()
            }
            
            VStack {
                HStack {
                    Spacer() 
//                    Button(action: {
//                        soundSettings.isSoundEnabled.toggle()
//                        
//                        if soundSettings.isSoundEnabled {
//                            SoundManager.shared.playBackgroundMusic(name: "backgroundmusic")
//                        } else {
//                            SoundManager.shared.stopBackgroundMusic()
//                        }
//                    }
//                    ) {
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
                Spacer() 
            }
        }
        .navigationBarTitle("Introduction", displayMode: .inline)
    }
}

struct IntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        IntroductionView()
            //.environmentObject(SoundSettings())
    }
}
