$UsersFolders = Get-ChildItem C:\Users\ | Select-Object Name,FullName | Where-Object {($_.FullName -ne 'C:\Users\Public') -and ($_.FullName -ne 'C:\Users\Administrator')}



Foreach ($UserFolder in $UsersFolders) {
    $Ost = $False
    $Ost = ($UserFolder | Select-Object -ExpandProperty FullName) + '\AppData\Local\Microsoft\Outlook\'
    $Ost = Get-ChildItem $Ost -ErrorAction 'SilentlyContinue' | Where-Object {$_.Name -match '.ost'} | Select-Object -ExpandProperty FullName
    if ($Ost) {
        $Destination = 'D:\' + ($UserFolder | Select-Object -ExpandProperty Name) + '\'
        mkdir $Destination
        Move-Item $Ost -Destination $Destination
        $Destination = Get-ChildItem $Destination | Select-Object -ExpandProperty FullName
        New-Item -Path $Ost -ItemType SymbolicLink -Value $Destination
        echo $Ost
        echo $Destination
    }
}
