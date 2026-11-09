import 'package:flutter/material.dart';

import '../models.dart';
import '../services/db.dart';
import '../services/player.dart';
import '../theme/theme.dart';
import '../theme/tokens.dart';
import '../widgets.dart';

const _text = AppSemanticColors.colorTextMain;

/// Vista "Comunidad" (teal): Post · Audio Moments · Tus Favs.
/// Figma: "soc2", "soc3", "Tus favs".
class CommunityView extends StatefulWidget {
  const CommunityView(this.station, {super.key});
  final Station station;

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  int _tab = 0;
  late final _streams = [
    Db.itemsOf(widget.station.id, moments: false),
    Db.itemsOf(widget.station.id, moments: true),
    Db.likesOf(widget.station.id),
  ];

  @override
  Widget build(BuildContext context) {
    final s = widget.station;
    return Column(
      children: [
        ListTile(
          leading: Cover(
            s.imageUrl,
            size: CardTokens.m,
            radius: AppRadius.radiusFull,
          ),
          title: Text(s.name, style: AppTypography.h1.copyWith(color: _text)),
          subtitle: Text(
            s.description,
            style: AppTypography.body1.copyWith(color: _text),
          ),
        ),
        const Divider(color: SocialTokens.divider),
        Padding(
          padding: const EdgeInsets.all(AppPadding.paddingM12),
          child: Row(
            children: [
              for (final (i, label) in [
                'Post',
                'Audio Moments',
                'Tus Favs',
              ].indexed)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.paddingXs4,
                    ),
                    child: TuneInChip(
                      label,
                      teal: true,
                      selected: _tab == i,
                      onTap: () => setState(() => _tab = i),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: _streams[_tab],
            builder: (context, snap) {
              if (snap.hasError) {
                return EmptyState(
                  'Error: ${snap.error}',
                  icon: Icons.cloud_off,
                );
              }
              if (!snap.hasData) return loading;
              final items = snap.data!;
              if (items.isEmpty) {
                return const EmptyState(
                  'Aún no hay nada aquí',
                  icon: Icons.forum_outlined,
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.paddingL16,
                  vertical: AppPadding.paddingS8,
                ),
                itemCount: items.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppGap.gapL16),
                itemBuilder: (_, i) => ItemCard(items[i], s),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Tarjeta de post (imagen + texto + Comentar) o de audio moment
/// (portada con play + barra de progreso teal).
class ItemCard extends StatelessWidget {
  const ItemCard(this.item, this.station, {super.key, this.showComment = true});
  final Item item;
  final Station station;
  final bool showComment;

  @override
  Widget build(BuildContext context) {
    final p = Player.instance;
    final m = item.isMoment;
    return Container(
      // Medidas: ClipCardTokens (audio clip) o PostCardTokens (post).
      constraints: BoxConstraints(minHeight: m ? ClipCardTokens.minHeight : 0),
      padding: EdgeInsets.all(
        m ? ClipCardTokens.padding : PostCardTokens.padding,
      ),
      decoration: BoxDecoration(
        color: SocialTokens.cardBg,
        borderRadius: BorderRadius.circular(AppRadius.radiusXs),
      ),
      child: ListenableBuilder(
        listenable: p,
        builder: (context, _) {
          final current = p.isCurrent(item.id);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: item.isMoment ? () => p.playMoment(item, station) : null,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Cover(
                      item.imageUrl,
                      size: m ? ClipCardTokens.cover : PostCardTokens.cover,
                      radius: AppRadius.radiusS,
                    ),
                    if (item.isMoment)
                      // Botón XS "filled": círculo 24, ícono 16.
                      CircleAvatar(
                        radius: ClipCardTokens.playButton / 2,
                        backgroundColor: AppColors.neutral900,
                        child: Icon(
                          current && p.playing ? Icons.pause : Icons.play_arrow,
                          size: ClipCardTokens.playIcon,
                          color: _text,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: m ? ClipCardTokens.gap : PostCardTokens.gap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 2,
                            style: AppTypography.body1.copyWith(color: _text),
                          ),
                        ),
                        _LikeButton(item),
                      ],
                    ),
                    if (item.summary.isNotEmpty)
                      Text(
                        item.summary,
                        maxLines: 2,
                        style: AppTypography.body1.copyWith(color: _text),
                      ),
                    if (item.isMoment) _MomentProgress(item, active: current),
                    if (!item.isMoment && showComment)
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: SocialTokens.accent,
                            foregroundColor: SocialTokens.onAccent,
                            minimumSize: const Size(0, ChipTokens.height),
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => CommentsScreen(item, station),
                            ),
                          ),
                          child: Text(
                            item.commentCount > 0
                                ? 'Comentar · ${item.commentCount}'
                                : 'Comentar',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// ♥ teal: guarda el post/moment en "Tus Favs".
class _LikeButton extends StatelessWidget {
  const _LikeButton(this.item);
  final Item item;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: Store.liked,
    builder: (context, liked, _) {
      final on = liked.contains(item.id);
      return IconButton(
        visualDensity: VisualDensity.compact,
        color: on ? SocialTokens.accent : _text,
        icon: Icon(on ? Icons.favorite : Icons.favorite_border),
        onPressed: () => Db.setLike(item, !on),
      );
    },
  );
}

/// Barra teal del audio moment: avanza solo si es el que está sonando.
class _MomentProgress extends StatelessWidget {
  const _MomentProgress(this.item, {required this.active});
  final Item item;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final p = Player.instance;
    final time = AppTypography.data2.copyWith(color: _text);
    return StreamBuilder(
      stream: active ? p.position : null,
      builder: (context, snap) {
        final pos = active ? (snap.data ?? Duration.zero) : Duration.zero;
        final total = active ? p.currentDuration : item.duration;
        final ms = total?.inMilliseconds ?? 0;
        return Column(
          children: [
            const SizedBox(height: AppGap.gapXs4),
            LinearProgressIndicator(
              value: ms == 0 ? 0 : (pos.inMilliseconds / ms).clamp(0.0, 1.0),
              color: SocialTokens.accent,
              backgroundColor: SocialTokens.trackInactive,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(mmss(pos), style: time),
                Text(mmss(total), style: time),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// Comentarios de un post (Figma: "soc 4").
class CommentsScreen extends StatefulWidget {
  const CommentsScreen(this.post, this.station, {super.key});
  final Item post;
  final Station station;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _input = TextEditingController();
  late final _comments = Db.comments(widget.post);

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final t = _input.text.trim();
    if (t.isEmpty) return;
    _input.clear();
    await Db.addComment(widget.post, t);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PlayerTokens.bg,
      appBar: AppBar(
        backgroundColor: PlayerTokens.bg,
        title: const Text('Comentarios'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _comments,
                builder: (context, snap) => ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.paddingL16,
                  ),
                  children: [
                    ItemCard(widget.post, widget.station, showComment: false),
                    for (final c in snap.data ?? <Comment>[])
                      ListTile(
                        leading: const Icon(Icons.account_circle_outlined),
                        title: Text(c.username),
                        subtitle: Text(c.text),
                      ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(AppMargin.marginL16),
              padding: const EdgeInsets.fromLTRB(
                AppPadding.paddingL16,
                AppPadding.paddingXs4,
                AppPadding.paddingS8,
                AppPadding.paddingXs4,
              ),
              decoration: BoxDecoration(
                color: SocialTokens.inputBg,
                borderRadius: BorderRadius.circular(AppRadius.radiusM),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      decoration: const InputDecoration(
                        hintText: 'Escribir aquí',
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    color: SocialTokens.accent,
                    icon: const Icon(Icons.send),
                    onPressed: _send,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
