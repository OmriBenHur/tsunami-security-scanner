import json
from os import scandir

tmp = scandir('./records')

for i in tmp:
    with open(i) as report:
        results = json.load(report)
        try:
            if results["fullDetectionReports"]["detectionReports"][-1]["vulnerability"] is not None:
                with open("joined-report.json", "a") as joined:
                    joined.write(
                        f'\n {str(results["fullDetectionReports"]["detectionReports"][-1]["detectionTimestamp"])}')
                    joined.write(
                        f'\n {str(results["scanFindings"][0]["networkService"]["networkEndpoint"]["ipAddress"])}')
                    joined.write(
                        f'\n {str(results["fullDetectionReports"]["detectionReports"][-1]["vulnerability"])}')
        except Exception:
            pass
