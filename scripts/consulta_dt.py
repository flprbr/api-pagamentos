import csv, os, requests

DT_URL = os.environ["DT_URL"]
DT_TOKEN = os.environ["DT_TOKEN"]
HEADERS = {"X-Api-Key": DT_TOKEN}

with open("postura_cadeia.csv", "w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["projeto", "versao", "vulns_criticas",
                "licencas_violadas", "ultima_atualizacao_sbom"])
    projetos = requests.get(f"{DT_URL}/api/v1/project", headers=HEADERS).json()
    for p in projetos:
        m = requests.get(
            f"{DT_URL}/api/v1/metrics/project/{p['uuid']}/current",
            headers=HEADERS).json()
        w.writerow([
            p["name"], p["version"],
            m.get("critical", 0), m.get("policyViolationsTotal", 0),
            p.get("lastBomImport", "n/d"),
        ])

print("Gerado postura_cadeia.csv")
