foreach ($Target in $Targets) {

    # Confirm that target is not empty
    if($Target -ne "") {
        
        # Initialise Output Object
        $OutputObject = New-Object psobject -Property @{
            Target = $Target;
            Arguments = $Arguments;
            StartTime = Get-Date;
            FinishTime = $NULL;
            Duration = $NULL;
            OutFile = $NULL;
            Hash = $NULL
        }