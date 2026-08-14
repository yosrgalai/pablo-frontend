import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../data/models/card_model.dart';
import 'card_assets.dart';

/// États d'interaction visuels d'une carte (voir design system, section 3).
///
/// NB : `hidden` (face cachée/visible) n'est PAS ici — c'est une propriété
/// intrinsèque de [CardModel], pas un état d'interaction. Ce enum ne gère
/// que la façon dont l'utilisateur peut interagir avec la carte.
enum CardVisualState {
  /// Affichage normal, pas d'action possible dessus dans ce contexte.
  normal,

  /// La carte peut être tapée (halo doré discret).
  selectable,

  /// La carte est actuellement sélectionnée (halo fort + badge ✓ + zoom).
  selected,

  /// La carte n'est pas interactive dans ce contexte (opacité réduite).
  disabled,
}

/// Couleurs du design system (doc 03), utilisées pour les indicateurs
/// d'état et le rendu de secours (fallback) si une image est introuvable.
///
/// TODO(commun): à terme, centraliser ces couleurs dans
/// `core/theme/app_theme.dart` une fois le thème global construit.
class _CardColors {
  _CardColors._();

  static const Color fallbackBack = Color(0xFF1B1F3B);
  static const Color fallbackFace = Color(0xFFFDFDFD);
  static const Color accentGold = Color(0xFFE0B24C);
  static const Color danger = Color(0xFFD64545);
  static const Color textDark = Color(0xFF1B1F3B);
}

/// Carte à jouer, unique composant utilisé partout dans le jeu :
/// main du joueur, mains adverses (cachées), pioche, défausse.
///
/// Affiche des images PNG (voir [CardAssets]). Si une image est
/// introuvable (asset manquant/mal nommé), un rendu de secours dessiné
/// (rang + enseigne en texte) est affiché à la place.
///
/// IMPORTANT (UX) : les indicateurs d'état (`selectable`/`selected`) sont
/// un HALO EXTÉRIEUR + un badge, pas une simple bordure — le dos de carte
/// généré a lui-même une bordure dorée intégrée à l'image, donc une
/// bordure seule s'y noierait visuellement et deviendrait indiscernable.
///
/// NB : on utilise volontairement des PNG, pas du SVG (voir historique :
/// le pack SVG-cards référence ses dégradés avant leur définition, ce que
/// `flutter_svg` ne supporte pas).
class CardWidget extends StatefulWidget {
  const CardWidget({
    super.key,
    required this.card,
    this.visualState = CardVisualState.normal,
    this.onTap,
    this.width = 60,
    this.height = 90,
  });

  final CardModel card;
  final CardVisualState visualState;
  final VoidCallback? onTap;
  final double width;
  final double height;

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: widget.card.hidden ? 0 : 1,
    );
  }

  @override
  void didUpdateWidget(CardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.card.hidden != widget.card.hidden) {
      if (widget.card.hidden) {
        _flipController.reverse();
      } else {
        _flipController.forward();
      }
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.visualState == CardVisualState.disabled;
    final isSelected = widget.visualState == CardVisualState.selected;
    final isSelectable = widget.visualState == CardVisualState.selectable;

    return GestureDetector(
      onTap: isDisabled ? null : widget.onTap,
      child: AnimatedScale(
        scale: isSelected ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Opacity(
          opacity: isDisabled ? 0.45 : 1.0,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.width * 0.12 + 4),
                  boxShadow: _glowShadows(isSelected, isSelectable),
                ),
                child: AnimatedBuilder(
                  animation: _flipController,
                  builder: (context, _) {
                    final angle = _flipController.value * math.pi;
                    final showFace = _flipController.value >= 0.5;

                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle),
                      child: showFace
                          ? Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateY(math.pi),
                              child: _buildFace(),
                            )
                          : _buildBack(),
                    );
                  },
                ),
              ),
              if (isSelected) _buildSelectedBadge(),
            ],
          ),
        ),
      ),
    );
  }

  /// Halo lumineux EXTÉRIEUR à la carte — se détache toujours nettement du
  /// fond de table, quel que soit le contenu de l'image (dos ou face).
  List<BoxShadow> _glowShadows(bool isSelected, bool isSelectable) {
    if (isSelected) {
      return [
        BoxShadow(color: _CardColors.accentGold.withOpacity(0.9), blurRadius: 14, spreadRadius: 2),
      ];
    }
    if (isSelectable) {
      return [
        BoxShadow(color: _CardColors.accentGold.withOpacity(0.45), blurRadius: 8, spreadRadius: 0.5),
      ];
    }
    return const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))];
  }

  /// Badge ✓ en haut à droite, visible uniquement quand sélectionnée —
  /// signal sans ambiguïté possible, indépendant de tout artwork.
  Widget _buildSelectedBadge() {
    final size = widget.width * 0.32;
    return Positioned(
      top: -size * 0.3,
      right: -size * 0.3,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: _CardColors.accentGold,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 3)],
        ),
        child: Icon(Icons.check, color: Colors.black, size: size * 0.7),
      ),
    );
  }

  Widget _buildBack() {
    return _CardShell(
      width: widget.width,
      height: widget.height,
      child: Image.asset(
        CardAssets.backPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallbackBack(),
      ),
    );
  }

  Widget _buildFace() {
    final assetPath = CardAssets.pathFor(widget.card);

    return _CardShell(
      width: widget.width,
      height: widget.height,
      child: assetPath == null
          ? _fallbackFace()
          : Image.asset(
              assetPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _fallbackFace(),
            ),
    );
  }

  // --- Rendus de secours (asset manquant ou donnée incohérente) ---

  Widget _fallbackBack() {
    return Container(
      color: _CardColors.fallbackBack,
      child: Center(
        child: Icon(
          Icons.style_outlined,
          color: _CardColors.accentGold.withOpacity(0.6),
          size: widget.width * 0.5,
        ),
      ),
    );
  }

  Widget _fallbackFace() {
    final card = widget.card;
    final rank = card.rank ?? '?';
    final suit = card.suit ?? '';
    final isRed = card.isRedSuit ?? false;
    final valueColor = isRed ? _CardColors.danger : _CardColors.textDark;

    return Container(
      color: _CardColors.fallbackFace,
      padding: EdgeInsets.all(widget.width * 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rank,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.bold,
              fontSize: widget.width * 0.28,
              height: 1,
            ),
          ),
          Text(
            suit,
            style: TextStyle(color: valueColor, fontSize: widget.width * 0.24, height: 1),
          ),
        ],
      ),
    );
  }
}

/// Coquille commune (dimensions, coins arrondis, ombre de base) partagée
/// entre face et dos, pour garantir un rendu strictement identique.
/// Ne gère plus la bordure d'état : c'est le halo (`_glowShadows`) qui
/// porte cette information désormais.
class _CardShell extends StatelessWidget {
  const _CardShell({
    required this.width,
    required this.height,
    required this.child,
  });

  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.12),
        border: Border.all(color: Colors.black.withOpacity(0.2), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}