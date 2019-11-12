$ErrorActionPreference = "Stop"

Install-WindowsFeature containers
# reboot

$dockerVersions = curl.exe https://dockermsft.blob.core.windows.net/dockercontainer/DockerMsftIndex.json | convertfrom-json

$latest = $dockerVersions.channels.18.09.version
curl.exe -Lo docker.zip $dockerVersions.versions.$latest.url

Expand-Archive docker.zip -DestinationPath $Env:ProgramFiles -Force

rm -Force docker.zip


# Add Docker to the path for the current session.
$env:path += ";$env:ProgramFiles\docker"

# Optionally, modify PATH to persist across sessions.
$newPath = "$env:ProgramFiles\docker;" +
[Environment]::GetEnvironmentVariable("PATH",
[EnvironmentVariableTarget]::Machine)

[Environment]::SetEnvironmentVariable("PATH", $newPath,
[EnvironmentVariableTarget]::Machine)

# Register the Docker daemon as a service.
dockerd --register-service

# Start the Docker service.
Start-Service docker

