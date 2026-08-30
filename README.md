# Pablo — Documentation d'architecture

> Jeu de cartes multijoueur en temps réel, inspiré du jeu **Cabo/Pablo**.
> Backend **NestJS** (WebSocket + REST) — Frontend **Flutter** (BLoC).

Ce document a 3 objectifs : comprendre le **backend**, comprendre le **frontend**, et surtout comprendre **le lien entre les deux** (le contrat d'événements Socket.IO), qui est le cœur de l'architecture temps réel de ce projet.

---

## Sommaire

1. [Vue d'ensemble](#1-vue-densemble)
2. [Règles du jeu (résumé fonctionnel)](#2-règles-du-jeu-résumé-fonctionnel)
3. [Backend (NestJS)](#3-backend-nestjs)
4. [Frontend (Flutter)](#4-frontend-flutter)
5. [Le lien : contrat d'événements Socket.IO](#5-le-lien--contrat-dévénements-socketio)
6. [Limitations connues](#6-limitations-connues)
7. [Lancer le projet](#7-lancer-le-projet)

---

## 1. Vue d'ensemble

### Stack technique

| Couche | Techno |
|---|---|
| Backend | NestJS, Socket.IO (WebSocket), REST (lobby) |
| Frontend | Flutter, `flutter_bloc` (BLoC pattern), `freezed` (modèles immuables) |
| Communication temps réel | Socket.IO — namespace `/game`, une **room** par partie (`game:{gameId}`) |
| Communication ponctuelle | REST — création/jointure de partie, snapshot du lobby |

### Schéma général

```
┌─────────────────────┐        WebSocket (/game)        ┌──────────────────────┐
│   Flutter Client A   │ ◄──────────────────────────────► │                      │
│  (GameRepository)    │        + REST (lobby)            │   NestJS Backend     │
└─────────────────────┘ ◄──────────────────────────────► │  GameGateway         │
                                                            │  GameService         │
┌─────────────────────┐        WebSocket (/game)          │  CardService         │
│   Flutter Client B   │ ◄──────────────────────────────► │  TurnService         │
│  (GameRepository)    │        + REST (lobby)             │                      │
└─────────────────────┘                                    └──────────────────────┘
```

Chaque client Flutter détient sa **propre copie locale** de l'état visible (sa main, les mains cachées des adversaires, la défausse, la pioche). Le serveur est la **seule source de vérité** : il ne révèle jamais une carte à un client qui n'a pas le droit de la connaître (règle de sécurité centrale du projet, cf. §5).

---

## 2. Règles du jeu (résumé fonctionnel)

- Chaque joueur reçoit 4 cartes cachées. Il en regarde 2 au début de la manche (**peek initial**) et doit ensuite s'en souvenir.
- À son tour, un joueur **pioche** une carte, puis choisit de :
  - l'**échanger** avec une carte de sa main (l'ancienne carte part en défausse, révélée), ou
  - la **défausser** directement.
- Si la carte défaussée est un **7, 8 ou 9**, un pouvoir est disponible :
  - **7** — regarder une de ses propres cartes cachées (privé).
  - **8** — espionner une carte cachée d'un adversaire (privé).
  - **9** — échanger à l'aveugle une carte avec un adversaire, sans jamais voir aucune des deux (public, mais rien n'est révélé).
- À tout moment (pas seulement à son tour, selon l'implémentation actuelle : **avant de piocher, à son tour**), un joueur peut tenter de défausser une **paire** (2 cartes de même rang) :
  - réussite → les 2 cartes quittent sa main.
  - échec → **pénalité** : 1 carte supplémentaire piochée et ajoutée à sa main.
- **Valeur des cartes** (utilisée pour le score) :

  | Carte | Valeur |
  |---|---|
  | As | 10 |
  | 2 à 10 | valeur faciale |
  | Valet / Dame | 10 |
  | **Roi noir** (♠ ♣) | 10 |
  | **Roi rouge** (♥ ♦) | **0** ⚠️ (seule exception) |
  | Joker | 0 |

- **Annoncer "Pablo"** : à son tour, avant de piocher, un joueur peut annoncer "Pablo" à la place de jouer normalement. La manche se termine **immédiatement**, toutes les cartes sont révélées.
  - Si l'auteur a le score strictement le plus bas → il gagne.
  - Si un autre joueur a un score égal ou inférieur → l'auteur prend une pénalité (ex: +5 points).

---

## 3. Backend (NestJS)

### 3.1 Structure

```
src/
├── game/
│   ├── game.gateway.ts      # Point d'entrée WebSocket, orchestration des events
│   ├── game.service.ts      # Logique de partie (dealing, tours, scoring, Pablo)
│   ├── turn/
│   │   └── turn.service.ts  # Validation de tour, timeouts (déco, pouvoir)
│   └── events.constants.ts  # ClientEvents / ServerEvents (noms des events socket)
├── card/
│   └── card.service.ts      # Logique carte : draw, swap, discard, pouvoirs, paires
└── common/
    └── dto/                 # Validation des payloads entrants (class-validator)
```

### 3.2 Machine à états d'une manche

```
DEALING → INITIAL_PEEK → PLAYER_TURN → ROUND_SCORING → GAME_OVER
                              ↑    │
                              └────┘ (rotation normale entre joueurs)
```

- **DEALING** : distribution des cartes (`game:dealt` broadcast + `hand:positions` privé à chacun).
- **INITIAL_PEEK** : chaque joueur choisit 2 positions à regarder (`choose_initial_peek`).
- **PLAYER_TURN** : boucle principale (piocher / échanger / défausser / pouvoir / paire / annoncer Pablo).
- **ROUND_SCORING** : cartes révélées, scores calculés (`round:ended`).
- **GAME_OVER** : score limite atteint (`game:ended`).

### 3.3 `GameGateway` — responsabilités

Le Gateway est **la seule couche qui parle Socket.IO** : il valide les payloads entrants (DTOs), délègue toute la logique métier à `GameService`/`CardService`/`TurnService`, puis décide **qui reçoit quoi** :

- `client.emit(...)` → **uniquement l'auteur de l'action** (ex : la carte piochée, la carte de pénalité — jamais révélée à quelqu'un d'autre).
- `client.broadcast.to(room).emit(...)` → **tout le monde sauf l'auteur** (déjà notifié en privé).
- `server.to(room).emit(...)` → **toute la room, auteur inclus** (rien de secret à protéger).

C'est ce choix, événement par événement, qui garantit qu'aucune carte cachée ne fuite vers un client qui n'a pas le droit de la voir.

### 3.4 Timeouts

| Timeout | Durée | Rôle |
|---|---|---|
| Reconnexion | 30s | Un joueur déconnecté a 30s pour revenir avant d'être exclu de la partie (`TurnService.startReconnectionTimeout`). |
| Pouvoir | 30s | Un joueur qui ne choisit pas de cible pour un pouvoir (7/8/9) dans les 30s voit son pouvoir annulé et le tour passe au suivant. |

### 3.5 REST vs WebSocket — qui fait quoi

| Besoin | Canal | Pourquoi |
|---|---|---|
| Créer/rejoindre une partie | REST | Opération ponctuelle, avant que le socket ne soit utile |
| Snapshot du lobby (liste des joueurs) | REST (`findOne`) | Polling léger en salle d'attente |
| Toute action de jeu (piocher, échanger...) | WebSocket | Temps réel, doit être broadcast à la room |
| ⚠️ Taille de main en cours de partie | **Aucun des deux n'est fiable actuellement** | `findOne` n'est pas mis à jour en direct pendant le round — voir §6 |

---

## 4. Frontend (Flutter)

### 4.1 Structure (features)

```
lib/
├── core/
│   ├── di/injector.dart          # Service locator (get_it)
│   ├── network/socket_service.dart
│   └── theme/app_theme.dart
├── data/
│   ├── models/                   # CardModel, PlayerModel, RoundModel (freezed)
│   └── repositories/
│       └── game_repository.dart  # Seul point de contact avec le socket + REST
└── features/
    ├── auth_lobby/
    │   ├── bloc/lobby_bloc.dart
    │   ├── screens/lobby_screen.dart
    │   └── widgets/player_list_item.dart
    └── game/
        ├── bloc/game_bloc.dart           # Machine à états DE LA MANCHE
        ├── screens/
        │   ├── game_flow_screen.dart     # Routeur selon l'état du GameBloc
        │   └── game_table_screen.dart    # Écran de jeu réel, tient l'état local
        └── widgets/
            ├── game_turn_controller.dart # Machine à états DU TOUR (piocher/échanger/pouvoirs...)
            ├── game_table_layout.dart    # Disposition visuelle (arc adversaires, centre, main)
            ├── opponent_seat_widget.dart
            ├── card_widget.dart          # Composant carte unique (face/dos, flip animé)
            ├── card_flight_layer.dart    # Animations de vol de carte (remplace les labels texte)
            ├── draw_pile_widget.dart / discard_pile_widget.dart
            ├── draw_decision_sheet.dart  # "Échanger avec ma main" / "Défausser"
            ├── pablo_button.dart
            └── card_scoring_info_sheet.dart / scoring_info_button.dart
```

### 4.2 Gestion d'état : deux BLoCs distincts

- **`LobbyBloc`** — salle d'attente : création/jointure de partie, polling des joueurs connectés, démarrage de la partie.
- **`GameBloc`** — machine à états de la **manche** (DEALING → INITIAL_PEEK → PLAYER_TURN → ROUND_SCORING → GAME_OVER), miroir du state machine backend (§3.2). Ne gère **pas** le détail d'un tour (ça, c'est `GameTurnController`, en dessous).

### 4.3 `GameRepository` — le pont unique vers le serveur

Toutes les communications socket/REST passent par ce repository :
- Des **méthodes** pour chaque action client → serveur (`drawCard`, `swapCard`, `discardCard`, `pairAttempt`, `powerSelfPeek`, `powerSpy`, `powerBlindSwap`, `callPablo`, `startGame`...).
- Des **`Stream`** pour chaque event serveur → client (`onGameDealt`, `onCardSwapped`, `onCardDiscarded`, `onPowerTargetSelected`, `onPenaltyCardDrawn`, `onTurnStarted`, `onCaboCalled`, `onRoundEnded`, `onGameEnded`, `onError`...).

Aucun autre fichier du frontend ne touche directement au socket — c'est le seul point de couplage avec le contrat d'events (§5), ce qui limite l'impact d'un changement backend à ce seul fichier.

### 4.4 `GameTurnController` — la machine à états du tour

Contrairement à `GameBloc` (état de la manche), ce widget gère l'état **local et interactif** d'un tour en cours : `idle` → `drawing` → (`swapMode` | pouvoir 7/8/9 | `pairMode`) → retour à `idle`. C'est lui qui décide quels boutons sont actifs, quelles cartes sont sélectionnables, etc.

### 4.5 Animations : `CardFlightLayer`

Plutôt que d'afficher du texte ("échange une carte"...), les actions des adversaires sont visualisées par un **vrai mouvement de carte** à l'écran :
- une `GlobalKey` par ancrage (pioche, défausse, main locale, siège de chaque adversaire), possédées par `GameTableScreen` ;
- `CardFlightLayer` calcule la position réelle de ces ancrages et anime une carte entre deux points ;
- une carte reste **cachée** pendant tout le vol sauf si elle doit se révéler à l'arrivée (ex: une carte échangée qui atterrit en défausse) — jamais avant, pour rester fidèle à ce qu'un joueur peut réellement savoir à cet instant.

---

## 5. Le lien : contrat d'événements Socket.IO

C'est la partie la plus critique à comprendre : **quel event, dans quel sens, et à qui**.

### 5.1 Client → Serveur

| Event (`ClientEvents`) | Déclenché par | DTO |
|---|---|---|
| `join_game` | Rejoindre la room socket d'une partie | `JoinGameDto` |
| `start_game` | L'hôte démarre la partie | `StartGameDto` |
| `get_hand_positions` | Filet de sécurité si `hand:positions` a été manqué | `GetHandPositionsDto` |
| `choose_initial_peek` | Choix des 2 cartes à regarder | `ChooseInitialPeekDto` |
| `turn:draw` | Piocher | `DrawCardDto` |
| `turn:swap` | Échanger la carte piochée avec la main | `SwapCardDto` |
| `turn:discard` | Défausser la carte piochée | `DiscardCardDto` |
| `power_target` | Choisir une cible pour un pouvoir (7/8/9) | `PowerTargetDto` |
| `attempt_pair` | Tenter de défausser une paire | `PairAttemptDto` |
| `call_pablo` | Annoncer "Pablo" | `CallPabloDto` |

### 5.2 Serveur → Client

| Event (`ServerEvents`) | Portée | Contenu | Note |
|---|---|---|---|
| `game:joined` | Privé (auteur) | `{ gameId, playerId }` | Confirmation de connexion |
| `game:dealt` | **Broadcast** | `{ gameId }` | Payload minimal — pas de liste de joueurs (vient du REST) |
| `hand:positions` | Privé (par joueur) | `{ cards }` | 4 positions, sans valeurs |
| `player:peeked_initial` | Privé (auteur) | `{ playerId, cards }` | Les 2 cartes choisies, révélées |
| `turn:started` | **Broadcast** | `{ playerId }` | Qui a la main |
| `turn:drew_card` | Privé **sauf pénalité** | carte complète | ⚠️ Réutilisé pour la pénalité de paire ratée : **2 emits distincts** (privé avec la carte à l'auteur, broadcast **sans la carte** `{penalty:true, playerId}` aux autres) — voir §6 pour l'historique du bug corrigé ici |
| `turn:swapped_card` | **Broadcast** | résultat de l'échange (carte révélée) | Rien de secret : la carte était de toute façon destinée à la défausse |
| `turn:discarded_card` | **Broadcast** | carte seule, ou `{discardedCards: [...]}` pour une paire | idem |
| `power:activated` | **Broadcast** | `{ playerId, rank }` | Signale qu'un pouvoir est en attente de cible |
| `power:target_selected` | Privé **pour 7/8**, **broadcast pour 9** | `{ card }` (privé) ou `{ swapped }` (broadcast, aucune carte) | Le champ `isPrivate` décidé côté `CardService.resolvePower` pilote ce choix dans le Gateway |
| `cabo:called` | **Broadcast** | `{ playerId }` | Annonce Pablo |
| `round:ended` | **Broadcast** | `{ roundScores }` | Fin de manche |
| `game:ended` | **Broadcast** | `{ winner }` | Fin de partie |
| `error` | Ciblé (room ou socket selon le cas) | `{ message }` | Erreurs métier ou de déconnexion |

### 5.3 Règle d'or du projet

> **Une carte cachée ne doit jamais être envoyée à un client qui n'a pas le droit de la connaître.**
> C'est la contrainte qui dicte, event par événement, le choix entre `client.emit` (privé) et `server.to(room).emit` (broadcast) côté Gateway — et donc directement ce que chaque `Stream` du `GameRepository` peut ou ne peut pas recevoir côté Flutter.

---

## 6. Limitations connues

| Limitation | Impact | Statut |
|---|---|---|
| `turn:drew_card` (pénalité de paire) était strictement privé à l'auteur | Les adversaires ne voyaient jamais la main d'un joueur grandir après une pénalité | ✅ Corrigé : broadcast ajouté côté `GameGateway.handleAttemptPair`, sans révéler la carte |
| `findOne` (REST) ne reflète pas la main en temps réel pendant une manche | Ne peut pas servir de filet de secours pour resynchroniser `handSize` en cours de partie | ⚠️ Ouvert — nécessiterait que le snapshot REST reflète l'état live, ou reste simplement inutile pour ce cas d'usage |
| Forme exacte du payload `power:target_selected` (pouvoir 9) non documentée formellement | Le frontend tente plusieurs clés plausibles (`opponentId`, `targetPlayerId`, `targetId`) pour identifier la cible ; si aucune ne correspond, l'animation dégrade vers un effet générique sur le siège de l'auteur | ⚠️ À confirmer avec le format réel émis par `CardService.resolvePower` |
| Nombre de cartes en pioche (`drawPileCount`) | Aucun event serveur dédié ; calculé côté client (`104 - 4×nombre de joueurs`) puis décrémenté localement à chaque pioche connue | ⚠️ Fonctionne pour le joueur qui pioche, potentiellement désynchronisé pour les autres si aucun event de mise à jour n'est broadcasté |

---

## 7. Lancer le projet

> Commandes indicatives — à ajuster selon les scripts réels définis dans `package.json` / `pubspec.yaml` du dépôt.

### Backend

```bash
cd backend_pablo
npm install
npm run start:dev
```

### Frontend

```bash
cd frontend_pablo
flutter pub get
flutter run -d chrome   # ou un device mobile/desktop connecté
```

Le frontend attend le backend disponible en local (URL configurée dans `core/network/socket_service.dart`).
