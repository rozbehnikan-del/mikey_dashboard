class DashboardData {
  final DateTime timestamp;
  final CoreKpis core;
  final DashboardRates rates;
  final FunnelData funnel;
  final ValueData value;
  final SegmentData segments;
  final RecommendedAction recommendedAction;

  const DashboardData({
    required this.timestamp,
    required this.core,
    required this.rates,
    required this.funnel,
    required this.value,
    required this.segments,
    required this.recommendedAction,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final users = _Json.asMap(json['users']);
    final qualification = _Json.asMap(json['qualification']);
    final activity = _Json.asMap(json['activity']);
    final ratesJson = _Json.asMap(json['rates']);

    if (users.isNotEmpty || qualification.isNotEmpty || activity.isNotEmpty) {
      return DashboardData(
        timestamp: DateTime.tryParse(json['generated_at']?.toString() ?? '') ??
            DateTime.now(),
        core: CoreKpis(
          totalUsers: NumberParser.toInt(users['total_users']),
          verifiedDeposits: NumberParser.toInt(users['verified_deposits']),
          pending: NumberParser.toInt(users['pending_deposits']),
          validEmails: NumberParser.toInt(users['valid_emails']),
          active7d: NumberParser.toInt(activity['active_7d']),
          active24h: NumberParser.toInt(activity['active_24h']),
          active30d: NumberParser.toInt(activity['active_30d']),
          messages7d: NumberParser.toInt(activity['messages_7d']),
        ),
        rates: DashboardRates(
          conversion: NumberParser.toRate(ratesJson['deposit_conversion']),
          email: NumberParser.toRate(ratesJson['valid_email_rate']),
          engagement7d: NumberParser.toRate(ratesJson['active_7d_rate']),
          retentionW1: 0,
          retentionM1: 0,
          qualified300: NumberParser.toRate(ratesJson['qualified_300_rate']),
          hotPending48h: 0,
          churnRisk14d: 0,
        ),
        funnel: FunnelData(
          start: NumberParser.toInt(users['total_users']),
          onboarded: NumberParser.toInt(users['messaged_users']),
          introSent: NumberParser.toInt(users['messaged_users']),
          verified: NumberParser.toInt(users['verified_deposits']),
        ),
        value: ValueData(
          totalAmount: NumberParser.toDouble(
            qualification['total_recorded_deposit_value'],
          ),
          totalVerified: NumberParser.toDouble(
            qualification['verified_deposit_value'],
          ),
          averageVerified: 0,
          p50Verified: 0,
          p90Verified: 0,
          qualified500: NumberParser.toInt(qualification['vip_500']),
          verified500: 0,
        ),
        segments: SegmentData(
          pendingNoEmail: 0,
          pendingHasEmail: 0,
          verifiedLt300: 0,
          verified300To499: 0,
          verifiedGe500: NumberParser.toInt(qualification['vip_500']),
        ),
        recommendedAction: RecommendedAction.fromApiJson(
          json,
          users: users,
          qualification: qualification,
        ),
      );
    }

    return DashboardData(
      timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? '') ??
          DateTime.now(),
      core: CoreKpis.fromJson(_Json.asMap(json['core'])),
      rates: DashboardRates.fromJson(ratesJson),
      funnel: FunnelData.fromJson(_Json.asMap(json['funnel'])),
      value: ValueData.fromJson(_Json.asMap(json['value'])),
      segments: SegmentData.fromJson(_Json.asMap(json['segments'])),
      recommendedAction: RecommendedAction.fromJson(
        _Json.asMap(json['recommendedAction']),
      ),
    );
  }
}

class CoreKpis {
  final int totalUsers;
  final int verifiedDeposits;
  final int pending;
  final int validEmails;
  final int active7d;
  final int active24h;
  final int active30d;
  final int messages7d;

  const CoreKpis({
    required this.totalUsers,
    required this.verifiedDeposits,
    required this.pending,
    required this.validEmails,
    required this.active7d,
    required this.active24h,
    required this.active30d,
    required this.messages7d,
  });

  factory CoreKpis.fromJson(Map<String, dynamic> json) {
    return CoreKpis(
      totalUsers: NumberParser.toInt(json['totalUsers']),
      verifiedDeposits: NumberParser.toInt(json['verifiedDeposits']),
      pending: NumberParser.toInt(json['pending']),
      validEmails: NumberParser.toInt(json['validEmails']),
      active7d: NumberParser.toInt(json['active7d']),
      active24h: NumberParser.toInt(json['active24h']),
      active30d: NumberParser.toInt(json['active30d']),
      messages7d: NumberParser.toInt(json['messages7d']),
    );
  }
}

class DashboardRates {
  final double conversion;
  final double email;
  final double engagement7d;
  final double retentionW1;
  final double retentionM1;
  final double qualified300;
  final double hotPending48h;
  final double churnRisk14d;

  const DashboardRates({
    required this.conversion,
    required this.email,
    required this.engagement7d,
    required this.retentionW1,
    required this.retentionM1,
    required this.qualified300,
    required this.hotPending48h,
    required this.churnRisk14d,
  });

  factory DashboardRates.fromJson(Map<String, dynamic> json) {
    return DashboardRates(
      conversion: NumberParser.toDouble(json['conversion']),
      email: NumberParser.toDouble(json['email']),
      engagement7d: NumberParser.toDouble(json['engagement7d']),
      retentionW1: NumberParser.toDouble(json['retentionW1']),
      retentionM1: NumberParser.toDouble(json['retentionM1']),
      qualified300: NumberParser.toDouble(json['qualified300']),
      hotPending48h: NumberParser.toDouble(json['hotPending48h']),
      churnRisk14d: NumberParser.toDouble(json['churnRisk14d']),
    );
  }
}

class FunnelData {
  final int start;
  final int onboarded;
  final int introSent;
  final int verified;

  const FunnelData({
    required this.start,
    required this.onboarded,
    required this.introSent,
    required this.verified,
  });

  factory FunnelData.fromJson(Map<String, dynamic> json) {
    return FunnelData(
      start: NumberParser.toInt(json['start']),
      onboarded: NumberParser.toInt(json['onboarded']),
      introSent: NumberParser.toInt(json['introSent']),
      verified: NumberParser.toInt(json['verified']),
    );
  }
}

class ValueData {
  final double totalAmount;
  final double totalVerified;
  final double averageVerified;
  final double p50Verified;
  final double p90Verified;
  final int qualified500;
  final int verified500;

  const ValueData({
    required this.totalAmount,
    required this.totalVerified,
    required this.averageVerified,
    required this.p50Verified,
    required this.p90Verified,
    required this.qualified500,
    required this.verified500,
  });

  factory ValueData.fromJson(Map<String, dynamic> json) {
    return ValueData(
      totalAmount: NumberParser.toDouble(json['totalAmount']),
      totalVerified: NumberParser.toDouble(json['totalVerified']),
      averageVerified: NumberParser.toDouble(json['averageVerified']),
      p50Verified: NumberParser.toDouble(json['p50Verified']),
      p90Verified: NumberParser.toDouble(json['p90Verified']),
      qualified500: NumberParser.toInt(json['qualified500']),
      verified500: NumberParser.toInt(json['verified500']),
    );
  }
}

class SegmentData {
  final int pendingNoEmail;
  final int pendingHasEmail;
  final int verifiedLt300;
  final int verified300To499;
  final int verifiedGe500;

  const SegmentData({
    required this.pendingNoEmail,
    required this.pendingHasEmail,
    required this.verifiedLt300,
    required this.verified300To499,
    required this.verifiedGe500,
  });

  factory SegmentData.fromJson(Map<String, dynamic> json) {
    return SegmentData(
      pendingNoEmail: NumberParser.toInt(json['pendingNoEmail']),
      pendingHasEmail: NumberParser.toInt(json['pendingHasEmail']),
      verifiedLt300: NumberParser.toInt(json['verifiedLt300']),
      verified300To499: NumberParser.toInt(json['verified300To499']),
      verifiedGe500: NumberParser.toInt(json['verifiedGe500']),
    );
  }
}

class RecommendedAction {
  final String title;
  final int count;
  final String action;

  const RecommendedAction({
    required this.title,
    required this.count,
    required this.action,
  });

  factory RecommendedAction.fromJson(Map<String, dynamic> json) {
    return RecommendedAction(
      title: json['title']?.toString() ?? 'No action',
      count: NumberParser.toInt(json['count']),
      action: json['action']?.toString() ?? '',
    );
  }

  factory RecommendedAction.fromApiJson(
    Map<String, dynamic> json, {
    required Map<String, dynamic> users,
    required Map<String, dynamic> qualification,
  }) {
    final actions = json['recommended_actions'];
    if (actions is! List || actions.isEmpty) {
      return const RecommendedAction(
        title: 'No action',
        count: 0,
        action: '',
      );
    }

    final actionJson = _Json.asMap(actions.first);
    if (actionJson.isEmpty) {
      return const RecommendedAction(
        title: 'No action',
        count: 0,
        action: '',
      );
    }

    return RecommendedAction(
      title: actionJson['title']?.toString() ?? 'No action',
      count: NumberParser.toInt(actionJson['count']).nonZeroOr(
        _countForTargetSegment(
          actionJson['target_segment']?.toString(),
          users: users,
          qualification: qualification,
        ),
      ),
      action: actionJson['description']?.toString() ?? '',
    );
  }

  static int _countForTargetSegment(
    String? targetSegment, {
    required Map<String, dynamic> users,
    required Map<String, dynamic> qualification,
  }) {
    switch (targetSegment) {
      case 'pending_deposit':
        return NumberParser.toInt(users['pending_deposits']);
      case 'qualified_300':
        return NumberParser.toInt(qualification['qualified_300']);
      case 'no_email':
        final totalUsers = NumberParser.toInt(users['total_users']);
        final validEmails = NumberParser.toInt(users['valid_emails']);
        return (totalUsers - validEmails).clamp(0, totalUsers).toInt();
      default:
        return 0;
    }
  }
}

class NumberParser {
  static int toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is num) return value.toInt();
    if (value is String) {
      final normalized = value.replaceAll(',', '').trim();
      return int.tryParse(normalized) ??
          double.tryParse(normalized)?.toInt() ??
          0;
    }
    return 0;
  }

  static double toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value.replaceAll(',', '').trim()) ?? 0;
    }
    return 0;
  }

  static double toRate(dynamic value) {
    final parsed = toDouble(value);
    if (parsed > 1) return parsed / 100;
    return parsed;
  }
}

class _Json {
  static Map<String, dynamic> asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return const {};
  }
}

extension on int {
  int nonZeroOr(int fallback) {
    if (this != 0) return this;
    return fallback;
  }
}
