# Microsoft Defender for Cloud Course - Cybr

This course can be located at [cybr.com](https://cybr.com)

- [Defender for Cloud Pricing Page](https://azure.microsoft.com/en-us/pricing/details/defender-for-cloud/)

- [Defender for Endpoint Plans - Servers](https://learn.microsoft.com/en-us/defender-vulnerability-management/defender-vulnerability-management-capabilities)

## IMPORTANT DEPRECATIONS

- [Log Analytics Agent (MMA) - Deprecated Aug 2024](https://techcommunity.microsoft.com/blog/microsoftdefendercloudblog/microsoft-defender-for-cloud---strategy-and-plan-towards-log-analytics-agent-mma/3883341)

- [Defender for Kubernetes - Deprecated Dec 2021](https://learn.microsoft.com/en-us/azure/defender-for-cloud/release-notes-archive#microsoft-defender-for-containers-plan-released-for-general-availability-ga)

- [NSG Flow Logs - Deprecated June 2025](https://learn.microsoft.com/en-us/azure/network-watcher/nsg-flow-logs-migrate)

## BICEP TEMPLATES

- [Bicep - Create a Storage Account with Public Access](scripts/storage.bicep)

- [Bicep - Create a VM without JIT](scripts/vm.bicep)

- [Bicep - Create AKS cluster with Azure Policy Addon](aks.bicep)

- [Bicep - Enable Defender for Containers](defender-for-containers.bicep)

- [Bicep - LogicApp & Automation](logicapp-defender-automation.bicep)

## SCRIPTS

- [Enable Defender for Cloud](scripts/enable-defender-for-cloud.sh)

- [Create VM and Storage Account from Bicep files above](scripts/deploy-vm-and-sa.sh)

- [Check Management Group Permissions](scripts/check-management-groups.sh)

- [Check Role Assignments in Azure](scripts/role-assignment.sh)

- [Enable Condional Access in Azure Entra ID](scripts/conditional-access-for-MFA.sh)

- [Enable Defender for Storage](scripts/defender-for-storage.sh)

- [VM Commands to Trigger Defender Alerts - Hacking](scripts/safe-security-tests.sh)

- [Deploy an AKS Cluster with Defender Sensor](scripts/deploy-aks.sh)

- [Deploy a Logic App in Defender for Cloud with Automation Rule](scripts/deploy-logic-app.sh)

- [Enable DDoS Protection Plan - $$$](scripts/enable-DDoS-protection.sh)

- [Azure Firewall - Enable Firewall Diagnostics](scripts/enable-firewall-diagnostics.sh)

- [Enable Network Watcher](scripts/enable-network-watcher.sh)

- [Install Azure Monitor Agent](scripts/install-azure-monitor-agent.sh)

- [KQL Queries for Log Analytics Workspace](scripts/KQL-queries.kql)

## SLIDES, LINKS, AND COMMANDS BY LESSON

### LESSON 00: What is Defender for Cloud

- [Slides: What is Defender for Cloud](slides/00-SLIDES-AZURE-SECURITY-WHAT-IS-DEFENDER.pdf)

### LESSON 01: Enabling Defender for Cloud

- [Slides: Enabling Defender for Cloud](slides/01-SLIDES-AZURE-SECURIT_ENABLING_DEFENDER.pdf)

- [Link: Defender for Cloud Pricing Page](https://azure.microsoft.com/en-us/pricing/details/defender-for-cloud/)

- [Commands: Register Providers](scripts/register-provider.sh)

- [Commands: Create Role Assigments](scripts/role-assignment.sh)

### LESSON 02: Security Policies and Compliance

- [Slides: Security Policies and Compliance](slides/02-SLIDES-AZURE-SECURITY_COMPLIANCE-AND-SECURITY.pdf)

- [Commands: Deploy VM and Storage Account](scripts/deploy-vm-and-sa.sh)

- [Bicep: Accompanying VM Bicep Template](scripts/vm.bicep)

- [Bicep: Accompanying Storage Account Bicep Template](scripts/stroage.bicep)

### LESSON 03: Microsoft Entra ID Best Practices

- [Slides: Microsoft Entra ID Best Practices](slides/03-SLIDES-AZURE-SECURITY_ENTRE-ID-BEST-PRACTICES.pdf)

### LESSON 04: Role-Based Access Control (RBAC)

- [Slides: Role-Based Access Control (RBAC)](slides/04-SLIDES-AZURE-SECURITY_RBAC.pdf)

### LESSON 05: Compute Security

- [Slides: Compute Security](slides/05-SLIDES-AZURE-SECURITY_COMPUTE_SECURITY.pdf)

- [Link: Defender for Cloud Plan Comparison](https://learn.microsoft.com/en-us/defender-vulnerability-management/defender-vulnerability-management-capabilities)

- [Link: Deprecation of Log Analytics Agent (MMA)](https://techcommunity.microsoft.com/blog/microsoftdefendercloudblog/microsoft-defender-for-cloud---strategy-and-plan-towards-log-analytics-agent-mma/3883341)

- [Commands: Enable Defender for Cloud](scripts/enable-defender-for-cloud.sh)

### LESSON 06: Container Security

- [Slides: Container Security](slides/06-SLIDES-AZURE-SECURITY_CONTAINER_SECURITY.pdf)

- [Link: Enable Defender Sensor for Containers](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-containers-enable)

- [Link: Support for EKS and GCP Clusters](https://learn.microsoft.com/en-us/azure/defender-for-cloud/agentless-vulnerability-assessment-azure)

- [Link: Agentless Container Scanning Capabilities](https://learn.microsoft.com/en-us/azure/defender-for-cloud/concept-agentless-containers)


### LESSON 07: Storage Security

- [Slides: Storage Security](slides/07-SLIDES-AZURE-SECURITY_STORAGE_SECURITY.pdf)

- [Commands: Create Log Analytics Workspace and Link Blob Storage](scripts/defender-for-storage.sh)

- [Commands: Upload files to Storage Account](scripts/defender-for-storage.sh)

- [Commands: Perform Safe Hacks to Trigger Defender Alerts](scripts/safe-security-tests.sh)

### LESSON 08: Network Security

- [Slides: Network Security](slides/08-SLIDES-AZURE-SECURITY_NETWORK_SECURITY.pdf)

- [Link: VNET Flow Logs](https://learn.microsoft.com/en-us/azure/network-watcher/vnet-flow-logs-overview)

- [Commands: Enable Network Watcher and Enable VNET FLow Logs](scripts/enable-network-watcher.sh)

### LESSON 09: Azure Firewall & DDoS Protection

- [Slides: Azure Firewall & DDoS Protection](slides/09-SLIDES-AZURE-SECURITY_AZURE-FIREWALL-DDOS.pdf)

- [Commands: Create Azure Firewall and Enable Diagnostics](scripts/enable-firewall-diagnostics.sh)

- [Commands: Enable DDoS Protection Plan](scripts/enable-DDoS-protection.sh)

### LESSON 10: Zero Trust Networking

- [Slides: Zero Trust Networking](slides/10-SLIDES-AZURE-SECURITY_ZERO-TRUST.pdf)

- [Link: Connect to a Storage Account Using an Azure Private Endpoint](https://learn.microsoft.com/en-us/azure/private-link/tutorial-private-endpoint-storage-portal?tabs=dynamic-ip)

- [Commands: Create JIT Policy for VM](scripts/create-JIT-policy.sh)

- [Commands: Enforce Private Endpoint for Storage Account](scripts/create-private-endpoint.sh)

### LESSON 11: Detecting and Responding to Threats

- [Slides: Detecting and Responding to Threats](slides/11-SLIDES-AZURE-SECURITY_DETECTING-AND-RESPONDING.pdf)

- [Commands: Perform Safe Hacks to Trigger Defender Alerts](scripts/safe-security-tests.sh)

- [Commands: Create an Alert Simulation Workbook](scripts/alert-simulation-workbook.sh)

### LESSON 12: Automating Incident Response

- [Slides: Automating Incident Response](slides/12-SLIDES-AZURE-SECURITY_AUTOMATING-INCIDENT-RESPONSE.pdf)

- [Commands: Create LogicApp and Workflow Automation](scripts/deploy-logic-app.sh)

### LESSON 13: Wrap Up & Next Steps

- [Slides: Wrap Up & Next Steps](slides/13-SLIDES-AZURE-SECURITY_NEXT-STEPS.pdf)

