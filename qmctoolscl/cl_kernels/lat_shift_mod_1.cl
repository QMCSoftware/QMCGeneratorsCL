__kernel void lat_shift_mod_1(
    // Shift mod 1 for lattice points
    const ulong r, // replications
    const ulong n, // points
    const ulong d, // dimension
    const ulong bs_r, // batch size for replications
    const ulong bs_n, // batch size for points
    const ulong bs_d, // batch size for dimension
    const ulong r_x, // replications in x
    __global const double *x, // lattice points of size r_x*n*d
    __global const double *shifts, // shifts of size r*d
    __global double *xr // pointer to point storage of size r*n*d
){
    ulong l0 = get_global_id(0)*bs_r;
    ulong i0 = get_global_id(1)*bs_n;
    ulong j0 = get_global_id(2)*bs_d;
    ulong ii_max = (n-i0)<bs_n ? (n-i0):bs_n;
    ulong jj_max = (d-j0)<bs_d ? (d-j0):bs_d;
    ulong ll_max = (r-l0)<bs_r ? (r-l0):bs_r;
    ulong ll,l,ii,i,jj,j,idx;
    ulong nelem_x = r_x*n*d;
    for(ll=0; ll<ll_max; ll++){
        l = l0+ll;
        for(ii=0; ii<ii_max; ii++){
            i = i0+ii;
            for(jj=0; jj<jj_max; jj++){
                j = j0+jj;
                idx = l*n*d+i*d+j;
                xr[idx] = (double)(fmod((double)(x[(idx)%nelem_x]+shifts[l*d+j]),(double)(1.)));
            }
        }
    }
}
