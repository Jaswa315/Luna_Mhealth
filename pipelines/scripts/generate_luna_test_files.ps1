# PowerShell script to scrape the "test" folder of a flutter application
# to create a single test file that calls all the other test files
# this puts all the tests into one dart isolate environment which speeds up testing

param(
    [string]$LunaFolder,
    [string]$OutputFile
)

$testFiles = Get-ChildItem -Path "$LunaFolder/test" -Recurse -Filter "*_test.dart" -File

$newLine = [Environment]::NewLine

$importFormat = "import './{0}' as {1};$newLine" # ./ will work on windows and unix style oses
$mainFormat = "{0}.main();$newLine"

$importLines = @()
$mainCalls = @()

foreach ($file in $testFiles) {
    $alias = $file.name.split(".")[0] # split method is not regex
    $path = (($file.FullName -split "[\\\/]{1}$LunaFolder[\\\/]{1}test[\\\/]{1}")[1]).replace('\','/') # - split is regex
    $importLines += $importFormat -f $path,$alias
    $mainCalls += $mainFormat -f $alias
}

# Combine the imports and main lines into one file
$testFile = @"
$($importLines -join $newLine)
void main() {
$($mainCalls -join $newLine)
}
"@

Out-File -FilePath $OutputFile -InputObject $testFile -Encoding 'utf8'
