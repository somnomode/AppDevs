import 'package:flutter/material.dart';
import '../theme/theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool _loading = false;
  bool _searched = false;
  String _query = '';
  int _searchVersion = 0;

  final List<StationItem> _recentStations = const [
    StationItem(title: 'radio', genre: 'género', color: Color(0xFFE6C229), icon: Icons.mic),
    StationItem(title: 'slider', genre: 'edad', color: Color(0xFFE63946), icon: Icons.campaign),
    StationItem(title: 'radio', genre: 'género', color: Color(0xFFF4E1C1), icon: Icons.record_voice_over),
    StationItem(title: 'radio', genre: 'género', color: Color(0xFFD9C6A5), icon: Icons.radio),
    StationItem(title: 'radio', genre: 'género', color: Color(0xFFD98E3D), icon: Icons.podcasts),
    StationItem(title: 'radio', genre: 'género', color: Color(0xFFD9E650), icon: Icons.graphic_eq),
  ];

  final List<StationItem> _recommendedStations = const [
    StationItem(title: 'radio', genre: 'género', subtitle: 'S...', color: Color(0xFFD9C6A5), icon: Icons.radio),
    StationItem(title: 'radio', genre: 'género', subtitle: 'S...', color: Color(0xFFB8BEC9), icon: Icons.article),
    StationItem(title: 'radio', genre: 'género', subtitle: 'S...', color: Color(0xFFE8F04A), icon: Icons.speaker),
    StationItem(title: 'radio', genre: 'género', subtitle: '', color: Color(0xFFD5A5FF), icon: Icons.campaign),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _loading = false;
        _searched = false;
        _query = '';
        _searchVersion++;
      });
      return;
    }

    final version = ++_searchVersion;

    setState(() {
      _query = query;
      _loading = true;
      _searched = false;
    });

    await Future.delayed(const Duration(milliseconds: 850));

    if (!mounted || version != _searchVersion) return;

    setState(() {
      _loading = false;
      _searched = true;
    });
  }

  List<StationItem> get _allStations => [
        ..._recentStations,
        ..._recommendedStations,
      ];

  List<StationItem> get _filteredStations {
    final q = _query.toLowerCase().trim();

    if (q.isEmpty) return [];

    return _allStations.where((station) {
      return station.title.toLowerCase().contains(q) ||
          station.genre.toLowerCase().contains(q) ||
          station.subtitle.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.neutral900,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            children: [
              _buildSearchHeader(),
              Expanded(
                child: _buildBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return _buildLoading();
    }

    if (_searched) {
      return _buildResults();
    }

    return _buildInitialContent();
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 20, 18),
      child: Row(
        children: [
          IconButton(
            onPressed: widget.onBack,
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.neutral50,
              size: 25,
            ),
            tooltip: 'Volver',
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 42,
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _search(),
                onChanged: (value) {
                  if (value.trim().isEmpty) {
                    setState(() {
                      _searched = false;
                      _loading = false;
                      _query = '';
                      _searchVersion++;
                    });
                  }
                },
                style: AppTypography.body1.copyWith(
                  color: AppColors.neutral900,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: 'Escribir aquí',
                  hintStyle: AppTypography.body1.copyWith(
                    color: const Color(0xFFB7B4D8),
                    fontWeight: FontWeight.w600,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFD9D9D9),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    onPressed: _search,
                    tooltip: 'Buscar',
                    icon: const Icon(
                      Icons.search,
                      color: AppColors.neutral900,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 38),
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: AppColors.primary400,
          ),
        ),
      ),
    );
  }

  Widget _buildInitialContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              'Recientes',
              style: TextStyle(
                color: AppColors.neutral50,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: AppTypography.fontFamilyOutfit,
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 118,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              scrollDirection: Axis.horizontal,
              itemCount: _recentStations.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final item = _recentStations[index];
                return _buildRecentCard(item);
              },
            ),
          ),
          const SizedBox(height: 6),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              'Recomendaciones',
              style: TextStyle(
                color: AppColors.neutral50,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: AppTypography.fontFamilyOutfit,
              ),
            ),
          ),
          const SizedBox(height: 18),
          ..._recommendedStations.map(_buildRecommendationTile),
        ],
      ),
    );
  }

  Widget _buildRecentCard(StationItem item) {
    return SizedBox(
      width: 96,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 96,
            height: 74,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              item.icon,
              size: 34,
              color: AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.sub2.copyWith(
              color: AppColors.neutral50,
              fontWeight: FontWeight.w700,
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -2),
            child: Text(
              item.genre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.body2.copyWith(
                color: AppColors.neutral200,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationTile(StationItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      color: const Color(0xFF1D1F53),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              item.icon,
              size: 34,
              color: AppColors.neutral900,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTypography.sub2.copyWith(
                    color: AppColors.neutral50,
                    fontSize: 18,
                  ),
                ),
                Text(
                  item.genre,
                  style: AppTypography.body1.copyWith(
                    color: AppColors.neutral50,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                item.subtitle,
                style: AppTypography.body2.copyWith(
                  color: AppColors.neutral200,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                tooltip: 'Reproducir',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reproduciendo ${item.title} (demo)'),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.play_circle_outline,
                  color: AppColors.neutral50,
                  size: 34,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final results = _filteredStations;

    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'No se encontraron resultados para "$_query".',
            textAlign: TextAlign.center,
            style: AppTypography.sub2.copyWith(
              color: AppColors.neutral50,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 14),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return _buildRecommendationTile(item);
      },
    );
  }
}

class StationItem {
  final String title;
  final String genre;
  final String subtitle;
  final Color color;
  final IconData icon;

  const StationItem({
    required this.title,
    required this.genre,
    this.subtitle = '',
    required this.color,
    required this.icon,
  });
}