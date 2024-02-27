import SwiftUI

struct WelcomeView: View {
    @State private var frameIndex = 1
    let totalFrameCount = 78
    let animationTimeInterval = 0.05 
    
   // @EnvironmentObject var soundSettings: SoundSettings


    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
                    VStack {
                Image("trustlayers-\(frameIndex)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .offset(y: -30)
                    .onAppear {
                        
                        for index in 1...totalFrameCount {
                            DispatchQueue.main.asyncAfter(deadline: .now() + animationTimeInterval * Double(index)) {
                                self.frameIndex = index
                            }
                        }
                    }
             
                        NavigationLink(destination: IntroductionView()) {
                       Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                        .padding()
                }
                       
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            //.environmentObject(SoundSettings()) 
    }
}
