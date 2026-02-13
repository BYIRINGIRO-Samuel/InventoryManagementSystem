# run-webapp.ps1
$ErrorActionPreference = "Stop"

$workingDir = Get-Location
$mvnDir = Join-Path $workingDir ".mvn\wrapper"
$jarPath = Join-Path $mvnDir "maven-wrapper.jar"
$propertiesPath = Join-Path $mvnDir "maven-wrapper.properties"

if (-not (Test-Path $mvnDir)) {
    New-Item -ItemType Directory -Force -Path $mvnDir
}

# 1. Download Maven Wrapper JAR if it doesn't exist
if (-not (Test-Path $jarPath)) {
    Write-Host "Downloading Maven Wrapper JAR..." -ForegroundColor Cyan
    $wrapperUrl = (Select-String -Path $propertiesPath -Pattern "wrapperUrl=(.*)" | ForEach-Object { $_.Matches.Groups[1].Value.Trim() })
    if (-not $wrapperUrl) { $wrapperUrl = "https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/3.2.0/maven-wrapper-3.2.0.jar" }
    Invoke-WebRequest -Uri $wrapperUrl -OutFile $jarPath
}

# 2. Build and Run the Web Application
Write-Host "Starting IMS Web Application..." -ForegroundColor Green

$mvnBaseArgs = @(
    "-Dmaven.multiModuleProjectDirectory=$workingDir",
    "-classpath", $jarPath,
    "org.apache.maven.wrapper.MavenWrapperMain"
)

Write-Host "Compiling and running on Tomcat..." -ForegroundColor Cyan
Write-Host "Once started, access the app at: http://localhost:8080/stockio" -ForegroundColor Yellow

# Use cmd /c to run the java command for better reliability in PowerShell
$cmdStr = "java -Dmaven.multiModuleProjectDirectory=`"$workingDir`" -classpath `"$jarPath`" org.apache.maven.wrapper.MavenWrapperMain clean jetty:run"
cmd /c $cmdStr
