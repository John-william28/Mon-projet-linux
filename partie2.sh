#!/bin/bash

# spécification de la période d'inactivité en jours
PERIODE_INACTIVITE=90

# cette commande permet d'obtenir la liste des utilisateurs inactifs depuis 90 jours en utilisant lastlog
echo "Recherche des utilisateurs inactifs depuis plus de $PERIODE_INACTIVITE jours..."
UTILISATEURS_INACTIFS=$(lastlog -b $PERIODE_INACTIVITE | awk 'NR>1 {print $1}' | grep -v 'Username')

# condition qui vérifie si des utilisateurs inactifs sont trouvés
if [ -z "$UTILISATEURS_INACTIFS" ]; then
    echo "Aucun utilisateur inactif trouvé depuis $PERIODE_INACTIVITE jours."
    exit 0
else
    echo "Les utilisateurs suivants sont inactifs depuis plus de $PERIODE_INACTIVITE jours :"
    echo "$UTILISATEURS_INACTIFS"
fi

# parcourir chaque utilisateur inactif et demander à l'administrateur ce qu'il souhaite faire
for UTILISATEUR in $UTILISATEURS_INACTIFS
do
    echo "L'utilisateur $UTILISATEUR est inactif."
    
    # proposer de verrouiller ou supprimer l'utilisateur
    read -p "Voulez-vous verrouiller ou supprimer cet utilisateur (verrouiller/supprimer/sauter) ? " REPONSE
    
    if [ "$REPONSE" == "verrouiller" ]; then
        # Verrouiller le compte en utilisant passwd -l
        sudo passwd -l $UTILISATEUR
        echo "Le compte $UTILISATEUR a été verrouillé."
    
    elif [ "$REPONSE" == "supprimer" ]; then
        # Sauvegarder le répertoire personnel avant suppression
        echo "Sauvegarde du répertoire personnel de $UTILISATEUR avant suppression..."
        tar -czvf /backup/home_${UTILISATEUR}.tar.gz /home/$UTILISATEUR
        
        # Supprimer l'utilisateur avec userdel
        sudo userdel -r $UTILISATEUR
        echo "L'utilisateur $UTILISATEUR et son répertoire personnel ont été supprimés et sauvegardés."

    else
        echo "Aucune action prise pour l'utilisateur $UTILISATEUR."
    fi
done

echo "Traitement terminé."