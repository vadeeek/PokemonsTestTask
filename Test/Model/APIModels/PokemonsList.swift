import Foundation

struct PokemonsList: Decodable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [Species?]
}
