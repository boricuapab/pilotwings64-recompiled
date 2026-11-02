#ifndef APP_MISSI_H
#define APP_MISSI_H

#include <uv_vector.h>

s32 missiIsActive(void);
void missiLoadLStates(void);
void missiDeinitLStates(void);
f32 missiGetInterval(void);
void missiGetPos(Vec3F* pos);
void missiSetInterval(f32 interval);
void missiInit(void);
void missiStateSave(void);
void missiStateRestore(void);

#endif // APP_MISSI_H
