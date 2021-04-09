# Attaque AES 128 bits 

Auteurs : Guillaume Leinen

## Introduction au projet 

Le projet a pour but la mise en place d'une attaque matériel de type CPA-DPA sur un fpga inconnu. L'objectif étant de retrouver les sous clés ou la clé entière en analysant les traces de consommations déduite du rayonnement électromagnétique de l'objet. 

Nous disposons pour cela de 20000 mesures de 20000 textes clairs et 20000 textes chiffrés 

## Déroulé de l'attaque 

1ère étape : aperçu d'un échantillon de donnée et premières déductions 

-> Avant de planifier l'attaque, on désire avoir un aperçu des données capturés. On commence donc par afficher une des 20000 mesures de courant. 

![Aperçu du rayonnement electromagnétique de la première mesure](README.assets/figure1.jpg)

On constate d'effectivement des variations de courant, correspondant à l'algorithme de chiffrement AES. En revanche il est impossible de conclure sur les positions exactes des rounds pour TOUTES les mesures car le texte en clair choisi n'est pas le même pour chaque mesure, ce qui modifie évidemment la durée de calcul. Il faudra donc passer par une moyenne pour avoir une meilleure donnée relative au déroulé de l'algorithme. 

![Moyenne des signatures electromagnétiques sur 20000 mesures](README.assets/figure2.jpg) 

En effet, on voit mieux les pics correspondant aux rounds de l'algorithme AES. Seul un pic est présent en trop, il s'agit de l'initialisation du code VHDL, et il est donc à ignorer. On peut donc conclure que le dernier round, sur lequel on va baser notre attaque, se situe aux alentours du 3000-3500ème point. 





