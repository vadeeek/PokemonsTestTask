import Foundation

// MARK: - Pokemon
struct Pokemon: Decodable {
    let height: Int?
    let id: Int?
    let name: String?
    let sprites: Sprites?
    let stats: [Stat]?
    let weight: Int?
    
    enum CodingKeys: String, CodingKey {
        case height = "height"
        case id = "id"
        case name = "name"
        case sprites, stats, weight
    }
}

// MARK: - Species
struct Species: Decodable {
    let name: String?
}

// MARK: - Sprites
class Sprites: Decodable {
    let frontDefault: String? // ссылка на изображение

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }

    init(frontDefault: String?) {
        self.frontDefault = frontDefault
    }
}

// MARK: - Stat
struct Stat: Decodable {
    let baseStat: Int?
    let stat: Species?

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}
