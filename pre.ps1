
$amsname
$rg
$mi

az ams account identity assign -n $amsname -g $rg --user-assigned $mi
az ams account storage set-authentication -n $amsname -g $rg --storage-auth ManagedIdentity --user-assigned $mi
Register-AzProviderFeature -FeatureName "EncryptionAtHost" -ProviderNamespace "Microsoft.Compute"
