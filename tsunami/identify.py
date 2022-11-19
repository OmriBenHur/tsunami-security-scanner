import json
from os import scandir, system
# scannig records directory where all tsunami reports are found
tmp = scandir('./records')
# identifying any vulnerabilities and writing the vulnerability, the date and time and recommended action to a joined report
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
system("echo consolidation report done, is not present all tests passed")
