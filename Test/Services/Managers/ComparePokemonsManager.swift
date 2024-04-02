import Foundation

enum AttributeWinner {
    case left, right, draw
}

final class ComparePokemonsManager {
    
    // MARK: - Properties
    static let shared = ComparePokemonsManager ()
    
    private(set) var selectedPokemons: [EnhancedPokemon] = [] {
        didSet {
            compareCharacteristics()
        }
    }
    private(set) var selectedPokemonsAttributesWinner: [AttributeWinner] = []
    
    // MARK: - Methods
    func addPokemon(_ pokemon: EnhancedPokemon) {
        if !selectedPokemons.contains(pokemon) {
            if selectedPokemons.count == 2 {
                selectedPokemons.removeLast()
            }
        } else {
            selectedPokemons.removeAll { $0 == pokemon }
        }
        selectedPokemons.insert(pokemon, at: 0)
    }
    
    func clearSelectedPokemons() {
        selectedPokemons.removeAll()
        selectedPokemonsAttributesWinner.removeAll()
    }
    
    private func compareCharacteristics() {
        selectedPokemonsAttributesWinner.removeAll()
        
        guard selectedPokemons.count == 2, let numberOfStats = selectedPokemons.first?.stats?.count else { return }
        for index in 0..<numberOfStats {
            guard let baseStatLeft = selectedPokemons[0].stats?[index].baseStat,
                  let baseStatRight = selectedPokemons[1].stats?[index].baseStat else { return }
            if baseStatLeft > baseStatRight {
                selectedPokemonsAttributesWinner.append(.left)
            } else if baseStatRight > baseStatLeft {
                selectedPokemonsAttributesWinner.append(.right)
            } else {
                selectedPokemonsAttributesWinner.append(.draw)
            }
        }
    }
}
