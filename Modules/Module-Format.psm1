sOMETHING LIKE...

Params
    $tag = name of the box or target for folder later
    $ip = ip of the box
    $module
    $cidr = optional cidr range for tools that need specific
    
    $scan1 =  do a scan
    $scan2 = do a related scan
    $scans = $scan1 + $scan2
        $optionaltasks = do some post processing on $scans
            $tasked = new object after tasks?
    $results = mk folder for $tags\$module\$.txt and set-content $scans in $tags\$module\$.txt ETC
