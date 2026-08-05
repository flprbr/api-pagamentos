# api-pagamentos — Compliance Contínuo

Pipeline que gera evidência auditável como subproduto: Policy as Code (OPA/Rego),
SBOM (CycloneDX), assinatura e atestação (Cosign keyless) e SLSA Provenance,
com gate de admissao no Kubernetes (sigstore policy-controller).

## Camadas
- Policy as Code: policies/rego + testes opa em policies/tests
- SBOM: gerado no release.yml (anchore/sbom-action) e anexado via cosign attest
- Cadeia: cosign sign + cosign attest + SLSA provenance (slsa-github-generator)
- Auditoria: scripts/gera_relatorio.sh e scripts/consulta_dt.py

## Mapeamento de controles a frameworks

| Controle tecnico              | NIST SSDF | SLSA        | ISO 27001:2022 |
|-------------------------------|-----------|-------------|----------------|
| Signed commits / branch prot. | PS.1.1    | -           | A.8.25         |
| Assinatura de release (Cosign)| PS.2.1    | Provenance  | A.8.28         |
| Verificacao na admissao       | PS.3.1    | L3          | A.8.26         |
| SBOM + Dependency-Track       | PW.4.1    | -           | A.5.23         |
| SAST/analise estatica         | PW.4.4    | -           | A.8.28         |
| Scan de vulnerabilidades      | RV.1.1    | -           | A.8.29         |
| Monitoramento de componentes  | RV.1.3    | -           | A.5.23         |
| Build isolado / runner efemero| PO.5.1    | Build L3    | A.8.25         |

## Como validar localmente
- opa test policies/ -v
- kubectl run intruso --image=ghcr.io/empresa/api-pagamentos:fake -n producao  (deve falhar)

## Como validar em CI
- Tag v* dispara release.yml (build, sign, attest, provenance)
- workflow_dispatch em verify.yml valida assinatura, SBOM e provenance
