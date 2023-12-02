#!/usr/bin/env bash

set -e
mkdir -p ./.metadata/.plugins/org.eclipse.core.runtime/.settings

cat <<EOT >> ./.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.m2e.apt.prefs
org.eclipse.m2e.apt.aptProcessDuringReconcile=true
org.eclipse.m2e.apt.mode=jdt_apt
EOT

cat <<EOT >> ./.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.jdt.ui.prefs
content_assist_favorite_static_members=org.assertj.core.api.Assertions.*;org.mockito.Mockito.*;java.util.stream.Collectors.*;org.springframework.test.web.servlet.result.MockMvcResultHandlers.*;org.springframework.test.web.servlet.result.MockMvcResultMatchers.*
EOT

cat <<EOT >> ./.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.editors.prefs
showWhitespaceCharacters=true
EOT
