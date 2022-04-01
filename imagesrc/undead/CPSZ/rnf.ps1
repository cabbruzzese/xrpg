get-childitem L*

get-childitem L* | rename-item -newname { [string]($_.name).split(',')[3] + ".png" }

get-childitem *