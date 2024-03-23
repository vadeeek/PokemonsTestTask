import UIKit

final class TypeFormatter {
    
    static let shared = TypeFormatter()
    
    func formate(typeString: String) -> (String, UIColor) {
        let typesStrings: [String] = ["normal", "fighting", "flying", "poison", "ground", "rock", "bug", "ghost", "steel", "fire", "water", "grass", "electric", "psychic", "ice", "dragon", "dark", "fairy", "unknown", "shadow"]
        let typesColors: [UIColor] = [.lightGray, .orange, .systemBlue, .systemPink, .systemBrown, .systemGray3, .systemGreen, .purple, .lightGray, .orange, .systemBlue, .green, .yellow, .white, .white, .black, .darkGray, .systemPink, .lightGray, .systemGray4]
        
        if typesStrings.count == typesColors.count {
            if let index = typesStrings.firstIndex(of: typeString) {
                return (typeString.capitalized, typesColors[index])
            } else {
                return (typeString.capitalized, .lightGray)
            }
        } else {
            return (typeString.capitalized, .lightGray)
        }
    }
}
