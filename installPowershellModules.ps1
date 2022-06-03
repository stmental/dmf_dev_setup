
if ($IsWindows) {
	# Copies a PruneLocal powershell module to the current users PowerShell directory
	# which should make it available automatically to use in powershell (part of the PSModulePath env variable path)
	
	$baseModuleDirectory = "C:\Users\$($env:UserName)\Documents\PowerShell\Modules\PruneLocal"

	# Create powershell module directory for user
	if (!(Test-Path -Path $baseModuleDirectory)) { 
		New-Item -Type Directory -Path $baseModuleDirectory 
	}

	if (Test-Path -Path ".\PruneLocal.psm1" -PathType Leaf){
		if (!(Test-Path -Path "${baseModuleDirectory}\PruneLocal.psm1" -PathType Leaf)){
			Copy-Item ".\PruneLocal.psm1" -Destination "${baseModuleDirectory}"
		}	
	}
}

if ($IsLinux) {
	
	$username = whoami
	$baseModuleDirectory = "/home/${username}/.local/share/powershell/Modules/PruneLocal";
	
	# Create powershell module directory for user
	if (!(Test-Path -Path $baseModuleDirectory)) { 
		New-Item -Type Directory -Path $baseModuleDirectory 
	}
	
	if (Test-Path -Path "./PruneLocal.psm1" -PathType Leaf){
		if (!(Test-Path -Path "${baseModuleDirectory}/PruneLocal.psm1" -PathType Leaf)){
			Copy-Item "./PruneLocal.psm1" -Destination "${baseModuleDirectory}"
		}	
	}
}
