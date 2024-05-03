import Foundation

struct ItemsList: Decodable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [Species?]
}
