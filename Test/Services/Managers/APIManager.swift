import UIKit

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

protocol APIManagerProtocol {
    var allPokemonNames: [String] { get }
    var allPokemonIDs: [Int] { get }
    var allPokemonTypes: [String] { get }
    
    func fetchAllPokemonNames()
    func fetchAllPokemonIDs()
    func fetchAllPokemonTypes(completion: @escaping (Result<[String], Error>) -> Void)
    func searchPokemons(byKeywordOrId keywordOrId: String, completion: @escaping (Result<[EnhancedPokemon], Error>) -> Void)
    func getPokemon(byID id: Int, completion: @escaping (Result<EnhancedPokemon, Error>) -> Void)
    func getPokemons(byPokemonType pokemonType: String, completion: @escaping (Result<[EnhancedPokemon], Error>) -> Void)
    func getNextPagePokemonsList(isFirstPage: Bool, completion: @escaping (Result<[EnhancedPokemon], Error>) -> Void)
    func getPokemonsForEvolution(fromPokemonIDsArray pokemonIDsArray: [Int], completion: @escaping (Result<([EnhancedPokemon], [Int]), Error>) -> Void)
    func getEvolutionChainArray(byUrlString urlString: String, completion: @escaping (Result<[String], Error>) -> Void)
}

final class APIManager: APIManagerProtocol {
    
    // MARK: - Properties
    static let shared = APIManager()
    
//    private let paginationLimit = 20
    private let baseUrlString = "https://pokeapi.co/api/v2/"
    private let pokemonsStartingListUrlString = "https://pokeapi.co/api/v2/pokemon/?limit=20"
    let pokemonsImageUrlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/"
    private var pokemonsListNextPageUrlString: String? = nil
    private var isLastPage = false
    
    var allPokemonNames: [String] = []
    var allPokemonIDs: [Int] = []
    var allPokemonTypes: [String] = []

    // MARK: - Methods
    func fetchAllPokemonNames() {
        if let url = URL(string: "https://pokeapi.co/api/v2/pokemon/?limit=1350") {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(PokemonsList.self, from: data)
                        self.allPokemonNames = response.results.compactMap { $0?.name }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                } else {
                    print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                }
            }.resume()
        } else {
            print("Invalid URL")
        }
    }
    
    func fetchAllPokemonIDs() {
        if let url = URL(string: "https://pokeapi.co/api/v2/pokemon/?limit=1350") {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(PokemonsList.self, from: data)
                        self.allPokemonIDs = response.results.compactMap { result -> Int? in
                            guard let url = result?.url else { return nil }
                            if let idString = url.components(separatedBy: "/").dropLast().last, let id = Int(idString) {
                                return id
                            } else {
                                return nil
                            }
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                } else {
                    print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                }
            }.resume()
        } else {
            print("Invalid URL")
        }
    }
    
    func fetchAllPokemonTypes(completion: @escaping (Result<[String], Error>) -> Void) {
        if let url = URL(string: "https://pokeapi.co/api/v2/type/") {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error {
                    completion(.failure(error))
                    return
                }
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(PokemonTypesList.self, from: data)
                        self.allPokemonTypes = response.results.compactMap { $0?.name }
                        completion(.success(self.allPokemonTypes))
                    } catch {
                        completion(.failure(NetworkError.decodingError))
                    }
                } else {
                    completion(.failure(NetworkError.noData))
                }
            }.resume()
        } else {
            completion(.failure(NetworkError.invalidURL))
        }
    }

    private func filterPokemonNames(bySubstring substring: String) -> [String] {
        let filteredPokemonNames = allPokemonNames.filter { $0.range(of: substring, options: .caseInsensitive) != nil }
        return filteredPokemonNames
    }
    
    private func filterPokemonIDs(bySubID: Int) -> [Int] {
        let filteredPokemonIDs = allPokemonIDs.filter { id -> Bool in
            let idString = String(id)
            let subIDString = String(bySubID)
            return idString.range(of: subIDString) != nil
        }
        return filteredPokemonIDs
    }
    
    func searchPokemons(byKeywordOrId keywordOrId: String, completion: @escaping (Result<[EnhancedPokemon], Error>) -> Void) {
        if let id = Int(keywordOrId) {
            let filteredPokemonIDs = Set(filterPokemonIDs(bySubID: id))
            getPokemons(fromPokemonIDsArray: filteredPokemonIDs) { enhancedPokemonsArray in
                completion(enhancedPokemonsArray)
            }
        } else {
            let filteredPokemonNames = Set(filterPokemonNames(bySubstring: keywordOrId))
            getPokemons(fromPokemonNamesArray: filteredPokemonNames) { enhancedPokemonsArray in
                completion(enhancedPokemonsArray)
            }
        }
    }
    
    func getPokemon(byID id: Int, completion: @escaping (Result<EnhancedPokemon, Error>) -> Void) {
        guard let url = URL(string: baseUrlString + "pokemon/\(id)/") else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else { return }
            if let pokemonData = try? JSONDecoder().decode(PokemonResponse.self, from: data) {
                let enhancedPokemon = EnhancedPokemon(pokemon: pokemonData)
                completion(.success(enhancedPokemon))
            } else {
                print("fail pokemon! pokemonID: \(id)")
            }
        }.resume()
    }
    
//    func getPokemons(from pokemonsIDsArray: Set<Int>, completion: @escaping ([EnhancedPokemon]) -> Void) {
//    private func getPokemons(from pokemonsIDsArray: Set<String>, completion: @escaping ([EnhancedPokemon]) -> Void) {
//        var enhancedPokemons: [EnhancedPokemon] = []
//        let group = DispatchGroup()
//
//        for id in pokemonsIDsArray {
//            group.enter()
//
//            guard let url = URL(string: baseUrlString + "pokemon/\(id)/") else {
//                group.leave()
//                continue
//            }
//
//            let request = URLRequest(url: url)
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                defer {
//                    group.leave()
//                }
//                guard let data else {
//                    print("No data")
//                    return
//                }
//                if let pokemonData = try? JSONDecoder().decode(Pokemon.self, from: data) {
//                    let enhancedPokemon = EnhancedPokemon(pokemon: pokemonData)
//                    enhancedPokemons.append(enhancedPokemon)
//                } else {
//                    print("Failed to fetch pokemon! PokemonID: \(id)")
//                }
//            }.resume()
//        }
//        group.notify(queue: DispatchQueue.main) {
//            completion(enhancedPokemons)
//        }
//    }
    
    private func getPokemons(fromPokemonNamesArray pokemonNamesArray: Set<String>, completion: @escaping (Result<[EnhancedPokemon], Error>) -> Void) {
        var enhancedPokemons: [EnhancedPokemon] = []
        let group = DispatchGroup()

        for name in pokemonNamesArray {
            group.enter()

            guard let url = URL(string: baseUrlString + "pokemon/\(name)/") else {
                group.leave()
                continue
            }

            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                defer {
                    group.leave()
                }
                guard let data else {
                    print("No data")
                    return
                }
                if let pokemonData = try? JSONDecoder().decode(PokemonResponse.self, from: data) {
                    let enhancedPokemon = EnhancedPokemon(pokemon: pokemonData)
                    enhancedPokemons.append(enhancedPokemon)
                } else {
                    print("Failed to fetch pokemon! PokemonName: \(name)")
                }
            }.resume()
        }
        group.notify(queue: DispatchQueue.main) {
            completion(.success(enhancedPokemons))
        }
    }
    
    private func getPokemons(fromPokemonIDsArray pokemonIDsArray: Set<Int>, completion: @escaping (Result<[EnhancedPokemon], Error>) -> Void) {
        var enhancedPokemons: [EnhancedPokemon] = []
        let group = DispatchGroup()

        for id in pokemonIDsArray {
            group.enter()

            guard let url = URL(string: baseUrlString + "pokemon/\(id)/") else {
                group.leave()
                continue
            }

            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                defer {
                    group.leave()
                }
                guard let data else {
                    print("No data")
                    return
                }
                if let pokemonData = try? JSONDecoder().decode(PokemonResponse.self, from: data) {
                    let enhancedPokemon = EnhancedPokemon(pokemon: pokemonData)
                    enhancedPokemons.append(enhancedPokemon)
                } else {
                    print("Failed to fetch pokemon! PokemonID: \(id)")
                }
            }.resume()
        }
        group.notify(queue: DispatchQueue.main) {
            completion(.success(enhancedPokemons))
        }
    }
    
    func getPokemons(byPokemonType pokemonType: String, completion: @escaping (Result<[EnhancedPokemon], Error>) -> Void) {
        // TODO: сделать одну функцию из нескольких чтобы передавать enum значение (.type, .name, .id итд)
//        func getPokemons(by .type("fire"), completion: @escaping ([EnhancedPokemon]) -> Void) {
        //        let group = DispatchGroup()
        
        //        group.enter()
        
        guard let url = URL(string: baseUrlString + "type/\(pokemonType)/") else {
            //            group.leave()
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            defer {
                //                group.leave()
            }
            guard let data else {
                // FIX: везде сделать обработку ошибок
                print("No data")
                return
            }
            if let pokemonData = try? JSONDecoder().decode(PokemonType.self, from: data) {
                if let pokemonElements = pokemonData.pokemons {
                    let pokemonNames = Set(pokemonElements.compactMap({ $0.pokemon?.name }))
                    self.getPokemons(fromPokemonNamesArray: pokemonNames) { enhancedPokemons in
                        completion(enhancedPokemons)
                    }
                } else {
                    print("Failed to fetch pokemon! PokemonType: \(pokemonType)")
                }
            } else {
                print("Failed to fetch pokemon! PokemonType: \(pokemonType)")
            }
        }.resume()
        //        group.notify(queue: DispatchQueue.main) {
        //            completion(enhancedPokemons)
        //        }
    }

    func getNextPagePokemonsList(isFirstPage: Bool = false, completion: @escaping (Result<[EnhancedPokemon], Error>) -> Void) {
        guard !isLastPage else {
            completion(.success([]))
            return
        }
        
        var urlString = ""
        
        if isFirstPage {
            urlString = "https://pokeapi.co/api/v2/pokemon/?limit=20"
        } else {
            guard let nextPageUrlString = pokemonsListNextPageUrlString else {
                completion(.success([]))
                return
            }
            urlString = nextPageUrlString
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let pokemonsList = try JSONDecoder().decode(PokemonsList.self, from: data)
                if let nextUrlString = pokemonsList.next {
                    self.pokemonsListNextPageUrlString = nextUrlString
                } else {
                    self.pokemonsListNextPageUrlString = nil
                    self.isLastPage = true
                }
                
                let pokemonsNames = Set(pokemonsList.results.compactMap { $0?.name })
                self.getPokemons(fromPokemonNamesArray: pokemonsNames) { enhancedPokemons in
                    completion(enhancedPokemons)
                }
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }
    
    func getPokemonsForEvolution(fromPokemonIDsArray pokemonIDsArray: [Int], completion: @escaping (Result<([EnhancedPokemon], [Int]), Error>) -> Void) {
        var evolutionPokemons: [Int: EnhancedPokemon] = [:]
        let group = DispatchGroup() // Создаем DispatchGroup для отслеживания завершения всех запросов
        
        for id in pokemonIDsArray {
            guard let url = URL(string: baseUrlString + "pokemon/\(id)/") else { continue }
//            let request = URLRequest(url: url)
            
            group.enter() // Указываем, что начинаем новый запрос
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                defer { group.leave() } // Указываем, что запрос завершен
                
                guard let data else {
                    print("No data")
                    return
                }
                if let pokemonData = try? JSONDecoder().decode(PokemonResponse.self, from: data) {
                    let enhancedPokemon = EnhancedPokemon(pokemon: pokemonData)
                    evolutionPokemons[id] = enhancedPokemon
                } else {
                    print("Failed to fetch pokemon! PokemonID: \(id)")
                }
            }.resume()
        }
        // Вызываем completion после завершения всех запросов
        group.notify(queue: .main) {
            let sortedImages = evolutionPokemons.sorted { $0.key < $1.key } // Преобразовать словарь в отсортированный массив пар ключ-значение
            let sortedEvolutionPokemonsArray = sortedImages.map { $0.value } // Сохранить только значения (покемонов) в массиве для отображения в таблице
            let sortedEvolutionKeysArray = sortedImages.map { $0.key }
            
            completion(.success((sortedEvolutionPokemonsArray, sortedEvolutionKeysArray)))
        }
    }
    
    func getEvolutionChainArray(byUrlString urlString: String, completion: @escaping (Result<[String], Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else { return }
            if let pokemonSpeciesData = try? JSONDecoder().decode(PokemonSpecies.self, from: data) {
                self.getEvolutionChain(byUrlString: pokemonSpeciesData.evolutionChain?.url, completion: { evolutionChainData in
                    var  evolutionURLs: [String] = []
                    switch evolutionChainData {
                    case .success(let evolutionChainData):
                        evolutionURLs.append(evolutionChainData.chain!.species.url!)
                        
                        self.addEvolutionURLs(fromEvolutionChains: (evolutionChainData.chain?.evolvesTo)!, to: &evolutionURLs)
                        completion(.success(evolutionURLs))
                    case .failure(_):
                        completion(.failure(NetworkError.noData))
                    }
                })
            }
        }.resume()
    }
    
    private func addEvolutionURLs(fromEvolutionChains evolutionChains: [Chain], to evolutionURLs: inout [String]) {
        for evolutionChain in evolutionChains {
            if evolutionChain.species.url != nil {
                evolutionURLs.append(evolutionChain.species.url!)
                if evolutionChain.evolvesTo != nil {
                    if !evolutionChain.evolvesTo!.isEmpty {
                        self.addEvolutionURLs(fromEvolutionChains: evolutionChain.evolvesTo!, to: &evolutionURLs)
                    }
                }
            }
        }
    }
    
    private func getEvolutionChain(byUrlString urlString: String?, completion: @escaping (Result<EvolutionChain, Error>) -> Void) {
        guard let urlString, let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else { return }
            if let evolutionChainData = try? JSONDecoder().decode(EvolutionChain.self, from: data) {
                completion(.success(evolutionChainData))
            } else {
                print("fail chain!")
            }
        }.resume()
    }
}
