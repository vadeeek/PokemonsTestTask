import Foundation

protocol PokemonsViewModelDelegate: AnyObject {
    func didUpdatePokemonTypes()
    func didUpdatePokemons()
}
