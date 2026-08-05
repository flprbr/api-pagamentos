package supply.sbom

deny contains msg if {
    not input.attestations.cyclonedx
    msg := "release sem atestacao SBOM CycloneDX anexada"
}
