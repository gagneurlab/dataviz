#!/bin/bash

dir="/s/public_webshare/project/dataviz_script/"

setfacl -R -m g::rwX $dir
setfacl -R -dm g::rwX $dir
setfacl -R -m o::--- $dir
setfacl -R -dm o::--- $dir
setfacl -R -m g:admins:rwX $dir
setfacl -R -dm g:admins:rwX $dir
setfacl -R -m g:admins:rwX $dir
setfacl -R -dm g:admins:rwX $dir
setfacl -R -m g:ag_gagneur:rwX $dir
setfacl -R -dm g:ag_gagneur:rwX $dir
setfacl -R -m g:www-data:r-X $dir
setfacl -R -dm g:www-data:r-X $dir

