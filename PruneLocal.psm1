# This defines two Powershell modules
# See https://stackoverflow.com/a/49047069

#  Try to automatically delete any local branches that no-longer have a remote branch
Function PruneLocal {	
	$headBranchName =  git remote show origin | Select-String -Pattern "HEAD branch:" | % { $_.toString().Trim().Split(" ")[2]};
	git checkout $headBranchName;
	git remote prune origin; 
	git branch -vv | Select-String -Pattern ": gone]" | % { $_.toString().Trim().Split(" ")[0]} | % {git branch -d $_}
}

# The only difference between this and the other prunelocal script is this uses -D (instead of -d)
# in the last git branch command to force deleting branches that are unmerged.
Function PruneLocalHard {
	$headBranchName =  git remote show origin | Select-String -Pattern "HEAD branch:" | % { $_.toString().Trim().Split(" ")[2]};
	git checkout $headBranchName;
	git remote prune origin; 
	git branch -vv | Select-String -Pattern ": gone]" | % { $_.toString().Trim().Split(" ")[0]} | % {git branch -D $_}
}