import Foundation

class APIManager {
    
    // MARK: - Properties
    static let shared = APIManager()
    
    private let urlString = "https://pokeapi.co/api/v2/pokemon/"
    
    func getPokemon(in pokemonsIDRange: ClosedRange<Int>, completion: @escaping (Pokemon) -> Void) {
        for id in pokemonsIDRange {
            guard let url = URL(string: urlString + "\(id)/") else { return }
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data else { return }
                if let pokemonData = try? JSONDecoder().decode(Pokemon.self, from: data) {
                    completion(pokemonData)
                } else {
                    print("fail")
                }
            }.resume()
        }
    }
    
    func getPokemonPicture(by urlString: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else { return }
            completion(data)
        }.resume()
    }
    
    func getPokemonPicture(by pokemonID: Int, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonID).png") else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else { return }
            completion(data)
        }.resume()
    }
    
    func getEvolutionChainArray(by urlString: String, completion: @escaping ([String]) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else { return }
            if let pokemonSpeciesData = try? JSONDecoder().decode(PokemonSpecies.self, from: data) {
                self.getEvolutionChain(by: pokemonSpeciesData.evolutionChain?.url, completion: { evolutionChainData in
                    var  evolutionURLs: [String] = []
                    evolutionURLs.append(evolutionChainData.chain!.species.url!)
                    
                    
                    self.addEvolutionURLs(from: (evolutionChainData.chain?.evolvesTo)!, to: &evolutionURLs)
                    completion(evolutionURLs)
                })
            }
        }.resume()
        
        //                                       func extractImageURLs(from chain: Chain) {
        //
        //                    for nextEvolution in chain.evolvesTo {
        //                        extractImageURLs(from: nextEvolution)
        //                            }
        //                        }
        //
        //                        extractImageURLs(from: evolutionChain.chain)
        //
        //                        print(imageURLs)
        //
        //                        for element in evolutionChainData {
        //                            print(element.evolvesTo)
        //                        }
        //                    }
        
        
        //                })
        //            } else {
        //                print("fail")
        //            }
        //        }.resume()
    }
    
    private func addEvolutionURLs(from evolutionChains: [Chain], to evolutionURLs: inout [String]) {
        for evolutionChain in evolutionChains {
            if evolutionChain.species.url != nil {
                evolutionURLs.append(evolutionChain.species.url!)
                if evolutionChain.evolvesTo != nil {
                    if !evolutionChain.evolvesTo!.isEmpty {
                        self.addEvolutionURLs(from: evolutionChain.evolvesTo!, to: &evolutionURLs)
                    }
                }
            }
        }
        
    }
    
    
    private func getEvolutionChain(by urlString: String?, completion: @escaping (EvolutionChain) -> Void) {
        guard let urlString, let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else { return }
            if let evolutionChainData = try? JSONDecoder().decode(EvolutionChain.self, from: data) {
                completion(evolutionChainData)
            } else {
                print("fail")
            }
        }.resume()
    }
    
}
