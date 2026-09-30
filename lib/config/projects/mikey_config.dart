import 'package:dashboard_core/dashboard_core.dart';
import 'package:flutter/material.dart';

const ProjectConfig mikeyConfig = ProjectConfig(
  id: 'mikey',
  appTitle: 'Mikey Dashboard',
  displayName: 'Mikey',
  dashboardSubtitle: 'Mikey Expert System',
  splashAssetPath: 'assets/images/splash.png',
  splashTitle: 'Mikey Expert Dashboard',
  splashLoadingText: 'Loading analytics and report data...',
  primaryColor: Color(0xFF2563EB),
  secondaryColor: Color(0xFF38BDF8),
  darkBackgroundColor: Color(0xFF0F172A),
  cardDarkColor: Color(0xFF111827),
  softAccentColor: Color(0xFF93C5FD),
  apiEndpoints: ApiEndpoints(
    baseUrl: 'https://n8nmicky.launchman.xyz/webhook',
    dashboardSummary: '/mikey-dashboard-summary',
    adminMe: '/mikey-admin-me',
    campaignList: '/mikey-campaigns',
    campaignCreate: '/mikey-campaign-create',
    campaignStatus: '/mikey-campaign-status',
    campaignLeads: '/mikey-campaign-leads',
    signalHistory: '/mikey-signal-history',
    signalSend: '/mikey-signal-send',
    broadcastCreate: '/mikey-broadcast-create',
    broadcastHistory: '/mikey-broadcast-history',
    broadcastSend: '/mikey-broadcast-send',
    broadcastAudiencePreview: '/mikey-broadcast-audience-preview',
    mediaUpload: '/mikey-media-upload',
  ),
  admin: AdminConfig(
    localDevelopmentBypassEnabled: true,
    ownerTelegramUserId: 7376947596,
    ownerTelegramUsername: 'RadicalaAI',
  ),
);
