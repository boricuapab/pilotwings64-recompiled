#include "patches.h"
#include "graphics.h"
#include <uv_math.h>
#include <uv_vector.h>
#include "kernel/code_7150.h"

RECOMP_PATCH void func_802061A0(UnkStruct_80204D94* arg0) {
    Vec3F* temp_s1;
    f32 temp_fa0;
    f32 temp_fa1;
    f32 temp_ft4;
    f32 temp_ft5;
    f32 temp_fv0;
    f32 temp_fv1;
    u8 i;
    Vec3F* temp_s0;

    f32 wide_scale = recomp_get_target_aspect_ratio(4.0f / 3.0f) / (4.0f / 3.0f);

    temp_fa1 = (arg0->unk1E8 * wide_scale / arg0->unk1F8) * arg0->unk1FC;
    temp_fa0 = (arg0->unk1EC * wide_scale / arg0->unk1F8) * arg0->unk1FC;
    temp_ft4 = (arg0->unk1F0 / arg0->unk1F8) * arg0->unk1FC;
    temp_ft5 = (arg0->unk1F4 / arg0->unk1F8) * arg0->unk1FC;
    arg0->unk208[0].x = temp_fa0;
    arg0->unk208[0].y = arg0->unk1FC;
    arg0->unk208[0].z = temp_ft4;
    arg0->unk208[1].x = temp_fa0;
    arg0->unk208[1].y = arg0->unk1FC;
    arg0->unk208[1].z = temp_ft5;
    arg0->unk208[2].x = temp_fa1;
    arg0->unk208[2].y = arg0->unk1FC;
    arg0->unk208[2].z = temp_ft5;
    arg0->unk208[3].x = temp_fa1;
    arg0->unk208[3].y = arg0->unk1FC;
    arg0->unk208[3].z = temp_ft4;
    arg0->unk238.x = 0.0f;
    arg0->unk238.y = arg0->unk1FC;
    arg0->unk238.z = 0.0f;
    arg0->unk244.x = 0.0f;
    arg0->unk244.y = 0.0f;
    arg0->unk244.z = 0.0f;
    for (i = 0; i < 4; i++) {
        temp_s1 = &arg0->unk298[i];
        uvVec3Cross(temp_s1, &arg0->unk208[(i + 1) % 4], &arg0->unk208[i]);
        uvVec3Normal(temp_s1, temp_s1);
    }
    temp_s0 = &arg0->unk2C8;
    uvVec3Copy(temp_s0, &arg0->unk238);
    uvVec3Normal(temp_s0, temp_s0);
    arg0->unk2D4.x = -temp_s0->x;
    arg0->unk2D4.y = -temp_s0->y;
    arg0->unk2D4.z = -temp_s0->z;
}
