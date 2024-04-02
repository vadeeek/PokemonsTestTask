import Foundation

final class ComparePokemonsManager {
    
    static let shared = ComparePokemonsManager ()
    
    var selectedPokemons: [EnhancedPokemon] = []
    
    func addPokemon(_ pokemon: EnhancedPokemon) {
        if selectedPokemons.isEmpty {
            selectedPokemons.append(pokemon)
        } else if selectedPokemons.count < 2 {
            if let existingIndex = selectedPokemons.firstIndex(of: pokemon) {
                selectedPokemons.remove(at: existingIndex)
                selectedPokemons.insert(pokemon, at: 0)
            } else {
                selectedPokemons.insert(pokemon, at: 0)
            }
        } else {
            if let existingIndex = selectedPokemons.firstIndex(of: pokemon) {
                selectedPokemons.remove(at: existingIndex)
                selectedPokemons.insert(pokemon, at: 0)
            } else {
                selectedPokemons.removeLast()
                selectedPokemons.insert(pokemon, at: 0)
            }
        }
    }
    
    func clearSelectedPokemons() {
        selectedPokemons.removeAll()
    }
}
