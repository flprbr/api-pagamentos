#!/usr/bin/env bash
# scripts/gera_relatorio.sh
set -u

MES=$(date +%Y-%m)
OWNER_REPO="${OWNER_REPO:-empresa/api-pagamentos}"
mkdir -p "relatorios/$MES"

gh release list --repo "$OWNER_REPO" --limit 50 --json tagName,publishedAt \
  | jq --arg m "$MES" '[.[] | select(.publishedAt | startswith($m))]' \
  > "relatorios/$MES/releases.json"

echo "tag,assinatura,provenance" > "relatorios/$MES/conformidade.csv"

jq -r '.[].tagName' "relatorios/$MES/releases.json" | while read -r TAG; do
    IMG="ghcr.io/$OWNER_REPO:$TAG"
    if cosign verify "$IMG" \
        --certificate-identity-regexp "^https://github.com/${OWNER_REPO%%/*}/.*" \
        --certificate-oidc-issuer https://token.actions.githubusercontent.com \
        > /dev/null 2>&1; then SIG_OK="sim"; else SIG_OK="nao"; fi

    if cosign verify-attestation "$IMG" --type slsaprovenance \
        --certificate-identity-regexp "^https://github.com/${OWNER_REPO%%/*}/.*" \
        --certificate-oidc-issuer https://token.actions.githubusercontent.com \
        > /dev/null 2>&1; then PROV_OK="sim"; else PROV_OK="nao"; fi

    echo "$TAG,$SIG_OK,$PROV_OK" >> "relatorios/$MES/conformidade.csv"
done

echo "Relatorio em relatorios/$MES/conformidade.csv"
