package supply.image

allowed_registries := {"ghcr.io/empresa/", "localhost:5000/"}

deny contains msg if {
    img := input.image
    not allowed(img)
    msg := sprintf("imagem '%v' nao vem de um registry permitido: %v", [img, allowed_registries])
}

deny contains msg if {
    img := input.image
    endswith(img, ":latest")
    msg := sprintf("imagem '%v': tag 'latest' e proibida", [img])
}

allowed(img) if {
    prefix := allowed_registries[_]
    startswith(img, prefix)
}
