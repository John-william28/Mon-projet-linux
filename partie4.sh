#!/bin/bash

# mon répertoire
REPERTOIRE="/home/johnwill/cours_linux/seance4/partie1"


GROUP_RH="groupRH"
GROUP_DIRECTION="groupeDirection"

# permissions group_RH: lecture 
echo "Configuration des permissions pour le groupe $GROUP_RH sur $REPERTOIRE..."
setfacl -m g:$GROUP_RH:rx $REPERTOIRE
setfacl -d -m g:$GROUP_RH:rx $REPERTOIRE

# permissions group_direction : lecture et écriture
echo "Configuration des permissions pour le groupe $GROUP_DIRECTION sur $REPERTOIRE..."
setfacl -m g:$GROUP_DIRECTION:rwx $REPERTOIRE
setfacl -d -m g:$GROUP_DIRECTION:rwx $REPERTOIRE

# Afficher les ACL configurées pour vérification
echo "Les permissions ACL actuelles pour le répertoire $REPERTOIRE sont :"
getfacl $REPERTOIRE
