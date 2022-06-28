nmap basic syn, ping, udp -p-, arp, sv to respective xml files 
kick off the long, -A -O -sC -p- summary xml which we'll use primarily with nmap parse

Open the Sup scan to look at what what's up
Wait until -sV scan is done and then open it,
Select all objects that meet criteria network=*22, 21, 23* microsoft=*3389, 139, 135, 445* web=*80, 443, 8080* categories to start running more scripts/nikto/gobuster,etc 

If *web*
    start gobuster and feroxbuster with medium word list, output, then start Ferox with a huge list on a slower setting
    start Nikto/Zap/Nuclei whichever you're using or want to use to strt running scans on anything with web ports and output

if *network*
    if 23 try telnet and safe scripts
        further or aux script
    if 21 try FTP scripts
        furhter or aux script

if *microsoft*

