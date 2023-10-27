#!/usr/bin/env bash

set -e

cat <<EOT >> ./.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.m2e.apt.prefs
org.eclipse.m2e.apt.aptProcessDuringReconcile=true
org.eclipse.m2e.apt.mode=jdt_apt
EOT

cat <<EOT >> ./.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.jdt.ui.prefs
content_assist_favorite_static_members=org.assertj.core.api.Assertions.*;org.mockito.Mockito.*;java.util.stream.Collectors.*
EOT