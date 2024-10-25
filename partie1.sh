#!/bin/bash

# fichier contenant la liste des utilisateurs
USER_FILE="user.txt"

# fonction pour générer un mot de passe aléatoire
generer_mot_de_passe() {
    echo "$(tr -dc A-Za-z0-9 </dev/urandom | head -c 12)"
}

# vérification si le fichier des utilisateurs existe
if [ ! -f "$USER_FILE" ]; then
    echo "Le fichier $USER_FILE n'existe pas."
    exit 1
fi

# boucle à travers chaque ligne du fichier
while IFS=',' read -r username group shell home_dir; do

    # vérification si l'utilisateur existe déjà
    if id "$username" &>/dev/null; then
        echo "L'utilisateur $username existe déjà, modification en cours."

        # modification du groupe et du répertoire de l'utilisateur
        usermod -g "$group" -d "$home_dir" "$username"
        
        echo "Informations de $username mises à jour : groupe=$group, home=$home_dir."
    
    else
        echo "Ajout de l'utilisateur $username."
        
        # création de l'utilisateur avec le groupe, le shell, et le répertoire personnel
        useradd -g "$group" -s "$shell" -d "$home_dir" -m "$username"
        
        if [ $? -eq 0 ]; then
            echo "Utilisateur $username ajouté avec succès."
        else
            echo "Erreur lors de l'ajout de l'utilisateur $username."
            continue
        fi
    fi

    # Génération d'un mot de passe aléatoire
    password=$(generer_mot_de_passe)

    # Définition du mot de passe et forçage de la modification au premier login
    echo "$username:$password" | chpasswd
    passwd --expire "$username"

    # Communication sécurisée (par exemple via email ou autre méthode sécurisée)
    echo "Mot de passe généré pour $username : $password"

done < user.txt


       

