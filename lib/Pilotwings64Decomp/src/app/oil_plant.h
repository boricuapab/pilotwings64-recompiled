#ifndef APP_OIL_PLANT_H
#define APP_OIL_PLANT_H

#include <uv_vector.h>

void oilPlantInit(void);
s32 oilPlantInProximity(void);
void oilPlantLoad(void);
void oilPlantDeinit(void);
void oilPlantGetPos(Vec3F* pos);

#endif // APP_OIL_PLANT_H
