#!/bin/bash

# Fonction pour créer un fichier
create_file() {
    mkdir -p "$(dirname "$1")"
    touch "$1"
    echo "Fichier créé : $1"
}

# Création de la structure de base
mkdir -p {Models,ViewModels,Views/{User,Task,Device,Statistic,Calendar,Shopping},Services,FirebaseServices,Intents,Utils}

# Création des fichiers dans Models
for file in User TaskItem Device Statistic CalendarEvent ShoppingItem Enums; do
    create_file "Models/${file}.swift"
done

# Création des fichiers dans ViewModels
for file in User Task Device Statistic Calendar Shopping; do
    create_file "ViewModels/${file}ViewModel.swift"
done

# Création des fichiers dans Views
create_file "Views/User/UserListView.swift"
create_file "Views/User/UserDetailView.swift"
create_file "Views/Task/TaskListView.swift"
create_file "Views/Task/TaskDetailView.swift"
create_file "Views/Device/DeviceListView.swift"
create_file "Views/Device/DeviceControlView.swift"
create_file "Views/Statistic/StatisticView.swift"
create_file "Views/Calendar/CalendarListView.swift"
create_file "Views/Calendar/CalendarDetailView.swift"
create_file "Views/Shopping/ShoppingListView.swift"
create_file "Views/Shopping/ShoppingDetailView.swift"

# Création des fichiers dans Services
for file in HomeKit Alexa Statistics Calendar Shopping Notification; do
    create_file "Services/${file}Service.swift"
done

# Création des fichiers dans FirebaseServices
create_file "FirebaseServices/FirebaseAuthService.swift"
create_file "FirebaseServices/FirestoreService.swift"
create_file "FirebaseServices/FirebaseConfig.swift"

# Création des fichiers dans Intents
create_file "Intents/AddToShoppingListIntentHandler.swift"
create_file "Intents/IntentDefinitions.intentdefinition"

# Création du fichier dans Utils
create_file "Utils/DateFormatter.swift"

echo "Structure de fichiers HeFamily créée avec succès!"