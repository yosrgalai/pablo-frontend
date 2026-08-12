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

  /// La carte peut être tapée (léger relief / bordure au survol-tap).
  selectable,

  /// La carte est actuellement sélectionnée (bordure or + léger zoom).
  selected,

  /// La carte n'est pas interactive dans ce contexte (opacité réduite).
  disabled,
}

/// Couleurs du design system (doc 03), utilisées pour les bordures d'état
/// et le rendu de secours (fallback) si une image est introuvable.
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
/// (rang + enseigne en texte) est affiché à la place — pratique en
/// développement pour repérer immédiatement un nom de fichier incorrect
/// sans que l'app plante ni affiche un écran blanc.
///
/// NB : on utilise volontairement des PNG, pas du SVG. Le pack SVG-cards
/// (Inkscape) référence ses dégradés AVANT leur définition dans le XML,
/// ce que `flutter_svg` (parseur strict) ne supporte pas — voir les
/// erreurs `Failed to find definition for #linearGradient...`. Convertir
/// une fois en PNG évite ce problème définitivement.
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
    // Valeur initiale directe (pas d'animation au premier affichage) :
    // 0 = face cachée visible, 1 = face visible.
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: widget.card.hidden ? 0 : 1,
    );
  }

  @override
  void didUpdateWidget(CardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // On ne déclenche le flip QUE si l'état hidden a réellement changé
    // (ex: fin de INITIAL_PEEK, révélation de fin de manche, pouvoir 8).
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
        scale: isSelected ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
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
                        // Contre-rotation : sans elle, la face apparaît "en
                        // miroir" au repos (angle = pi quand hidden=false).
                        transform: Matrix4.identity()..rotateY(math.pi),
                        child: _buildFace(isSelected: isSelected, isSelectable: isSelectable),
                      )
                    : _buildBack(isSelected: isSelected, isSelectable: isSelectable),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBack({required bool isSelected, required bool isSelectable}) {
    return _CardShell(
      width: widget.width,
      height: widget.height,
      borderColor: _borderColor(isSelected, isSelectable),
      child: Image.asset(
        CardAssets.backPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallbackBack(),
      ),
    );
  }

  Widget _buildFace({required bool isSelected, required bool isSelectable}) {
    final assetPath = CardAssets.pathFor(widget.card);

    return _CardShell(
      width: widget.width,
      height: widget.height,
      borderColor: _borderColor(isSelected, isSelectable),
      child: assetPath == null
          ? _fallbackFace() // rank/suit manquant malgré hidden=false -> anomalie de données
          : Image.asset(
              assetPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _fallbackFace(),
            ),
    );
  }

  Color _borderColor(bool isSelected, bool isSelectable) {
    if (isSelected) return _CardColors.accentGold;
    if (isSelectable) return _CardColors.accentGold.withValues(alpha: 0.4);
    return Colors.black.withValues(alpha: 0.15);
  }

  // --- Rendus de secours (asset manquant ou donnée incohérente) ---

  Widget _fallbackBack() {
    return Container(
      color: _CardColors.fallbackBack,
      child: Center(
        child: Icon(
          Icons.style_outlined,
          color: _CardColors.accentGold.withValues(alpha: 0.6),
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

/// Coquille commune (dimensions, coins arrondis, bordure, ombre) partagée
/// entre face et dos, pour garantir un rendu strictement identique.
class _CardShell extends StatelessWidget {
  const _CardShell({
    required this.width,
    required this.height,
    required this.borderColor,
    required this.child,
  });

  final double width;
  final double height;
  final Color borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.12),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}