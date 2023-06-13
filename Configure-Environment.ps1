<#
    1. Declare variables
    2. Create RG
    3. Create VNET and subnets
    4. Create VM and join to domain
#>

### Step 1 - Declare variables

$abbrev = '' # Client abbreviation
$deployment = '' # Name for the deployment
$templatefile = '' # Path to template file
$vault = '' # Azure Key Vault name
$rgname = '' # Resource Group Name for deployment

# Variables below this line should not need to be touched

### Step 4 - Deploy vanilla VM from template, pull adminlocal secret from KV

$secret = Get-AzKeyVaultSecret -VaultName $vault -Name adminlocal
$VMparameters = @{
  Name = $deployment
  TemplateFile = $templatefile
  ResourceGroupName = $rgname
  adminUsername = $secret.name
  adminPassword = $secret.SecretValue
}

New-AzResourceGroupDeployment @VMparameters