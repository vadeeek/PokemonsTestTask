import Foundation

// MARK: - ItemCategory
struct ItemCategory: Decodable {
    let id: Int?
    let items: [Item]?
}

// MARK: - ItemElement
struct ItemElement: Decodable {
    let name: String?
    let url: String?
}
