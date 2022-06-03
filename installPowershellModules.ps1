# Copies a PruneLocal powershell module to the current users PowerShell directory
# which should make it available automatically to use in powershell (part of the PSModulePath env variable path)

if ($IsWindows) {

	
	$baseModuleDirectory = "C:\Users\$($env:UserName)\Documents\PowerShell\Modules\PruneLocal"

	# Create powershell module directory for user
	if (!(Test-Path -Path $baseModuleDirectory)) { 
		New-Item -Type Directory -Path $baseModuleDirectory 
	}

	if (Test-Path -Path ".\PruneLocal.psm1" -PathType Leaf){		
		Copy-Item ".\PruneLocal.psm1" -Destination "${baseModuleDirectory}"
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
		Copy-Item "./PruneLocal.psm1" -Destination "${baseModuleDirectory}"
	}
	
	# Copy the devrc.sh file to the user home directory
	if (Test-Path -Path "./devrc.sh" -PathType Leaf){
		Copy-Item "./devrc.sh" -Destination "${HOME}/.devrc"
	}	
	
	# Update .bashrc to include devrc.sh file
	if (Test-Path -Path "${HOME}/.bashrc" -PathType Leaf){
		$file = Get-Content "${HOME}/.bashrc"
		$containsWord = $file | %{$_ -match ".devrc"}
		if(!($containsWord -contains $true)) {
			echo "if [ -f ~/.devrc ]; then" >> "${HOME}/.bashrc"
			echo ". ~/.devrc" >> "${HOME}/.bashrc"
			echo "fi" >> "${HOME}/.bashrc"
		}
	}
	
}
