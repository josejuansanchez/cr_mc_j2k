#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int BuscarPrecintoEnArchivo(char filename[], int id_in);

int main(int argc, char *argv[])
{
    int id, rb;
    //char data[500];
    char data[524288];
    int l, r, c, py, px;
    FILE *fback, *fout;

    if (argc<4)
    {
        printf("\nUso: %s <archivo.cache WOIs> <archivo.cache BACKGROUND> <archivo.cache OUT>\n",argv[0]);
        return -1;
    }

    fback = fopen(argv[2],"rb");
    if (!fback) return -1;

    fout = fopen(argv[3],"wb");
    if (!fout) return -1;

    fread(&id, sizeof(id), 1, fback);
    fread(&l, sizeof(l), 1, fback);
    fread(&r, sizeof(r), 1, fback);
    fread(&c, sizeof(c), 1, fback);
    fread(&py, sizeof(py), 1, fback);
    fread(&px, sizeof(px), 1, fback);
    fread(&rb, sizeof(rb), 1, fback);
    fread(&data, 1, rb, fback);

    while(!feof(fback))
    {
        if (BuscarPrecintoEnArchivo(argv[1],id) == -1)
        {
            fwrite(&id, sizeof(id), 1, fout);
            fwrite(&l, sizeof(l), 1, fout);
            fwrite(&r, sizeof(r), 1, fout);
            fwrite(&c, sizeof(c), 1, fout);
            fwrite(&py, sizeof(py), 1, fout);
            fwrite(&px, sizeof(px), 1, fout);
            fwrite(&rb, sizeof(rb), 1, fout);
            fwrite(&data, 1, rb, fout);
        }

        fread(&id, sizeof(id), 1, fback);
        fread(&l, sizeof(l), 1, fback);
        fread(&r, sizeof(r), 1, fback);
        fread(&c, sizeof(c), 1, fback);
        fread(&py, sizeof(py), 1, fback);
        fread(&px, sizeof(px), 1, fback);
        fread(&rb, sizeof(rb), 1, fback);
        fread(&data, 1, rb, fback);
    }
    fclose(fback);
    fclose(fout);

    return 0;
}

int BuscarPrecintoEnArchivo(char filename[], int id_in)
{
    int id, rb;
    //char data[500];
    char data[524288];
    int l, r, c, py, px;
    int pos;

    FILE *f = fopen(filename,"rb");
    if (!f) return -1;

    fread(&id, sizeof(id), 1, f);
    fread(&l, sizeof(l), 1, f);
    fread(&r, sizeof(r), 1, f);
    fread(&c, sizeof(c), 1, f);
    fread(&py, sizeof(py), 1, f);
    fread(&px, sizeof(px), 1, f);
    fread(&rb, sizeof(rb), 1, f);
    fread(&data, 1, rb, f);

    pos = -1;

    while(!feof(f))
    {
        if (id==id_in)
        {
            pos = 1;
            break;
        }

        fread(&id, sizeof(id), 1, f);
        fread(&l, sizeof(l), 1, f);
        fread(&r, sizeof(r), 1, f);
        fread(&c, sizeof(c), 1, f);
        fread(&py, sizeof(py), 1, f);
        fread(&px, sizeof(px), 1, f);
        fread(&rb, sizeof(rb), 1, f);
        fread(&data, 1, rb, f);
    }
    fclose(f);

    return pos;
}