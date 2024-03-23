import Firebase
import UIKit

final class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    private let usersRef = Database.database().reference().child("Users")
    
    func updateFavoritePokemon(pokemon: EnhancedPokemon, from viewController: UIViewController) {
        if let currentUser = Auth.auth().currentUser {
            guard let pokemonId = pokemon.id else { return }
            let userID = currentUser.uid
            
            let userFavoritesRef = usersRef.child(userID).child("Favorites/pokemons").child(String(pokemonId))
            
            userFavoritesRef.observeSingleEvent(of: .value) { snapshot, prevKey  in
                if snapshot.exists() {
                    self.removeFavoritePokemonForUser(pokemon: pokemon, userID: userID)
                } else {
                    self.saveFavoritePokemonForUser(pokemon: pokemon, userID: userID)
                }
            }
        } else {
            self.showLoginAlert(from: viewController)
        }
    }
    
    func saveFavoritePokemonForUser(pokemon: EnhancedPokemon, userID: String) {
        guard let pokemonId = pokemon.id else { return }
        let userFavoritesRef = usersRef.child(userID).child("Favorites/pokemons").child(String(pokemonId))
        
        var favoritePokemonDict = pokemon.toDictionary()
        
        userFavoritesRef.setValue(favoritePokemonDict)
    }
    
    func removeFavoritePokemonForUser(pokemon: EnhancedPokemon, userID: String) {
        guard let pokemonId = pokemon.id else { return }
        let userFavoritesRef = usersRef.child(userID).child("Favorites/pokemons").child(String(pokemonId))
        
        userFavoritesRef.removeValue { error, _ in
            if let error = error {
                print("Failed to remove favorite pokemon: \(error.localizedDescription)")
            } else {
                print("Favorite pokemon successfully removed")
            }
        }
    }
    
    private func showLoginAlert(from viewController: UIViewController) {
        let alertController = UIAlertController(title: "Внимание!", message: "Для сохранения выбранного покемона в список избранных необходимо авторизоваться!", preferredStyle: .alert)
        let authAction = UIAlertAction(title: "Авторизоваться", style: .default) { _ in
            if let controllers = viewController.tabBarController?.viewControllers {
                viewController.tabBarController?.selectedIndex = controllers.count - 1
            }
        }
        let closeAction = UIAlertAction(title: "Закрыть", style: .default)
        alertController.addAction(authAction)
        alertController.addAction(closeAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func fetchFavoritePokemons(completion: @escaping ([EnhancedPokemon]) -> Void) {
        let userFavoritesRef = usersRef.child(Auth.auth().currentUser?.uid ?? "").child("Favorites/pokemons")
        
        userFavoritesRef.observeSingleEvent(of: .value) { snapshot in
            if let data = snapshot.value as? [String: Any] {
                var pokemons: [EnhancedPokemon] = []
                for (_, value) in data {
                    if let pokemonDict = value as? [String: Any] {
                        if let pokemon = try? JSONSerialization.data(withJSONObject: pokemonDict),
                           let enhancedPokemon = try? JSONDecoder().decode(EnhancedPokemon.self, from: pokemon) {
                            pokemons.append(enhancedPokemon)
                            print("no1: \(enhancedPokemon)")
                        }
                    }
                }
                completion(pokemons)
            }
        }
    }
}
