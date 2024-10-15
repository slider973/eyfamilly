import SwiftUI
import FirebaseAuth
class UserViewModel: ObservableObject {
    @Published var currentUser: User?
    private let authService: FirebaseAuthService
    private let firestoreService: FirestoreService
    
    init(authService: FirebaseAuthService, firestoreService: FirestoreService) {
        self.authService = authService
        self.firestoreService = firestoreService
        setupCurrentUserListener()
    }
    
    func signIn(email: String, password: String) {
        // Implémentation de la connexion
    }
    
    func signOut() {
        // Implémentation de la déconnexion
    }
    
    private func setupCurrentUserListener() {
        // Configurer un listener pour les changements de l'utilisateur actuel
    }
}

// Algorithme :
// 1. Créer une classe UserViewModel qui gère l'état de l'utilisateur
// 2. Utiliser @Published pour notifier les vues des changements
// 3. Implémenter des méthodes pour la connexion, déconnexion et la gestion de l'utilisateur actuel
// 4. Utiliser les services Firebase pour l'authentification et Firestore
