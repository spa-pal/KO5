del "snmp.bib" /f /q
del "mib.h" /f /q

mib2bib.exe KO5_007_mcp.mib

copy "snmp.bib" ..
copy "snmp.bib" ..\WebPages2
copy "mib.h" ..
copy "mib.h" ..\WebPages2
pause