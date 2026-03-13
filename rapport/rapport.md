# 🎵 Rapport de Projet : Application Visual Harmony

Ce rapport documente le fonctionnement de l'application de musique développée sous Flutter et récapitule les compétences acquises en langage de balisage **Markdown**.

---

## ⚙️ I. Fonctionnement de l'Application Dart/Flutter

L'application a été conçue pour offrir une expérience utilisateur fluide, similaire à Spotify, en utilisant les concepts suivants :

### 1. Gestion Audio Globale
* **Instance Unique** : Nous utilisons une variable `final AudioPlayer globalAudioPlayer = AudioPlayer();` définie en dehors des classes pour que la musique ne se coupe pas lors du changement de page.
* **Synchronisation** : Des écouteurs (`listeners`) surveillent l'état de la lecture pour mettre à jour l'icône Play/Pause simultanément sur la page d'accueil et le lecteur.

### 2. Architecture de Navigation
* **Stack & Positioned** : La page d'accueil utilise un widget `Stack` pour superposer un **Mini Player** au-dessus de la liste des chansons.
* **Navigator.pop** : Pour revenir en arrière, nous utilisons `Navigator.pop(context)`, ce qui permet de fermer l'écran du lecteur sans détruire l'état de l'application. L'application contien aussi une API integre pour gerer les tendances et le News en musique.

### 3. Résolution des Erreurs (Debug)
* **Null Safety** : Nous avons implémenté des vérifications (`currentSongTitle != null`) pour éviter les écrans rouges (crashs) lorsque aucune donnée n'est chargée.
* **Syntaxe Dart** : Correction des erreurs de parenthèses fermantes `)` et d'accolades `}` dans les fonctions asynchrones.

---

## 📝 II. Rapport d'Apprentissage : Le Langage Markdown

Au cours de ce projet, j'ai appris à structurer des documents techniques sans utiliser d'éditeur visuel complexe. Voici les notions et syntaxes maîtrisées :

### 1. Structure de l'Information
* **Les Titres** : Utilisation du symbole `#`. Plus il y a de `#`, plus le titre est petit (ex: `#` pour H1, `##` pour H2).
* **Lignes de Séparation** : Utilisation de `---` pour créer des divisions horizontales nettes entre les sections.

### 2. Mise en Forme du Texte
* **Gras** : Entourer le texte de deux astérisques `**Texte en gras**`.
* **Italique** : Entourer le texte d'un seul astérisque `*Texte en italique*`.
* **Code en ligne** : Utilisation des accents graves (backticks) `` `code` `` pour mettre en évidence des variables ou des petites lignes de code.

### 3. Listes et Éléments Visuels
* **Listes à puces** : Utilisation du tiret `-` ou de l'astérisque `*` pour organiser des points clés.
* **Emojis** : Intégration d'emojis pour rendre le rapport plus moderne et lisible.

### 4. Blocs de Code
J'ai appris à insérer des blocs de code entiers en utilisant trois backticks (
http://googleusercontent.com/immersive_entry_chip/0

---

### Pourquoi ce rapport est utile pour vous :
* **Professionnalisme** : Si vous partagez votre code sur GitHub, c'est ce fichier que les gens liront en premier.
* **Mémoire technique** : Il résume les erreurs que vous avez rencontrées (parenthèses, null checks) pour ne plus les refaire.

**Souhaitez-vous que je vous aide à transformer ce rapport en une présentation PDF ou à ajouter des liens vers vos réseaux sociaux à la fin ?**