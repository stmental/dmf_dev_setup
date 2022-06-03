# Copies a PruneLocal powershell module to the current users PowerShell directory
# which should make it available automatically to use in powershell (part of the PSModulePath env variable path)

if ($IsWindows) {

	if ($env:PSModulePath -eq $null) {
		Write-Output "Powershell does not appear to be installed.  Stopping."
	}else {
		$psPath = "C:\Users\$($env:UserName)\Documents\PowerShell\Modules"
		if (!($env:PSModulePath -split ';' -contains $psPath)) {
			Write-Output "PSModulePath does not contain ${psPath}.  Stopping."
		}else {
			$baseModuleDirectory = "${psPath}\PruneLocal"
			Write-Output "Creating PruneLocal powershell module in ${baseModuleDirectory}"

			# Create powershell module directory for user
			if (!(Test-Path -Path $baseModuleDirectory)) { 
				New-Item -Type Directory -Path $baseModuleDirectory 
			}

			if (Test-Path -Path ".\PruneLocal.psm1" -PathType Leaf){		
				Copy-Item ".\PruneLocal.psm1" -Destination "${baseModuleDirectory}"
			}
		}
	}
}

if ($IsLinux) {
	
	$username = whoami
	if ($env:PSModulePath -eq $null) {
		Write-Output "Powershell does not appear to be installed.  Stopping."
	}else {
		$psPath = "/home/${username}/.local/share/powershell/Modules"
		if (!($env:PSModulePath -split ';' -contains $psPath)) {
			Write-Output "PSModulePath does not contain ${psPath}.  Stopping."
		}else {	
			$baseModuleDirectory = "${psPath}/PruneLocal";
			
			Write-Output "Creating PruneLocal powershell module in ${baseModuleDirectory}"
			
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
					Write-Output "Updating .bashrc file to source new ~/.devrc where powershell aliases are defined"
					Write-Output "prunelocal and prunelocalhard aliases will be available in new shell instances or after re-sourcing ~/.bashrc"
					echo "# Source the devrc setup if available" >> "${HOME}/.bashrc"
					echo "if [ -f ~/.devrc ]; then" >> "${HOME}/.bashrc"
					echo "   . ~/.devrc" >> "${HOME}/.bashrc"
					echo "fi" >> "${HOME}/.bashrc"
				}
			}		
		}
	}
	
	

	
}
