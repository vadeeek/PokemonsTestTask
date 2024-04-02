import Foundation

// MARK: - PokemonType
struct PokemonType: Decodable {
    let pokemons: [PokemonElement]?
    
    enum CodingKeys: String, CodingKey {
        case pokemons = "pokemon"
    }
}

// MARK: - PokemonElement
struct PokemonElement: Decodable {
    let pokemon: Species?
}
