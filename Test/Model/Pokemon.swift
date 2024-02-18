import Foundation

// MARK: - Pokemon
struct Pokemon: Decodable {
    let abilities: [Ability]?
    let height: Int?
    let id: Int?
    let name: String?
    let species: Species?
    let sprites: Sprites?
    let stats: [Stat]?
    let types: [TypeElement]?
    let weight: Int?
    
    enum CodingKeys: String, CodingKey {
        case abilities
        case height = "height"
        case id = "id"
        case name = "name"
        case species, sprites, stats, types, weight
    }
}

// MARK: - Ability
struct Ability: Decodable {
    let ability: Species?

    enum CodingKeys: String, CodingKey {
        case ability
    }
}

// MARK: - Species
struct Species: Decodable {
    let name: String?
    let url: String?
}

// MARK: - Sprites
struct Sprites: Decodable {
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

// MARK: - TypeElement
struct TypeElement: Decodable {
    let type: Species?
}
