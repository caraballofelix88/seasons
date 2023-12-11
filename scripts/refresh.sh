#!/bin/sh
python add_imgs.py
cog --verbosity=0 -d -o ../generated/seasons_out.star seasons.star 
pixlet render ../generated/seasons_out.star -o ../generated/seasons_out.webp
pixlet push $(pixlet devices | awk '{print $1}') ../generated/seasons_out.webp
