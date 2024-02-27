import SwiftUI
import AVFoundation



struct Resource: Equatable, Hashable {
    let name: String
    let category: Category
    let about: String
    let id: Int
    let imageName: String
}


enum Category: String, CaseIterable {
    case technology = "Technology Resources"
    case natural = "Natural Resources"
    case knowledge = "Knowledge and Information"
    case food = "Food and Nutrition"
    case environment = "Environment and Habitat"
}


enum AlienType: String, CaseIterable{
    case alwaysCooperate = "Always Cooperate" // too leninet being overly cooperative explioted by others
    case titfortat = "Tit for Tat"  //first cooperate and then copies you, nice and retaliatory
    case alwaysdefect = "Always Defect" //how constant defection from one side can lead to suboptimal outcomes for both parties
    case friedman = "Friedman" // "holds grudges against you."
    case sneaky = "Sneaky" //sneaky starts cooperative but tries to probe the opponent's strategy, adapting its actions accordingly
}


enum AlienState {
    case normal
    case cheated
    case sad
}


struct GameOutcome {
    let humanPoints: Int
    let alienPoints: Int
}


enum Action {
    case cooperate
    case cheat
}


class GameSession: ObservableObject {
    @Published var humanPoints = 0
    @Published var alienPoints = 0
    @Published var currentRound = 1
    @Published var matchCount = 0 
    @Published var currentHumanResourceIndex = 0
    @Published var currentAlienResourceIndex = 0
    var hasHumanCheatedFriedmanThisMatch :Bool = false
    var istitfortatFirstMove = true
     var totalRounds: Int = Int.random(in: 3...7)
  //  var totalRounds: Int = 7
    var currentAlienType: AlienType = .alwaysCooperate
    var hasHumanCheated = false
    var lastHumanAction: Action? = nil
    var lastAlienAction: Action? = nil
    var startCheatingNextRoundFriedman: Bool = false
    var hasCooperatedInLanguageRound = false
    
    var hasHumanCheatedsneaky = false
    
    
    var humanResources: [Resource] = [
        // Add your human resources here
        Resource(name: "Earth Languages", category: .technology, about: "About 7,100 languages evolved from thousands of years of Human history reflecting the rich diversity of human culture", id :1, imageName: "Earth Languages"),
        Resource(name: "CRISPR Gene Editing", category: .technology, about: "Revolutionary bitechbological tool that allows for precise alteration to an organism's DNA, enabling modification of genetic defects", id:3, imageName: "CRISPR Gene Editing"),
        Resource(name: "Quantum Computers", category: .technology, about: "Advanced computing systems that leverage quantum mechanics to process information at unattainable speeds",id : 4, imageName:"Quantum Computers"),
        Resource(name: "Reusable Rockets", category: .technology, about: "Rockets developed to lower cost of access to space, can land back on planet after launch and be reused for future flights " ,id: 2, imageName:"Reusable Rockets" ),
        Resource(name: "3D Printers", category: .technology, about: "Also known as Additive manufacturing, can create complex 3-dimensional objects from a digital file, used in healthcare, automotive and construction",id: 5, imageName: "3D Printers"),
        Resource(name: "Artificial Intelligence", category: .technology, about: "Simulation of human intelligence with computer systems using Machine learning and decision-making algorithms",id: 6, imageName:"Artificial Intelligence"),
        Resource(name: "Nanotechnology", category: .technology, about: "Involves manipulating materials on an atomic scale, typically within the range of 1 to 100 nanometers", id: 7, imageName:"Nanotechnology"),
        
        
        Resource(name: "Spatial Computing", category: .knowledge, about: "Digital technology that uses the physical around us a medium to interact with software and devices ", id:17, imageName:"Spatial Computing"),
        Resource(name: "Blockchain Technology", category: .knowledge, about: "Decentralized, immutable ledger sytem facilitating secure and transparent digital transactions ", id:16, imageName:"Blockchain Technology"),
        Resource(name: "Renewable Energy", category: .natural, about: "Sustainable sources of power, such as wind, solar that are naturally replenished and having minimal impact to environment", id :11, imageName:"Renewable Energy"),
         Resource(name: "Global Positioning System (GPS)", category: .knowledge, about: "Satellite based navigation sytem that provides location and time information anywhere on planet", id:18, imageName:"Global Positioning System (GPS)"),
        
        
        Resource(name: "Carbon Capture", category: .natural, about: "Technologies aimed at reducing carbon dioxide emmision by capturung CO2 from the atmosphere ", id:12, imageName:"Carbon Capture"),

        
        
        
        
        Resource(name: "Geothermal Energy", category: .natural, about: "Sustainable energy from from the foramtion of the planet and radioactive decay", id: 8, imageName:"Geothermal Energy"),
        Resource(name: "Hydroponic Farms", category: .natural, about: "utilize soilless growing techniques to cultivate plants in nutrient-rich water solutions, offering efficient, space-saving, and sustainable agricultural production ", id: 9, imageName:"Hydroponic Farms"),
        Resource(name: "Desalination Technology", category: .natural, about: "converts seawater into fresh water through processes like reverse osmosis, providing essential drinking water in areas with limited freshwater sources" ,id:10, imageName:"Desalination Technology"),
        Resource(name: "Synthetic Biology", category: .natural, about: "involves designing and constructing new biological parts, devices, and systems, or re-designing existing, natural biological systems", id: 13, imageName:"Synthetic Biology"),
        Resource(name: "Water Purification Systems", category: .natural, about: "technologies that treat water to remove contaminants, making it safe for drinking and use in various applications", id: 14, imageName:"Water Purification Systems"),
        

        
        
        Resource(name: "Digital Libraries", category: .knowledge, about: "online collections of digital objects, including texts, images, and multimedia, accessible remotely for education and research", id: 15, imageName:"Digital Libraries"),
        Resource(name: "Internet of Things (IoT)", category: .knowledge, about: "network of physical objects embedded with sensors, software, and other technologies to connect and exchange data with other devices and systems over the internet", id:19, imageName:"Internet of Things (IoT)"),
        Resource(name: "Open-Source Software", category: .knowledge, about: "Freely available and modifiable software infrastructure", id:20, imageName:"Open-Source Software"),
        Resource(name: "Brain-Computer Interfaces", category: .knowledge, about: "technologies that enable direct communication between the human brain and external devices, facilitating control of those devices using thought alone", id:21, imageName:"Brain-Computer Interfaces"),
        
        Resource(name: "Lab-grown Meat", category: .food, about: "Meat produced from cultured cells ", id:22, imageName:"Lab-grown Meat"),
        Resource(name: "Vertical Farms", category: .food, about: "Indoor, layered crop production ", id:23, imageName:"Vertical Farms"),
        Resource(name: "Genetically Modified Organisms", category: .food, about: "Organisms modified for desirable traits ", id:24, imageName:"Genetically Modified Organisms"),
        Resource(name: "Algae-based Foods", category: .food, about: "Nutrient-rich foods from algae", id:25, imageName:"Algae-based Foods"),
        Resource(name: "Precision Fermentation", category: .food, about: "Microorganisms producing specific compounds for food", id:26, imageName:"Precision Fermentation"),
        Resource(name: "Smart Agriculture", category: .food, about: "involves integrating advanced technologies like IoT, AI, and data analytics into farming practices to increase efficiency, productivity, and sustainability ", id:27, imageName:"Smart Agriculture"),
        Resource(name: "Nutrient Fortification", category: .food, about: "process of adding essential vitamins and minerals to food products to enhance their nutritional value and address dietary deficiencies.", id:28, imageName:"humanfood7"),
        
        
        Resource(name: "Green Buildings", category: .environment, about: "Eco-friendly construction using sustainable materials ", id:29, imageName:"Green Buildings"),
        Resource(name: "Ocean Cleanup Projects", category: .environment, about: "Initiatives to remove ocean waste compared ", id:30, imageName:"Ocean Cleanup Projects"),
        Resource(name: "Urban Green Spaces", category: .environment, about: "City areas dedicated to vegetation", id:31, imageName: "Urban Green Spaces"),
        Resource(name: "Eco-friendly Transportation", category: .environment, about: "Renewable energy vehicles versus transportation systems", id:32, imageName:"Eco-friendly Transportation"),
        Resource(name: "Water Reclamation Facilities", category: .environment, about: "Wastewater treatment for reuse", id:33, imageName:"Water Reclamation Facilities"),
        Resource(name: "Afforestation Projects", category: .environment, about: "Tree planting to restore forests  ", id:34, imageName:"Afforestation Projects"),
        Resource(name: "Biodegradable Materials", category: .environment, about: "Products that naturally decompose ", id:35, imageName:"Biodegradable Materials"),
    ]
    var alienResources: [Resource] = [
        Resource(name: "Alien Languages", category: .technology, about: "Zwarp Glix Bloot, Kweept Zarniklop, and Gluphrend Skwibble" , id: 36 , imageName: "Alien Languages"),
        Resource(name: "Genetic Harmony Techniques", category: .technology, about: "Methods ensring genetic modifiaction in balance with physiology to enhance natural capabilties", id: 38, imageName: "Genetic Harmony Techniques"),
        Resource(name: "Quantum Entanglement Processors", category: .technology, about: "Devices that utlize quantum entanglement priciples for instantaneous computation across any distances known", id: 39,imageName: "Quantum Entanglement Processors"),
        Resource(name: "Orbital Gliders", category: .technology, about: "Spacecraft that glide through atmospheres and celestial object's orbits using bodies gravitational pull on the craft ", id: 37,imageName: "Orbital Gliders"),
        Resource(name: "Molecular constructors", category: .technology, about: "Assembling objects at the molecular level for precision fabrication to create complex structures and solutions", id: 40, imageName: "Molecular constructors"),
        Resource(name: "Cognitive Networks", category: .technology, about: "Networks that integrate with diverse intelligences for collective problem-solving using cognotrei.", id: 41, imageName: "Cognitive Networks"),
        Resource(name: "Microscale Swarm Fabricators", category: .technology, about: "swarms of tiny devices that work together to construct or repair materials aiding in building large infrastructure", id: 42, imageName: "Microscale Swarm Fabricators"),
       
        
        Resource(name: "Physical Experience suit", category: .knowledge, about: " suits that stimualte touch and digitally helps in providing full sensory immersion for learning and gameplay ", id: 52, imageName:"Physical Experience suit"),
        Resource(name: "Chain Memory Links", category: .knowledge, about: "interconnected memory storage for secure data exchange.", id: 51, imageName:"Chain Memory Links"),
        Resource(name: "Atmospheric Kinetic Harvesters ", category: .natural, about: "capturing energy from planetary atmospheric movements", id: 46, imageName:"Atmospheric Kinetic Harvesters"),
          Resource(name: "Stellar Navigation Mesh", category: .knowledge, about: "this is something about the tech", id: 53, imageName:"Stellar Navigation Mesh"),
        
        
        
        Resource(name: "Atmospheric Carbon Integrators", category: .natural, about: "systems that integrate carbon directly into alien ecosystems.", id: 47, imageName:"Atmospheric Carbon Integrators"),

        
    
                Resource(name: "Thermal Vents Power", category: .natural, about: "natural planetary vents for energy without environmental damage.", id: 43, imageName:"Thermal Vents Power"),
                Resource(name: "Aeroponic Cultures", category: .natural, about: "mist environments for cultivating alien plant life", id: 44, imageName:"Aeroponic Cultures"),
                Resource(name: "Moisture Vaporators", category: .natural, about: " devices that extract moisture directly from the atmosphere.", id: 45, imageName:"Moisture Vaporators"),
              
                Resource(name: "Eco-genetic Modifiers ", category: .natural, about: "modifying organisms to enhance ecosystem compatibility.", id: 48, imageName:"Eco-genetic Modifiers"),
                Resource(name: "Liquid Reconstitution Modules ", category: .natural, about: "devices that can purify and reconstitute fluids for alien consumption.", id: 49, imageName:"Liquid Reconstitution Modules"),
                
            Resource(name: "Memory Crystals", category: .knowledge, about: "crystalline devices for holographic data storage and access.", id: 50, imageName:"Memory Crystals"),
      
        Resource(name: "Interconnected Sentience Web", category: .knowledge, about: "a web of devices and beings sharing consciousness and information.", id: 54, imageName:"Interconnected Sentience Web"),
      Resource(name: "Collective Code Convergence", category: .knowledge, about: "development of software solutions across alien societies", id: 55, imageName:"Collective Code Convergence"),
        Resource(name: "Neural Integration Networks", category: .knowledge, about: "networks that integrate alien neural patterns for enhanced connectivity.", id: 56, imageName:"Neural Integration Networks"),
        //   
    
            Resource(name: "Cultured Nutrient Gel", category: .food, about: " nutrient-rich gels tailored to alien dietary needs.", id: 57, imageName:"Cultured Nutrient Gel"),
            Resource(name: "Spiral Groves", category: .food, about: " efficiently designed alien plantations that maximize space and resources.", id: 58, imageName:"Spiral Groves"),
           Resource(name: "Genetic Adaptation Cultures", category: .food, about: "crops adapted for extreme environments or specific nutritional profiles.", id: 59, imageName:"Genetic Adaptation Cultures"),
           Resource(name: "Photosynthetic Meal Fibers", category: .food, about: "dible fibers that perform photosynthesis, providing sustenance.", id: 60, imageName:"Photosynthetic Meal Fibers"),
           Resource(name: "Enzymatic Food Synthesis", category: .food, about: "techniques that use enzymes to create complex food molecules.", id: 61, imageName:"Enzymatic Food Synthesis"),
            Resource(name: "Eco-integrated Farming ", category: .food, about: " methods that fully integrate crops into the natural ecosystem.", id: 62, imageName:"Eco-integrated Farming "),
           Resource(name: "Bio-enhanced Nutrient Infusion ", category: .food, about: "enhancing food at the molecular level to optimize nutrient absorption.", id: 63, imageName:"Bio-enhanced Nutrient Infusion"),
        
        //i want to map to alientype sneaky
                Resource(name: "Living Structures", category: .environment, about: "organically grown buildings that adapt over time", id: 64, imageName:"Living Structures"),
                Resource(name: "Sea Purification Drones", category: .environment, about: "autonomous devices that cleanse alien water bodies", id: 65, imageName:"Sea Purification Drones"),
                  Resource(name: "Bioharmonic Parks", category: .environment, about: "parks designed to resonate with alien flora and fauna for well-being", id: 67, imageName:"Bioharmonic Parks"),
               Resource(name: "Symbiotic Transport Networks", category: .environment, about: " transportation systems that are in harmony with the alien environment.", id: 66, imageName:"Symbiotic Transport Networks"),
        Resource(name: "Hydro-symbiotic Systems", category: .environment, about: "systems that purify and integrate water into ecosystems efficiently", id: 68, imageName:"Hydro-symbiotic Systems"),
        Resource(name: "Ecosystem Genesis Initiatives", category: .environment, about: "large-scale projects to create or regenerate alien ecosystem", id: 69, imageName:"Ecosystem Genesis Initiatives"),
        Resource(name: "Self-Disassembling Compounds ", category: .environment, about: "materials designed to disassemble into harmless components after use", id: 70, imageName:"Self-Disassembling Compounds "),
    ]
    
    var aliengibberishResources: [Resource] = []
    
    
    func generateGibberishResources() -> [Resource] {
        var gibberishResources: [Resource] = []
        for (index, _) in alienResources.enumerated() {
            let gibberishName = "\(generateRandomWord()) \(generateRandomWord())"
            let gibberishAbout = "\(generateRandomSentence())"
            let actualAlienResource = alienResources[index % alienResources.count] // Cycle through actual alien resources
            let gibberishResource = Resource(name: gibberishName, category: .technology, about: gibberishAbout, id: actualAlienResource.id, imageName: actualAlienResource.imageName)
            gibberishResources.append(gibberishResource)
        }
        return gibberishResources
    }
    
    
    func generateRandomWord() -> String {
        let letters = "⏃⏚☊⎅⟒⎎☌⊑⟟⟊☍⌰⋔⋏⍜⌿⍾⍀⌇⏁⎍⎐⍙⌖⊬⋉"
        let length = 20
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func generateRandomSentence() -> String {
        let wordsCount = Int.random(in: 5...7)
        let words = (0..<wordsCount).map { _ in generateRandomWord() }
        return words.joined(separator: " ") + "."
    }
    
    init() {
        //    prepareForNewMatch()
        aliengibberishResources = generateGibberishResources() 
    }
    
    func isLastRoundOfCurrentMatch() -> Bool {
        return currentRound == totalRounds
    }
    func playRound(humanAction: Action) {
        let alienAction = determineAlienAction()
        
        let outcome = calculateOutcome(humanAction: humanAction, alienAction: alienAction)
        humanPoints += outcome.humanPoints
        alienPoints += outcome.alienPoints
        
        if currentAlienType == .friedman && humanAction == .cheat {
            hasHumanCheatedFriedmanThisMatch = true
        }
        
        if currentAlienType == .sneaky {
            if humanAction == .cheat {
                hasHumanCheatedsneaky = true
            }
        }
        
        
        lastHumanAction = humanAction
        lastAlienAction = alienAction
        
        if humanAction == .cheat {
            hasHumanCheated = true
        }
        
        
        if currentRound == 1 && matchCount == 0 {
            // Update cooperation in the language round of the first match based on human action
            hasCooperatedInLanguageRound = (humanAction == .cooperate)
            if (humanAction == .cooperate){
                print("human cooperated in language round")}else{
                    print("he cheated in lan round")
                }
        }
        
        incrementResourceIndexes()
        
        currentRound += 1
        if currentRound > totalRounds {
            matchCount += 1
            if matchCount >= 5 {
                print(currentRound)
            
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { 
                    self.prepareForNewMatch()
                }
            }
        }
    }        
    
    
    
    func incrementResourceIndexes() {
        currentHumanResourceIndex = (currentHumanResourceIndex + 1) % humanResources.count
        currentAlienResourceIndex = (currentAlienResourceIndex + 1) % alienResources.count
    }
    
    private func prepareForNewMatch() {
        currentRound = 1
       //   totalRounds = Int.random(in: 3...7)
       //   totalRounds = 3
        // Ensuring that we select an alien type based on the current match count, wrapping around if needed
        currentAlienType = AlienType.allCases[matchCount % AlienType.allCases.count]
        istitfortatFirstMove = true
        lastHumanAction = nil
        lastAlienAction = nil
        hasHumanCheatedFriedmanThisMatch = false
        startCheatingNextRoundFriedman = false
        
    }
    
    var isfirstgamePlay = true 
    
    private func determineAlienAction() -> Action {
        switch currentAlienType {
        case .titfortat:
            if currentRound==2 {
                return .cheat //sneese noise 
            }
            if istitfortatFirstMove {
                istitfortatFirstMove = false
                return .cooperate
            } else {
                return lastHumanAction ?? .cooperate
            }
        case .alwaysCooperate:
            switch currentRound {
            case 1:
                return .cooperate 
            case 2:
                return .cooperate 
            case 3, 4, 5:
                return .cooperate 
            default:
                return .cooperate 
            }
        case .alwaysdefect:
                return .cheat 
        case .friedman:
            if hasHumanCheatedFriedmanThisMatch && currentRound > 3 {
                return .cheat
            } else {
                return .cooperate
            }
        case .sneaky:
            // Starts with a specific sequence to test the waters.
            let initialSequence: [Action] = [.cooperate, .cheat, .cooperate, .cooperate]
            if currentRound <= initialSequence.count {
                return initialSequence[currentRound - 1]
            } else {
          
                if hasHumanCheatedsneaky {
                    return lastHumanAction ?? .cooperate
                } else {
                    return Int.random(in: 1...10) <= 2 ? .cooperate : .cheat
                }
            }
        }
    }
    
    
    
    private func calculateOutcome(humanAction: Action, alienAction: Action) -> GameOutcome {
        switch (humanAction, alienAction) {
        case (.cooperate, .cooperate):
            return GameOutcome(humanPoints: 2, alienPoints:2)
        case (.cheat, .cooperate):
            return GameOutcome(humanPoints: 3, alienPoints: -1)
        case (.cooperate, .cheat):
            return GameOutcome(humanPoints: -1, alienPoints: 3)
        case (.cheat, .cheat):
            return GameOutcome(humanPoints: 0, alienPoints: 0)
        }
    }
    
    func restartGame() {
        matchCount = 0
        humanPoints = 0
        alienPoints = 0
        istitfortatFirstMove = true
        hasHumanCheated = false
        prepareForNewMatch()
        currentHumanResourceIndex = 0
        currentAlienResourceIndex = 0
        hasCooperatedInLanguageRound = false
        hasHumanCheatedsneaky = false
        
    }
    
    
}






