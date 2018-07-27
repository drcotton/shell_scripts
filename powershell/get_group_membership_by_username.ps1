Param (
   [Parameter(Mandatory=$true,ValueFromPipeLine=$true)]
   [Alias("ID","Users")]
   [string[]]$User
)
Begin {
   Try { Import-Module ActiveDirectory -ErrorAction Stop }
   Catch { Write-Host "Unable to load Active Directory module, is RSAT installed?"; Break }
} 

Process {
   ForEach ($U in $User)
   {  $UN = Get-ADUser $U -Properties MemberOf
      $Groups = ForEach ($Group in ($UN.MemberOf))
      {   (Get-ADGroup $Group).Name
      }
      $Groups = $Groups | Sort
      ForEach ($Group in $Groups)
      {  New-Object PSObject -Property @{
            Name = $UN.Name
            Group = $Group
         }
      }
   }
} 
