#!/bin/sh

echo "<p>The host is: `uname -n`</p>" >> /usr/share/nginx/html/index.html
echo "<p>The host has free space under / of: `df -h / `</p>" >> /usr/share/nginx/html/index.html
