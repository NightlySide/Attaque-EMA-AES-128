# Projet - Attaque EMA AES 128

> Rédigé par :
>
> -   [Alexandre FROEHLICH](https://nightlyside.github.io/)
> -   Guillaume LEINEN

## Cahier des charges

1. Tracer une courbe de consommation afin de déterminer le début et la fin du chiffrement.
2. Tracer la moyenne des courbes de consommation afin de repérer le début et la fin du dernier round.
3. Vous démontrerez que le modèle “poids de Hamming” peut également être appliqué au dernier round,vous pouvez par exemple vous aider du schéma de l’AES-128 proposé dans les TE3-4.
4. Sélectionner la partie de la courbe correspondant au dernier round afin d’optimiser la vitesse de l’attaque.
5. A partir des hypothèses de clé, calculer les valeurs intermédiaires correspondant au point d’attaque.
6. Pour chacune des valeurs intermédiaires, utiliser un modèle de consommation afin de déterminer une hypothèse de consommation à partir du message chiffré et non du message clair comme étudié dans leTE5. Vous utiliserez des matrices utilisant une troisième dimension afin de découper vos hypothèses à l’aide de sous-clé de 8 bits, expliquer pourquoi ce choix est valide.
7. Utiliser les modèles statistiques d’ordre un et deux pour trouver l’hypothèse correspondant le mieux aux consommations mesurées.
8. Etudier la métrique “Guessing Entropy” et proposer une implémentation capable d’optimiser le nombre de traces à étudier pour un test statistique à l’ordre deux.
