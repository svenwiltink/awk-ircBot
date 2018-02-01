#/bin/sh

awk -f createIncludeFile.awk;
awk -f client.awk
