# This defines two Powershell modules
# See https://stackoverflow.com/a/49047069

#  Try to automatically delete any local branches that no-longer have a remote branch
Function PruneLocal {	
	$headBranchName =  git remote show origin | Select-String -Pattern "HEAD branch:" | % { $_.toString().Trim().Split(" ")[2]};
	git checkout $headBranchName;
  git fetch;
	git remote prune origin; 
	git branch -vv | Select-String -Pattern ": gone]" | % { $_.toString().Trim().Split(" ")[0]} | % {git branch -d $_}
}

# The only difference between this and the other prunelocal script is this uses -D (instead of -d)
# in the last git branch command to force deleting branches that are unmerged.
Function PruneLocalHard {
	$headBranchName =  git remote show origin | Select-String -Pattern "HEAD branch:" | % { $_.toString().Trim().Split(" ")[2]};
	git checkout $headBranchName;
  git fetch;
	git remote prune origin; 
	git branch -vv | Select-String -Pattern ": gone]" | % { $_.toString().Trim().Split(" ")[0]} | % {git branch -D $_}
}

# Recursively remove all bin and obj directories from the current
Function cleanup-objbin {
	Get-ChildItem .\ -include bin,obj -Recurse | foreach ($_) { remove-item $_.fullname -Force -Recurse }
}

# In Windows, will run gitbash shell
Function gbash {
  if ($IsWindows -and Test-Path -Path "C:\Program Files\Git\bin\sh.exe" -PathType Leaf){
    & 'C:\Program Files\Git\bin\sh.exe' --login
  } else {
    Write-Output "Error: OS is not Windows or gitbash is not installed in C:\Program Files\Git"
  }
}

# Run sln (an alias for Open-Solution) to recursively search your current working 
# directory for a solution file and launch it, if one is found.
# Copied from https://github.com/refactorsaurusrex/whats-new
function Open-Solution {
  param (
    [string]$RootDirectory = $PWD
  )

  $solutions = Get-ChildItem -Recurse -Path $RootDirectory -Filter "*.sln"
  if ($solutions.Count -eq 1) {
    Invoke-Item $solutions.FullName
  }
  elseif ($solutions.Count -eq 0) {
    Write-Host "I couldn't find any solution files here!" -ForegroundColor Red
  }
  elseif ($solutions.Count -gt 1) {
    Write-Host "I found more than 1 solution. Which one do you want to open?" -ForegroundColor Yellow
    $solutions | Format-Table @{ Label="Solutions"; Expression={" --> $_"} }
  }
}

New-Alias -Name sln -Value Open-Solution
Export-ModuleMember -Function * -Alias *
