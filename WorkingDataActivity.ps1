$filename = "D:\OneDrive - The Francis Crick Institute\WorkingDataActivityRecord.txt"
$latestdate = [datetime]::MinValue;
#$latestdate = (Get-Date).AddDays(-7)

foreach($line in Get-Content $filename) {
    $line.Split(";").Split("=") | Where-Object {$_ -match "\d\d/\d\d/\d\d\d\d \d\d:\d\d:\d\d"} | ForEach-Object{
        $currentdate = [datetime]::parseexact($_, 'dd/MM/yyyy HH:mm:ss', $null)
        if($currentdate -gt $latestdate){
            $latestdate = $currentdate
        }
    }
}

$latestdate = $latestdate.AddSeconds(1);

Add-Content "D:\OneDrive - The Francis Crick Institute\WorkingDataActivityRecord.txt" (
    Get-ChildItem -Path "D:\OneDrive - The Francis Crick Institute\Working Data" -Recurse |
    Where-Object -FilterScript {
        ($_.LastWriteTime -gt $latestdate) -and ($_.PSIsContainer)
    } |
    Select-Object LastWriteTime, FullName
)