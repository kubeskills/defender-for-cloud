az rest --method post \
    --uri "https://graph.microsoft.com/beta/identity/conditionalAccess/policies" \
    --headers 'Content-Type=application/json' \
    --body '{
      "displayName": "Enforce MFA for All Users",
      "state": "enabled",
      "conditions": {
        "users": {
          "includeGroups": [],
          "includeRoles": [],
          "includeUsers": ["All"]
        },
        "applications": {
          "includeApplications": ["All"]
        }
      },
      "grantControls": {
        "operator": "AND",
        "builtInControls": ["mfa"]
      }
    }'
