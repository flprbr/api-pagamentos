package supply.image

test_permite_registry_valido if {
    count(deny) == 0 with input as {"image": "ghcr.io/empresa/api-pagamentos:v1.0.0"}
}

test_bloqueia_registry_invalido if {
    count(deny) > 0 with input as {"image": "docker.io/qualquer/api:v1.0.0"}
}

test_bloqueia_tag_latest if {
    count(deny) > 0 with input as {"image": "ghcr.io/empresa/api-pagamentos:latest"}
}
