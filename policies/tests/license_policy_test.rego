package supply.license

test_permite_licenca_ok if {
    count(deny) == 0 with input as {
        "components": [{"name": "express", "licenses": [{"license": {"id": "MIT"}}]}]
    }
}

test_bloqueia_licenca_proibida if {
    count(deny) > 0 with input as {
        "components": [{"name": "libX", "licenses": [{"license": {"id": "AGPL-3.0-only"}}]}]
    }
}
