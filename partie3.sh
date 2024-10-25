#!/bin/bash

# ici nous avons la fonction pour créer un groupe fonctionel
creer_groupe() {
    local NOM_GROUPE=$1
    
    # la condition vérifie si le groupe existe déjà
    if getent group "$NOM_GROUPE" > /dev/null 2>&1; then
        echo "Le groupe $NOM_GROUPE existe déjà."
    else
        sudo groupadd "$NOM_GROUPE"
        echo "Le groupe $NOM_GROUPE a été créé."
    fi
}

# fonction pour ajouter un utilisateur à un groupe
ajouter_utilisateur_groupe() {
    local UTILISATEUR=$1
    local GROUPE=$2
    
    # la condition vérifie si l'utilisateur existe
    if id "$UTILISATEUR" &>/dev/null; then
        sudo usermod -a -G "$GROUPE" "$UTILISATEUR"
        echo "L'utilisateur $UTILISATEUR a été ajouté au groupe $GROUPE."
    else
        echo "L'utilisateur $UTILISATEUR n'existe pas."
    fi
}

# fonction pour retirer un utilisateur d'un groupe
retirer_utilisateur_groupe() {
    local UTILISATEUR=$1
    local GROUPE=$2
    
    # vérifier si l'utilisateur et le groupe existent
    if getent group "$GROUPE" > /dev/null 2>&1 && id "$UTILISATEUR" &>/dev/null; then
        sudo gpasswd -d "$UTILISATEUR" "$GROUPE"
        echo "L'utilisateur $UTILISATEUR a été retiré du groupe $GROUPE."
    else
        echo "Le groupe $GROUPE ou l'utilisateur $UTILISATEUR n'existe pas."
    fi
}

# fonction pour supprimer un groupe si aucun utilisateur n'y est associé
supprimer_groupe_si_vide() {
    local GROUPE=$1
    
    # Vérifier si le groupe existe
    if getent group "$GROUPE" > /dev/null 2>&1; then
        # Vérifier si le groupe est vide (pas d'utilisateur)
        if [ -z "$(getent group "$GROUPE" | cut -d: -f4)" ]; then
            sudo groupdel "$GROUPE"
            echo "Le groupe $GROUPE a été supprimé car il est vide."
        else
            echo "Le groupe $GROUPE contient encore des utilisateurs."
        fi
    else
        echo "Le groupe $GROUPE n'existe pas."
    fi
}

# menu pour interagir avec l'utilisateur
while true; do
    echo "Choisissez une option :"
    echo "1. Créer un groupe"
    echo "2. Ajouter un utilisateur à un groupe"
    echo "3. Retirer un utilisateur d'un groupe"
    echo "4. Supprimer un groupe s'il est vide"
    echo "5. Quitter"
    
    read -p "Entrez votre choix : " CHOIX
    
    case $CHOIX in
        1)
            read -p "Entrez le nom du groupe à créer : " NOM_GROUPE
            creer_groupe "$NOM_GROUPE"
            ;;
        2)
            read -p "Entrez le nom de l'utilisateur : " UTILISATEUR
            read -p "Entrez le nom du groupe : " GROUPE
            ajouter_utilisateur_groupe "$UTILISATEUR" "$GROUPE"
            ;;
        3)
            read -p "Entrez le nom de l'utilisateur : " UTILISATEUR
            read -p "Entrez le nom du groupe : " GROUPE
            retirer_utilisateur_groupe "$UTILISATEUR" "$GROUPE"
            ;;
        4)
            read -p "Entrez le nom du groupe : " GROUPE
            supprimer_groupe_si_vide "$GROUPE"
            ;;
        5)
            echo "Quitter..."
            break
            ;;
        *)
            echo "Option non valide."
            ;;
    esac
done