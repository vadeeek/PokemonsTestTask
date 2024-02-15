import Foundation

// MARK: - PokemonSpecies
struct PokemonSpecies: Decodable {
    let evolutionChain: EvolutionChainClass?
    let id: Int?
    let isBaby, isLegendary, isMythical: Bool?
    let name: String?
    let names: [Name]?

    enum CodingKeys: String, CodingKey {
        case evolutionChain = "evolution_chain"
        case id
        case isBaby = "is_baby"
        case isLegendary = "is_legendary"
        case isMythical = "is_mythical"
        case name, names
    }
}

// MARK: - EvolutionChainClass
struct EvolutionChainClass: Codable {
    let url: String?
}

// MARK: - Name
struct Name: Decodable {
    let name: String?
}
