import SwiftUI
import Charts
import SwiftData


struct Manyroundsdata : Identifiable{
    
    var id = UUID().uuidString
    var strategy : String
    var points : Int
} 


struct Piechartdata : Identifiable {
    
    var id = UUID().uuidString
    var strategy : String
    var population : Int
}


struct ConclusionView: View {
    let playerName: String
    let humanscore: Int
    let alienscore: Int
    var gameSession: GameSession 
    

    
    @Query(sort: \PlayerScore.humanScore, order: .reverse) private var scores: [PlayerScore]

    
    var data = [
        Manyroundsdata(
            strategy: "Tit for Tat", points: 554
        ),
        Manyroundsdata(
            strategy: "Tideman & cheiruzzi ", points: 500
        ),
        Manyroundsdata(
            strategy: "nydeggar", points: 486
        ) ,
        Manyroundsdata(
            strategy: "Friedman", points: 473
        ),
        Manyroundsdata(
            strategy: " Defect", points: 320
        ),
               Manyroundsdata(
            strategy: " Cooperate", points: 300
               ),
    
        Manyroundsdata(
            strategy: "Name withheld", points: 282
        ),
        
        Manyroundsdata(
            strategy: "Random", points: 276
        )
   
       
    ]
    
    @State private var piedata = [
        Piechartdata(strategy: "Tit for Tat", population: 10),
        Piechartdata(strategy: "Nasty Strategies", population: 90)
    ]
    
    @State private var animateGrowth = false
    
    
    func animateGrowthAutomatically() {
        // Setup a timer to periodically update the data for animation
        Timer.scheduledTimer(withTimeInterval: 7.0, repeats: true) { timer in
            if let index = piedata.firstIndex(where: { $0.strategy == "Tit for Tat" }) {
                withAnimation(.easeInOut(duration: 1.0)) { 
                    piedata[index].population += 30 
                }
                animateGrowth.toggle()
            }
        }
    }
    
    var body: some View {
        //    @Query private var scoreentries :[ScoreEntry]
        
        
        ZStack{
            Color.white.edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing: 30) {
                    
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(height: 250)
                        .cornerRadius(12)
                        .shadow(radius: 8)
                        .overlay(
                            HStack{
                                Rectangle()
                                    .foregroundColor(.black)
                                    .frame(height: 200)
                                    .cornerRadius(12)
                                    .shadow(radius: 8)
                                    .overlay(
                                        VStack(spacing: 10) { // Added spacing
                                            Image(systemName: "star.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 20)
                                                .foregroundColor(.orange)
                                            Text("Game   Over")
                                                .font(.headline)
                                                .foregroundColor(.white)
                                                .fontWeight(.bold)
                                            HStack { // Adjusted spacing
                                                Text("hereis ")
                                                    .foregroundColor(.black)
                                                Text("\(playerName) : \(humanscore)")
                                                    .foregroundColor(.green)
                                                    .font(.system(size: 20, weight: .bold))
                                                 Text("-")
                                                    .bold()
                                                Text("Alien : \(alienscore)")
                                                    .foregroundColor(.green)
                                                    .font(.system(size: 20, weight: .bold))
                                                Button(action: {
                                                     gameSession.restartGame()
                                                    // resetView()
                                                }) {
                                                    Image(systemName: "arrow.clockwise.circle.fill")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 60, height: 60)
                                                        .foregroundColor(.blue)
                                                        .padding()
                                                }
                                                
                                               
                                            }
                                        }
                                            .padding() 
                                        
                                        
                                        
                                        
                                    )                          
                                
                                
                                Rectangle()
                                    .foregroundColor(.black)
                                    .frame( height: 200)
                                    .cornerRadius(12)
                                    .overlay(
                                        VStack {
                                            Text("")
                                            Text("Scoreboard")
                                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                            .bold()
                                            List {
                                                ForEach (scores) { s in
                                                    HStack {
                                                        Text(s.playerName)
                                                        Spacer()
                                                        Text("Human: \(s.humanScore)")
                                                        Spacer()
                                                        Text("Alien: \(s.alienScore)")
                                                    }
                                                }
                                                .onDelete { indexes in
                                                    for index in indexes {
                                                        deleteItem(scores[index])
                                                    }
                                                    
                                                }

                                            }
                                                                 
                                        }
                                            )  
                                            
                                        } 
                                    )
                                

                                
                                Rectangle()
                                    .foregroundColor(.white)
                                    .frame( height: 440)
                                    .cornerRadius(12)
                                    .shadow(radius: 8)
                                    .overlay(
                                        HStack (spacing:10){
                                            VStack (spacing: 15){
                                                
                                                Rectangle()
                                                    .foregroundColor(.black)
                                                    .frame( height: 200)
                                                    .cornerRadius(12)
                                                    .overlay(
                                                        VStack (spacing:20){
                                                            
                                                            Text("These are the five different aliens with different strategies you played  ").foregroundColor(.orange)
                                                                .bold()
                                                                .font(.system(size: 18))
                                                            
                                                            
                                                        }
                                                            .padding()
                                                    )
                                                
                                                Rectangle()
                                                    .foregroundColor(.black)
                                                    .frame( height: 200)
                                                    .cornerRadius(12)
                                                    .overlay(
                                                        VStack (spacing:-12){
                                                            Text("Tit for Tat").foregroundColor(.blue)
                                                            Image("titfortaconimage")
                                                                .resizable()
                                                                .frame(width: 120, height: 120)
                                                            
                                                            Text("First cooperate and then copies you, nice and retaliatory").foregroundColor(.white)
                                                            
                                                        }
                                                    )
                                                
                                                
                                            }
                                            VStack (spacing: 15){
                                                
                                                Rectangle()
                                                    .foregroundColor(.black)
                                                    .frame( height: 200)
                                                    .cornerRadius(12)
                                                    .overlay(
                                                        VStack (spacing:-12){
                                                            Text("Always Cooperate").foregroundColor(.blue)
                                                            Image("alwayscooperatealien1")
                                                                .resizable()
                                                                .frame(width: 120, height: 120)
                                                            
                                                            Text("Always cooperates, too leninet being overly cooperative explioted by others").foregroundColor(.white)
                                                            
                                                        }
                                                    )
                                                
                                                
                                                Rectangle()
                                                    .foregroundColor(.black)
                                                    .frame( height: 200)
                                                    .cornerRadius(12)
                                                    .overlay(
                                                        VStack (spacing:-12){
                                                            Text("Always Defect").foregroundColor(.blue)
                                                            Image("alwayscheatalien1")
                                                                .resizable()
                                                                .frame(width: 120, height: 120)
                                                            
                                                            Text("shows how constant defection from one side can lead to suboptimal outcomes for both  ").foregroundColor(.white)
                                                            
                                                        }
                                                    )
                                                
                                                
                                            }
                                            
                                            VStack (spacing: 15){
                                                
                                                Rectangle()
                                                    .foregroundColor(.black)
                                                    .frame( height: 200)
                                                    .cornerRadius(12)
                                                    .overlay(
                                                        VStack (spacing:-10){
                                                            Text("Friedman").foregroundColor(.blue)
                                                            Image("friedmanalien1")
                                                                .resizable()
                                                                .frame(width: 120, height: 120)
                                                            
                                                            Text("Starts with cooperating until you cheat first, holds grudges against you").foregroundColor(.white)
                                                            
                                                        }
                                                    )
                                                Rectangle()
                                                    .foregroundColor(.black)
                                                    .frame( height: 200)
                                                    .cornerRadius(12)
                                                    .overlay(
                                                        VStack (spacing:-12){
                                                            Text("Sneaky").foregroundColor(.blue)
                                                            Image("sneakyalien1")
                                                                .resizable()
                                                                .frame(width: 120, height: 120)
                                                            
                                                            Text(" Sneaky starts cooperative but tries to probe opponent's strategy, adapting actions").foregroundColor(.white)
                                                            
                                                        }
                                                    )
                                                
                                                
                                            }
                                        } .padding()
                                    )
                                
                                
                                Rectangle()
                                    .foregroundColor(.white)
                                    .frame(height: 250)
                                    .cornerRadius(12)
                                    .shadow(radius: 8)
                                    .overlay(
                                        HStack{
                                            Rectangle()
                                                .foregroundColor(.black)
                                                .frame( height: 200)
                                                .cornerRadius(12)
                                                .overlay(
                                                    VStack (spacing:20){
                                                        Text("Most of the Life is non zero sum game").foregroundColor(.green)
                                                            .bold()
                                                            .font(.system(size: 18)) +
                                                        Text(" which means you dont have to gain from others to win you can both cooperate or get the same thing from somewhere else, and we keep playing repeated games with opponents ,this is where tit for tat strategy keeps shining as the number of rounds increases")
                                                        .foregroundColor(.white)
                                                        .bold()
                                                        .font(.system(size: 18))
                                                        
                                                    }
                                                        .padding()
                                                )                            
                                            
                                            
                                            Rectangle()
                                                .foregroundColor(.black)
                                                .frame( height: 200)
                                                .cornerRadius(12)
                                                .overlay(
                                                    VStack {
                                                        Chart {
                                                            ForEach(data) { d in
                                                                BarMark(
                                                                    x: .value("Strategy", d.strategy),
                                                                    y: .value("Points", d.points)
                                                                )
                                                            }
                                                        }.padding()
                                                    }
                                                )  
                                            
                                        } 
                                    )
                                
                                
                                Rectangle()
                                    .foregroundColor(.white)
                                    .frame(height: 250)
                                    .cornerRadius(12)
                                    .shadow(radius: 8)
                                    .overlay(
                                        HStack{
                                            Rectangle()
                                                .foregroundColor(.black)
                                                .frame( height: 220)
                                                .cornerRadius(12)
                                                .overlay(
                                                    VStack (spacing:20){
                                                        Text("Imagine a world populated with nasty players (who defect first) except a small cluster of tit for tat players who get to play with each other, they will start gaining rewards and eventually take over the population. Sometimes you dont have to be altruistic you can only look out for your self ").foregroundColor(.white)
                                                            .bold()
                                                            .font(.system(size: 18)) +
                                                        Text(" but cooperation will still emerge as evolution carved out a hidden code that rewards genuine cooperation")
                                                            .foregroundColor(.purple)
                                                            .bold()
                                                            .font(.system(size: 18))
                                                        
                                                        
                                                    }
                                                        .padding()
                                                )                            
                                            
                                            
                                            Rectangle()
                                                .foregroundColor(.black)
                                                .frame( height: 220)
                                                .cornerRadius(12)
                                                .overlay(
                                                    VStack {
                                                        Chart {
                                                            ForEach(piedata) { d in
                                                                
                                                                SectorMark(angle: .value("Population", d.population),
                                                                           angularInset: 1)
                                                                .foregroundStyle(by: .value("Strategy",d.strategy))
                                                                .annotation(position: .overlay){
                                                                    Text("\(d.strategy)")
                                                                        .font(.headline)
                                                                        .foregroundStyle(.white)
                                                                }
                                                            }
                                                        }.padding()
                                                                                                        .onAppear {
                                                                                                            animateGrowthAutomatically()
                                                                                                        }
                                                        
                                                    }
                                                )  
                                            
                                        } 
                                    )
                                
                                Rectangle()
                                    .foregroundColor(.black)
                                    .frame(height: 300)
                                    .cornerRadius(12)
                                    .shadow(radius: 8)
                                    .overlay(
                                        VStack (spacing: 2) {
                                            Text("These are the four fundamental principles derived from game theory that we can glean from this particular game  ").foregroundColor(.white).bold().font(.system(size: 18))
                                            Text("1.Be Nice  ").foregroundColor(.blue) .bold().font(.system(size: 18))
                                            Text("Dont be the first to defect ").foregroundColor(.white)
                                            Text("2.Be Forgiving ").foregroundColor(.blue) .bold().font(.system(size: 18))
                                            Text("Forgiveness can prevent retaliatory cycles ").foregroundColor(.white)
                                            Text("(when titfortat alien sneezed and defected by mistake)").foregroundColor(.white)
                                            Text("3.Be Retaliatory").foregroundColor(.blue) .bold().font(.system(size: 18))
                                            Text("Be nice but dont be a pushover, retaliate when required").foregroundColor(.white)
                                            Text("4.Be Clear").foregroundColor(.blue) .bold().font(.system(size: 18))
                                            Text("Clarity prevents misunderstandings").foregroundColor(.white)
                                            Text("(Not cooperating to share language in the first round)").foregroundColor(.white)
                                        }
                                    )
                                
                                // Second Rectangle
                                Rectangle()
                                    .foregroundColor(.black)
                                    .frame( height: 390)
                                    .cornerRadius(12)
                                    .overlay(
                                        VStack (spacing:20){
                                            
                                            Text("As I conclude this game, it becomes apparent that game theory serves as a powerful lens through which we can understand human interaction and societal progress. From the strategies employed to navigate challenges to the cooperation necessary for advancement, we see echoes of our collective journey as a species.From the earliest civilizations to our modern interconnected world, humans have continuously utilized cooperation and strategic thinking to overcome obstacles and thrive. The resources and challenges presented in this game serve as a poignant reflection of our storied history of human development and technological advancements  ").foregroundColor(.white)
                                                .bold()
                                                .font(.system(size: 18))
                                            
                                            Text(" Perhaps, by understanding these principles deeply, we may one day transcend the Fermi Paradox and encounter extraterrestrial civilizations. And if we do, let us approach them with the same spirit of cooperation and mutual benefit that has propelled us thus far. In essence, this game is not just about competing for resources; it's a reflection of our innate drive to cooperate, innovate, and prosper. May we continue to evolve as human beings, forging a future where cooperation and progress go hand in hand. ").foregroundColor(.white)
                                                .bold()
                                                .font(.system(size: 18))
                                            
                                        }
                                            .padding()
                                    )  
                                
                                // Third Rectangle
                    Rectangle()
                        .foregroundColor(.black)
                        .frame(height: 200)
                        .cornerRadius(12)
                        .overlay(
                            VStack(spacing: 20) {
                                Text("References")
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .fontWeight(.bold)
                                
                                Text("I drew inspiration from Veritasium's enlightening youtube video, which brilliantly explores the topic:")
                                    .foregroundColor(.orange)
                                    .multilineTextAlignment(.center)
                                
                                Text("The Evolution of Trust by Nicky Case")
                                    .foregroundColor(.orange)
                                
                                Text("Additionally, Axelrod's seminal work 'The Evolution of Cooperation' provided invaluable insights into game theory:")
                                    .foregroundColor(.orange)
                                    .font(.system(size: 16))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                                .padding()
                        )

                                
                                
                                
                            }
                            
                         
                            
                                .padding()
                            }
                                .background(Color.gray.opacity(0.1)) 
                            }
                            }
                            }


                            
func deleteItem(_ score: PlayerScore){
 //   context.delete(score)
}
   
                            
 struct ConclusionView_Previews: PreviewProvider {
        static var previews: some View {
         ConclusionView(playerName: "Human", humanscore: 30, alienscore: 30, gameSession: GameSession())
                                }
                            }
