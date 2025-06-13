# create a new workbook in Azure Portal

# Go to Microsoft Defender for Cloud in the Azure Portal.

# Select Workbooks > Click + New at the top.

# Click Add > Text.

# Add: 
Use this workbook to simulate common security alert scenarios and test Defender for Cloud alerting.

# Click Add > Add query.

# Choose your Log Analytics workspace (linked to Defender for Cloud).

# Paste the following KQL query to list recent alerts:
SecurityAlert
| where TimeGenerated > ago(1d)
| summarize count() by AlertName, Severity, CompromisedEntity, TimeGenerated
| sort by TimeGenerated desc


# Add another Text block with instructions on how to simulate alerts, like:
To generate test alerts, try the following:
- Use Defender for Endpoint test script 'safe-security-tests.sh' if integration is enabled.
- View the alerts in the table above.



# Click Save.

# Name it: Alert Simulation Workbook.

