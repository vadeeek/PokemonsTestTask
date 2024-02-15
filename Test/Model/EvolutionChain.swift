import Foundation

// MARK: - EvolutionChain
struct EvolutionChain: Decodable {
    let chain: Chain?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case chain, id
    }
}

// MARK: - Chain
struct Chain: Decodable {
    let species: Species
    let evolvesTo: [Chain]?
    let isBaby: Bool?

    enum CodingKeys: String, CodingKey {
        case evolvesTo = "evolves_to"
        case isBaby = "is_baby"
        case species
    }
}
