import Foundation

class APIManager {
    
    static let shared = APIManager()
    
    let pokemonsIDRange = 45...120
    let urlString = "https://pokeapi.co/api/v2/pokemon/"
    
    func getPokemon(completion: @escaping (Pokemon) -> Void) {
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
    
    func getPokemonPicture(urlString: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else { return }
            completion(data)
        }.resume()
    }
}
