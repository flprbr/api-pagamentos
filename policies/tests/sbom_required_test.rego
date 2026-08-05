package supply.sbom

test_bloqueia_sem_sbom if {
    count(deny) > 0 with input as {"attestations": {}}
}

test_permite_com_sbom if {
    count(deny) == 0 with input as {"attestations": {"cyclonedx": true}}
}
