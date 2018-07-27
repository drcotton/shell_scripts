$root = "[ldap://DC=DOMAIN,DC=local LDAP://DC=DOMAIN,DC=local]" 

$objDomain = New-Object System.DirectoryServices.DirectoryEntry($root)
$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
$objSearcher.SearchRoot = $objDomain
$objSearcher.PageSize = 1000
$objSearcher.Filter = "(objectCategory=Computer)"
$objSearcher.SearchScope = "Subtree" 

$colProplist = "name", "distinguishedname"
foreach ($prop in $colProplist) {
  $objSearcher.PropertiesToLoad.Add($prop) | out-null
} 

$colResults = $objSearcher.FindAll()
Write-Host "Found $($colResults.count) computer(s)" 

foreach ($objResult in $colResults) {
  $objItem = $objResult.Properties 

  $objComputer = [ADSI]"[ldap://$($objItem.distinguishedname LDAP://$($objItem.distinguishedname])" 

  If (!$objComputer.PsBase.InvokeGet("AccountDisabled")) {
    Write-Host $objItem.name
  }

} 
