#ifdef __cplusplus
extern "C" {
#endif

void  ** malloc__alloc_2d(int y, int x, int size);
void *** malloc__alloc_3d(int z, int y, int x, int size);
void      malloc__free_2d(void **h, int y);
void      malloc__free_3d(void ***h, int z, int y);

#ifdef __cplusplus
}
#endif
