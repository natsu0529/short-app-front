class PaginatedResponse<T> {
  final int count;
  final String? next;
  final String? previous;
  final List<T> results;
  final String? currentCursor;

  const PaginatedResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
    this.currentCursor,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      currentCursor: json['cursor'],
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => fromJsonT(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  bool get hasNext => next != null;
  bool get hasPrevious => previous != null;

  String? get nextCursor => _extractCursor(next);
  String? get previousCursor => _extractCursor(previous);

  String? _extractCursor(String? url) {
    if (url == null) return null;
    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    return uri.queryParameters['cursor'] ?? uri.queryParameters['page'];
  }
}
