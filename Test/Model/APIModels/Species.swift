import Foundation

// MARK: - Species
struct Species: Decodable, Equatable {
    
    static func == (lhs: Species, rhs: Species) -> Bool {
        return lhs.name == rhs.name && lhs.url == rhs.url
    }
    
    let name: String?
    let url: String?
}
