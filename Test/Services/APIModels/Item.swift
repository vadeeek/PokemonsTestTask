import Foundation

// MARK: - Item
struct Item: Decodable {
    let attributes: [Category]?
    let category: Category?
    let cost: Int?
    let effectEntries: [EffectEntry]?
    let id: Int?
    let name: String?
    let sprites: Sprites?

    enum CodingKeys: String, CodingKey {
        case attributes, category, cost
        case effectEntries = "effect_entries"
        case id, name, sprites
    }
}

// MARK: - Category
struct Category: Decodable {
    let name: String?
    let url: String?
}

// MARK: - EffectEntry
struct EffectEntry: Decodable {
    let effect: String?
    let shortEffect: String?

    enum CodingKeys: String, CodingKey {
        case effect
        case shortEffect = "short_effect"
    }
}
