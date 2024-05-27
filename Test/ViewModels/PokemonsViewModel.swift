import Foundation

class PokemonsViewModel {
    
    // MARK: - Properties
    weak var delegate: PokemonsViewModelDelegate?
    
    var pokemons: [EnhancedPokemon] = []
    var filteredPokemons: [EnhancedPokemon] = []
    var allPokemonTypes: [String] = []
    
    
    
    var isPokemonsLoading = false
    var isPokemonTypesRequestInProgress = false
    
    // MARK: - Methods
    func didUpdatePokemonsList() {
        delegate?.didUpdatePokemonsList()
    }
    
    func didUpdatePokemonTypes() {
        delegate?.didUpdatePokemonTypes()
    }
    
    func fetchAllPokemonNames() {
        APIManager.shared.fetchAllPokemonNames()
    }
    
    func fetchAllPokemonIDs() {
        APIManager.shared.fetchAllPokemonIDs()
    }
    
    func clearSelectedCells() {
        delegate?.clearSelectedCells()
    }
    
    func fetchAllPokemonTypes() {
        APIManager.shared.fetchAllPokemonTypes { [weak self] result in
            switch result {
            case .success(let allPokemonTypes):
                DispatchQueue.main.async {
                    guard let self else { return }
                    self.allPokemonTypes = allPokemonTypes
                    self.didUpdatePokemonTypes()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    //    private func getPokemons(from pokemonsIDsArray: Set<Int>) {
    func getNextPagePokemonsList(isFirstPage: Bool = false) {
        guard !isPokemonsLoading else { return }
        
        delegate?.didStartLoadingPokemons()
        isPokemonsLoading = true

        APIManager.shared.getNextPagePokemonsList(isFirstPage: isFirstPage) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let enhancedPokemonsArray):
                self.handleSuccessfulResponse(enhancedPokemonsArray)
                self.delegate?.didEndLoadingPokemons()
            case .failure(let error):
                self.handleFailedResponse(error)
            }
        }
    }
    
    private func handleSuccessfulResponse(_ enhancedPokemonsArray: [EnhancedPokemon]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            self.pokemons += enhancedPokemonsArray
            self.filteredPokemons += enhancedPokemonsArray
            self.didUpdatePokemonsList()
            self.isPokemonsLoading = false
        }
    }

    private func handleFailedResponse(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            print("Error: \(error)")
            self.isPokemonsLoading = false
        }
    }
    
    func searchPokemons(byKeywordOrId keywordOrId: String) {
        APIManager.shared.searchPokemons(byKeywordOrId: keywordOrId) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let enhancedPokemonsArray):
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    
                    self.filteredPokemons = enhancedPokemonsArray
                    self.didUpdatePokemonsList()
                    self.clearSelectedCells()
                    self.didUpdatePokemonTypes()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Error: \(error)")
                }
            }
        }
    }
}
