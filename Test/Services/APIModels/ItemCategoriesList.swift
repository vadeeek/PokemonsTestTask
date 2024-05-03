import Foundation

struct ItemCategoriesList: Decodable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [Species?]
}
