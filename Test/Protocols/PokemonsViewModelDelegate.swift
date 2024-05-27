import Foundation

protocol PokemonsViewModelDelegate: AnyObject {
    func didUpdatePokemonTypes()
    func didUpdatePokemonsList()
    func didStartLoadingPokemons()
    func didEndLoadingPokemons()
    func clearSelectedCells()
}
