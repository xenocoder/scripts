#test code to read an OpenDAP file

url = 'http://oceanwatch.pifsc.noaa.gov/thredds/dodsC/pfgac/weekly'

nc = nc_open(url)

lat = nc$dim[[1]]$vals
lon = nc$dim[[2]]$vals
t = nc$dim[[3]]$vals
t.units = nc$dim[[3]]$units
junk = strsplit(t.units,"hour since ")[[1]][2] #return start date as string
tstart = as.Date(junk,format="%Y-%m-%d %H:%M:%S") #Turn into date object which be used as an offset
dates=as.Date(t/24,origin=tstart,tz="GMT")


