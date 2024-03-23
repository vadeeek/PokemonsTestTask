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
}

// MARK: - Sprites
struct Sprites: Decodable {
    
    static func == (lhs: Sprites, rhs: Sprites) -> Bool {
        return lhs.frontDefault == rhs.frontDefault
    }
    
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
    
    //    init(frontDefault: String?) {
    //        self.frontDefault = frontDefault
    //    }
}

// MARK: - Stat
struct Stat: Decodable, Equatable {
    
    static func == (lhs: Stat, rhs: Stat) -> Bool {
        return lhs.baseStat == rhs.baseStat && lhs.stat == rhs.stat
    }
    
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
