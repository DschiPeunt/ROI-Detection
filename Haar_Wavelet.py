import numpy as np
import pywt

def ROI_Generator(N=512, bg_greyval=128):
    #ROI_GENERATOR Generate random rectangle with checkerboard pattern
    # INPUT
    # -----
    # N: height/vertical size of the output matrix
    # N: width/horizontal size of the output matrix
    # bg_greyval: greyscale value for the image background
    
    # Initialize the picture with constant background:
    ROI_Picture = np.ones((N, N)) * bg_greyval
    
    # Generate random bounds for the ROI:
    bounds_vert = np.random.randint(N, size=2)
    bounds_hori = np.random.randint(N, size=2)
    
    # Determine top left corner and bottom right corner of the ROI:
    tlc = np.zeros(2, dtype=np.int64)
    brc = np.zeros(2, dtype=np.int64)
    tlc[0] = np.amin(bounds_vert)
    tlc[1] = np.amin(bounds_hori)
    brc[0] = np.amax(bounds_vert)
    brc[1] = np.amax(bounds_hori)
    
    # Generate ROI pattern:
    for i in range(tlc[0], brc[0] + 1):
        for j in range(tlc[1], brc[1] + 1):
            if np.remainder(i + j, 2) == 0:
                ROI_Picture[i, j] = 0
            elif np.remainder(i + j, 2) == 1:
                ROI_Picture[i, j] = 255
    
    return ROI_Picture

def haarWaveletCoeff(f, N=512):
    # Calculate starting approximation level L:
    L = -1 * np.log2(N).astype("int64")
    
    # Initialize coefficient list:
    coeff = []
    
    # Initialize a_L[n]:
    a = f / N
    
    # Highest approximation level is J = 0:
    for j in range(L, 1):
        d1 = (a[::2, ::2] - a[::2, 1::2] + a[1::2, ::2] - a[1::2, 1::2]) / 2
        d2 = (a[::2, ::2] + a[::2, 1::2] - a[1::2, ::2] - a[1::2, 1::2]) / 2
        d3 = (a[::2, ::2] - a[::2, 1::2] - a[1::2, ::2] + a[1::2, 1::2]) / 2
        a = (a[::2, ::2] + a[::2, 1::2] + a[1::2, ::2] + a[1::2, 1::2]) / 2
        
        # Store d1, d2, d3 in the coefficient list:
        coeff.append((d1, d2, d3))
    
    # Store a_J in the coefficient list:
    coeff.append(a)
    
    return coeff

if __name__ == "__main__":
    # Generate picture with rectangular ROI:
    f = ROI_Generator(N=8)
    f_coeff = haarWaveletCoeff(f, N=8)
    
    # Deconstruct to coefficients and reconstruct the signal using PyWavelets:
    coeff = pywt.wavedec2(f, "haar")
    f_recon = pywt.waverec2(coeff, "haar")
    
    cases = [
    np.array([[128, 128], [128, 128]]),#n
    np.array([[  0,   0], [  0,   0]]),#n
    np.array([[  0,   0], [  0, 256]]),#n
    np.array([[  0,   0], [256,   0]]),#n
    np.array([[  0,   0], [256, 256]]),#n
    np.array([[  0, 256], [  0,   0]]),#n
    np.array([[  0, 256], [  0, 256]]),#n
    np.array([[  0, 256], [256,   0]]),#n
    np.array([[  0, 256], [256, 256]]),#n
    np.array([[256,   0], [  0,   0]]),#n
    np.array([[256,   0], [  0, 256]]),#n
    np.array([[256,   0], [256,   0]]),#n
    np.array([[256,   0], [256, 256]]),#n
    np.array([[256, 256], [  0,   0]]),#n
    np.array([[256, 256], [  0, 256]]),#n
    np.array([[256, 256], [256,   0]]),#n
    np.array([[256, 256], [256, 256]]),#n
    np.array([[128, 128], [128,   0]]),#y
    np.array([[128, 128], [128, 256]]),#y
    np.array([[128, 128], [  0, 128]]),#y
    np.array([[128, 128], [  0,   0]]),#y
    np.array([[128, 128], [  0, 256]]),#y
    np.array([[128, 128], [256, 128]]),#y
    np.array([[128, 128], [256,   0]]),#y
    np.array([[128, 128], [256, 256]]),#y
    np.array([[128,   0], [128, 128]]),#y
    np.array([[128,   0], [128,   0]]),#y
    np.array([[128,   0], [128, 256]]),#y
    np.array([[128, 256], [128, 128]]),#y
    np.array([[128, 256], [128,   0]]),#y
    np.array([[128, 256], [128, 256]]),#y
    np.array([[  0, 128], [128, 128]]),#y
    np.array([[  0, 128], [  0, 128]]),#y
    np.array([[  0, 128], [256, 128]]),#y
    np.array([[  0,   0], [128, 128]]),#y
    np.array([[  0, 256], [128, 128]]),#y
    np.array([[256, 128], [128, 128]]),#y
    np.array([[256, 128], [  0, 128]]),#y
    np.array([[256, 128], [256, 128]]),#y
    np.array([[256,   0], [128, 128]]),#y
    np.array([[256, 256], [128, 128]])]#y
    
    for a in cases:
        d1 = (a[0, 0] - a[0, 1] + a[1, 0] - a[1, 1]) / 2
        d2 = (a[0, 0] + a[0, 1] - a[1, 0] - a[1, 1]) / 2
        d3 = (a[0, 0] - a[0, 1] - a[1, 0] + a[1, 1]) / 2
        
        t1 = d1 + d3
        t2 = d1 - d3
        t3 = d2 + d3
        t4 = d2 - d3
        
        print(a, t1, t2, t3, t4)
        
        # Delete running variables:
        del a, d1, d2, d3, t1, t2, t3, t4