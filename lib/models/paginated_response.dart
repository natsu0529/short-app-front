class PaginatedResponse<T> {
  final int count;
  final String? next;
  final String? previous;
  final List<T> results;

  const PaginatedResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => fromJsonT(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  bool get hasNext => next != null;
  bool get hasPrevious => previous != null;

  int? get nextPage {
    if (next == null) return null;
    final uri = Uri.tryParse(next!);
    if (uri == null) return null;
    final pageStr = uri.queryParameters['page'];
    return pageStr != null ? int.tryParse(pageStr) : null;
  }
}
