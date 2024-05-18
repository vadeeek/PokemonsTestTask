import UIKit

final class TypeFormatter {
    
    enum InputType {
        case name(string: String)
        case itemCategory(string: String)
    }
    
    // MARK: - Properties
    static let shared = TypeFormatter()
    
    private(set) var categoryColors: [String: UIColor] = [:]
    
    // MARK: - Methods
    func format(typeString: String) -> (String, UIColor) {
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
    
    func format(type: InputType) -> String {
        switch type {
        case .name(let string):
            let removedHyphens = string.replacingOccurrences(of: "-", with: " ")
            let capitalizedString = removedHyphens.capitalized
            return capitalizedString
        case .itemCategory(let string):
            let removedHyphens = string.replacingOccurrences(of: "-", with: " ")
            let lowercasedString = removedHyphens.lowercased()
            let capitalizedFirstLetter = lowercasedString.prefix(1).capitalized + lowercasedString.dropFirst()
            return capitalizedFirstLetter
        }
    }
    
    func generateCategoryColors() {
        let categoryStrings: [String] = APIManager.shared.allItemCategories
        var colors: [String: UIColor] = [:]
        for i in 0..<categoryStrings.count {
            let red = CGFloat.random(in: 0...1)
            let green = CGFloat.random(in: 0...1)
            let blue = CGFloat.random(in: 0...1)
            let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
            colors[categoryStrings[i]] = color
        }
        self.categoryColors = colors
    }
}
