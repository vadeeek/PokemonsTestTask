import Foundation
import UIKit

class APIManager {
    
    // MARK: - Properties
    static let shared = APIManager()
    
    // "https://pokeapi.co/api/v2/ability/id_65-name_overgrow/" - получение инфы по абилке
    
    
    private let urlString = "https://pokeapi.co/api/v2/pokemon/"
    
//    func getPokemon(in pokemonsIDRange: ClosedRange<Int>, completion: @escaping (Pokemon) -> Void) {
    func getPokemon(by id: Int, completion: @escaping (Pokemon) -> Void) {
//    func getPokemon(by pokemonsIDsArray: Set<Int>, completion: @escaping (Pokemon) -> Void) {
//        for id in pokemonsIDsArray {
            guard let url = URL(string: urlString + "\(id)/") else { return }
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data else { return }
                if let pokemonData = try? JSONDecoder().decode(Pokemon.self, from: data) {
                    completion(pokemonData)
                } else {
                    print("fail pokemon! pokemonID: \(id)")
                }
            }.resume()
//        }
    }
    
    func getPokemonPicture(by urlString: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
//        print("request: \(url)")
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data else { return }
            completion(data)
        }.resume()
    }
    
    func getPokemonPicture(from pokemonsIDsArray: [Int], completion: @escaping ([Data], [Int]) -> Void) {
        var pokemonEvolutionPictures: [Int: Data] = [:]
        var dataTasks: [URLSessionDataTask] = []
        // Создаем DispatchGroup для отслеживания завершения всех запросов
        let group = DispatchGroup()

        for pokemonID in pokemonsIDsArray {
            guard let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonID).png") else { continue }
            let request = URLRequest(url: url)

            group.enter() // Указываем, что начинаем новый запрос

            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                defer { group.leave() } // Указываем, что запрос завершен

                if let data = data {
                    pokemonEvolutionPictures[pokemonID] = data
                }
            }
            task.resume()
            dataTasks.append(task)
        }
        // Вызываем completion после завершения всех запросов
        group.notify(queue: .main) {
            // Преобразовать словарь в отсортированный массив пар ключ-значение
            let sortedImages = pokemonEvolutionPictures.sorted { $0.key < $1.key }
            // Сохранить только значения (изображения) в массиве для отображения в таблице
            let sortedImageArray = sortedImages.map { $0.value }
            let sortedKeysArray = sortedImages.map { $0.key }

            completion(sortedImageArray, sortedKeysArray)
        }
    }
    
//    func loadImageFromURL(url: URL, completion: @escaping (UIImage?) -> Void) {
//        var request = URLRequest(url: url)
//           request.setValue("http", forHTTPHeaderField: "Content-Type")
//
//        URLSession(configuration: .default, delegate: nil, delegateQueue: nil).dataTask(with: request) { data, response, error in
//            guard let data = data, let image = UIImage(data: data) else {
//                completion(nil)
//                return
//            }
//            
//            completion(image)
//        }.resume()
//    }

    
    func getPokemonPicture(by pokemonID: Int, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonID).png") else { return }
//        print("imageURL: \(url)")
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                if let error = error {
                    print("Error: \(error)")
                } else {
                    print("No data received")
                }
                return
            }
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
                print("fail chain!")
            }
        }.resume()
    }
    
}
