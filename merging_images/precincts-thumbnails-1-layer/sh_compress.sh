#kdu_compress -i images_pgm/tree.pgm -o images_j2c/tree.j2c Cuse_sop=yes Corder=LRCP Clayers=1 Clevels=2 Cprecincts="{128,128},{64,64},{32,32}" Cblk="{32,32}" Creversible=yes #Cuse_eph=yes

#kdu_compress -i images_pgm/stockholm.pgm -o images_j2c/stockholm.j2c Cuse_sop=yes Corder=LRCP Clayers=1 Clevels=2 Cprecincts="{128,128},{64,64},{32,32}" Cblk="{32,32}" Creversible=yes #Cuse_eph=yes

kdu_compress -i images_pgm/tree.pgm -o images_j2c/tree.j2c Cuse_sop=yes Corder=RLCP Clayers=1 Clevels=2 Cprecincts="{128,128},{64,64},{32,32}" Cblk="{32,32}" Creversible=yes #Cuse_eph=yes

kdu_compress -i images_pgm/stockholm.pgm -o images_j2c/stockholm.j2c Cuse_sop=yes Corder=RLCP Clayers=1 Clevels=2 Cprecincts="{128,128},{64,64},{32,32}" Cblk="{32,32}" Creversible=yes #Cuse_eph=yes

kdu_compress -i images_pgm/speedway.pgm -o images_j2c/speedway.j2c Cuse_sop=yes Corder=RLCP Clayers=1 Clevels=2 Cprecincts="{64,64},{32,32},{16,16}" Cblk="{16,16}" Creversible=yes #Cuse_eph=yes