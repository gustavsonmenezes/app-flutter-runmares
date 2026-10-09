enum CoachSource { ai, local }

class CoachAnalysis {
  const CoachAnalysis({
    required this.headline,
    required this.feedback,
    required this.recoveryTip,
    this.source = CoachSource.local,
  });

  final String headline;
  final String feedback;
  final String recoveryTip;
  final CoachSource source;
}
