# Loading state from NetCDF file, and storing state to NetCDF
import matplotlib.pyplot as plt
from scipy.io import netcdf
import numpy as np
from netCDF4 import Dataset
import datetime
from pathlib import Path

import utils

def initSaveFile(filename, imax, jmax, kmax, depth, layerDepths):

    nf = Dataset(filename, "w", format="NETCDF3_CLASSIC")
    t_dim = nf.createDimension('time', None)
    x_dim = nf.createDimension("xc", imax)
    y_dim = nf.createDimension("yc", jmax)
    z_dim = nf.createDimension("zc", kmax)
    nf.createVariable("time", "f8", ('time',))
    nf.createVariable("zc", "f8", ('zc',))
    nf.createVariable("depth", "f8", ('yc', 'xc'))
    nf.createVariable("U", "f8", ('time', 'zc', 'yc', 'xc'))
    nf.createVariable("V", "f8", ('time', 'zc', 'yc', 'xc'))
    nf.createVariable("W", "f8", ('time', 'zc', 'yc', 'xc'))
    nf.createVariable("T", "f8", ('time', 'zc', 'yc', 'xc'))
    nf.createVariable("S", "f8", ('time', 'zc', 'yc', 'xc'))
    nf.createVariable("E", "f8", ('time', 'yc', 'xc'))
    nf.createVariable("X", "f8", ('time', 'zc', 'yc', 'xc'))
    # Variables for wind input:
    nf.createVariable("windU", "f8", ('time', 'yc', 'xc'))
    nf.createVariable("windV", "f8", ('time', 'yc', 'xc'))
    # Grid and depth information:
    nf.variables['zc'][:] = layerDepths
    nf.variables['depth'][:, :] = np.transpose(depth)
    #print(nf.variables)
    nf.close()

def saveState(filename, time, os):
    nf = Dataset(filename, "a", format="NETCDF3_CLASSIC")
    indx = nf.variables['time'].shape[0]
    nf.variables['time'][indx] = time
    nf.variables['U'][indx,:,:,0:os.imax-1] = np.transpose(os.U[...], (2, 1, 0))
    nf.variables['V'][indx,:,0:os.jmax-1,:] = np.transpose(os.V[...], (2, 1, 0))
    nf.variables['W'][indx,:,:,:] = np.transpose(os.W[:,:,0:os.kmax], (2, 1, 0))
    nf.variables['T'][indx,...] = np.transpose(os.T[...], (2, 1, 0))
    nf.variables['S'][indx,...] = np.transpose(os.S[...], (2, 1, 0))
    nf.variables['E'][indx,...] = np.transpose(os.E)
    nf.variables['X'][indx,...] = np.transpose(os.X[...], (2, 1, 0))
    nf.variables['windU'][indx,:,0:os.imax-1] = np.transpose(os.windU[...])
    nf.variables['windV'][indx,0:os.jmax-1,:] = np.transpose(os.windV[...])
    nf.close()



def initInputFile(filename,iStart, iEnd, jStart, jEnd, kEnd, depth, layerDepths,saveIntSamples, nSamples):


    nf = Dataset(filename, "w", format="NETCDF3_CLASSIC")

    x_dim = nf.createDimension("xc", iEnd-iStart)   #Fjernet time dimensjonen
    y_dim = nf.createDimension("yc", jEnd-jStart)
    z_dim = nf.createDimension("zc", kEnd)

    n_time_samples = nSamples/saveIntSamples

    t_dim = nf.createDimension('time', 1 + int(n_time_samples)) #initaltilstandene + tilstandene for alle tidssamplinger
    run_dim = nf.createDimension('run', None)

    x_bound_dim = nf.createDimension("xc_b", 2*(jEnd-jStart))
    y_bound_dim = nf.createDimension("yc_b", 2*(iEnd-iStart))
    e_bound_dim = nf.createDimension("ec_b", 2*(iEnd-iStart) + 2*(jEnd-jStart))

    nf.createVariable("run", "f8", ('run',))
    nf.createVariable("time", "f8", ('time',))
    nf.createVariable("zc", "f8", ('zc',))
    nf.createVariable("depth", "f8", ('yc', 'xc'))
    nf.createVariable("U", "f8", ('run', 'time', 'zc', 'yc', 'xc'))
    nf.createVariable("V", "f8", ('run', 'time', 'zc', 'yc', 'xc'))
    nf.createVariable("W", "f8", ('run', 'time', 'zc', 'yc', 'xc'))
    nf.createVariable("T", "f8", ('run', 'time', 'zc', 'yc', 'xc'))
    nf.createVariable("S", "f8", ('run', 'time', 'zc', 'yc', 'xc'))
    nf.createVariable("E", "f8", ('run', 'time', 'yc', 'xc'))
    nf.createVariable("X", "f8", ('run', 'time', 'zc', 'yc', 'xc'))

    nf.createVariable("windU", "f8", ('run', 'time', 'yc', 'xc'))
    nf.createVariable("windV", "f8", ('run', 'time', 'yc', 'xc'))

    nf.createVariable("U_b", "f8", ('run', 'time', 'zc', 'xc_b'))
    nf.createVariable("V_b", "f8", ('run', 'time', 'zc', 'yc_b'))
    nf.createVariable("E_b", "f8", ('run', 'time', 'ec_b'))
    nf.variables['zc'][:] = layerDepths[0:kEnd]
    nf.variables['depth'][:] = np.transpose(depth[iStart:iEnd, jStart:jEnd])
    #print(nf.variables)
    nf.close()

def saveInputFile(filename, iStart, iEnd, jStart, jEnd, kEnd, os, time, tEnd):
    nf = Dataset(filename, "a", format="NETCDF3_CLASSIC")

    time_indx = int((time/tEnd) * nf.variables['time'].shape[0])
    if time == tEnd:
        time_indx = time_indx-1
    nf.variables['time'][time_indx] = time

    run_indx = nf.variables['run'].shape[0]-1
    if time == 0:
        print("Ny run")
        run_indx = nf.variables['run'].shape[0]
        nf.variables['run'][int(run_indx)] = int(run_indx) ###Setter NESTE indeks



    nf.variables['U'][run_indx, time_indx, :, :, :-1] = np.transpose(os.U[iStart:iEnd - 1, jStart:jEnd, 0:kEnd], (2, 1, 0))
    nf.variables['V'][run_indx, time_indx, :, :-1, :] = np.transpose(os.V[iStart:iEnd, jStart:jEnd - 1, 0:kEnd], (2, 1, 0))
    nf.variables['W'][run_indx, time_indx, ...] = np.transpose(os.W[iStart:iEnd, jStart:jEnd, 0:kEnd], (2, 1, 0))
    nf.variables['T'][run_indx, time_indx, ...] = np.transpose(os.T[iStart:iEnd, jStart:jEnd, 0:kEnd], (2, 1, 0))
    nf.variables['S'][run_indx, time_indx, ...] = np.transpose(os.S[iStart:iEnd, jStart:jEnd, 0:kEnd], (2, 1, 0))
    nf.variables['E'][run_indx, time_indx, ...] = np.transpose(os.E[iStart:iEnd, jStart:jEnd])
    nf.variables['X'][run_indx, time_indx, ...] = np.transpose(os.X[iStart:iEnd, jStart:jEnd, 0:kEnd], (2, 1, 0))

    nf.variables['windU'][run_indx, time_indx, :, :-1] = np.transpose(os.windU[iStart:iEnd-1 , jStart:jEnd])
    nf.variables['windV'][run_indx, time_indx, :-1, :] = np.transpose(os.windV[iStart:iEnd, jStart:jEnd -1])

    nf.variables['U_b'][run_indx, time_indx, :, :(jEnd-jStart)] = np.transpose(os.U[iStart-1, jStart:jEnd, 0:kEnd])
    nf.variables['U_b'][run_indx, time_indx, :, (jEnd-jStart):] = np.transpose(os.U[iEnd-1, jStart:jEnd, 0:kEnd])

    nf.variables['V_b'][run_indx, time_indx, :, :(iEnd - iStart)] = np.transpose(os.V[iStart:iEnd, jStart-1, 0:kEnd])
    nf.variables['V_b'][run_indx, time_indx, :, (iEnd - iStart):] = np.transpose(os.V[iStart:iEnd, jEnd-1, 0:kEnd])

    nf.variables['E_b'][run_indx, time_indx, :(iEnd-iStart)] = np.transpose(os.E[iStart:iEnd,jStart-1])
    nf.variables['E_b'][run_indx, time_indx, (iEnd-iStart):2*(iEnd-iStart)] = np.transpose(os.E[iStart:iEnd,jEnd])
    nf.variables['E_b'][run_indx, time_indx, 2*(iEnd-iStart):2*(iEnd-iStart)+(jEnd-jStart)] = np.transpose(os.E[iStart-1, jStart:jEnd])
    nf.variables['E_b'][run_indx, time_indx, 2*(iEnd-iStart)+(jEnd-jStart):2*(iEnd-iStart)+2*(jEnd-jStart)] = np.transpose(os.E[iEnd, jStart:jEnd])
    nf.close()





def initSaveSubsetFile(filename, iStart, iEnd, jStart, jEnd, kEnd, depth, layerDepths):

    nf = Dataset(filename, "w", format="NETCDF3_CLASSIC")
    t_dim = nf.createDimension('time', None)
    x_dim = nf.createDimension("xc", iEnd-iStart)
    y_dim = nf.createDimension("yc", jEnd-jStart)
    z_dim = nf.createDimension("zc", kEnd)
    nf.createVariable("time", "f8", ('time',))
    nf.createVariable("zc", "f8", ('zc',))
    nf.createVariable("depth", "f8", ('yc', 'xc'))
    nf.createVariable("U", "f8", ('time', 'zc', 'yc', 'xc'))
    nf.createVariable("V", "f8", ('time', 'zc', 'yc', 'xc'))
    nf.createVariable("W", "f8", ('time', 'zc', 'yc', 'xc'))
    nf.createVariable("T", "f8", ('time', 'zc', 'yc', 'xc'))
    nf.createVariable("S", "f8", ('time', 'zc', 'yc', 'xc'))
    nf.createVariable("E", "f8", ('time', 'yc', 'xc'))
    nf.createVariable("X", "f8", ('time', 'zc', 'yc', 'xc'))
    nf.variables['zc'][:] = layerDepths[0:kEnd]
    nf.variables['depth'][:] = np.transpose(depth[iStart:iEnd,jStart:jEnd])
    #print(nf.variables)
    nf.close()

def saveStateSubset(filename, iStart, iEnd, jStart, jEnd, kEnd, time, os):
    nf = Dataset(filename, "a", format="NETCDF3_CLASSIC")
    indx = nf.variables['time'].shape[0]
    nf.variables['time'][indx] = time
    nf.variables['U'][indx,:,:,:-1] = np.transpose(os.U[iStart:iEnd-1,jStart:jEnd,0:kEnd], (2, 1, 0))
    nf.variables['V'][indx,:,:-1,:] = np.transpose(os.V[iStart:iEnd,jStart:jEnd-1,0:kEnd], (2, 1, 0))
    nf.variables['W'][indx,...] = np.transpose(os.W[iStart:iEnd,jStart:jEnd,0:kEnd], (2, 1, 0))
    nf.variables['T'][indx,...] = np.transpose(os.T[iStart:iEnd,jStart:jEnd,0:kEnd], (2, 1, 0))
    nf.variables['S'][indx,...] = np.transpose(os.S[iStart:iEnd,jStart:jEnd,0:kEnd], (2, 1, 0))
    nf.variables['E'][indx,...] = np.transpose(os.E[iStart:iEnd,jStart:jEnd])
    nf.variables['X'][indx,...] = np.transpose(os.X[iStart:iEnd,jStart:jEnd,0:kEnd], (2, 1, 0))
    nf.close()



def loadState(sp, file, sample):
    nf = Dataset(file, "r")
    tim = nf.variables['time']
    nSamples = tim.shape[0]
    if sample<0:
        sample = nSamples-1
    dims = nf.variables['T'].shape
    imax = dims[3]
    jmax = dims[2]
    kmax = dims[1]
    os = sp.getOcean(imax, jmax, kmax)
    os.depth = np.transpose(nf.variables['depth'][:, :], (1, 0)).copy()
    layerDepths = nf.variables['zc'][:]
    os.layerDepths = layerDepths
    dz = np.zeros((kmax))
    dz[0] = layerDepths[0]
    for i in range(1,len(dz)):
        dz[i] = layerDepths[i]-layerDepths[i-1]
    os.dz = dz
    os.E = np.transpose(nf.variables['E'][sample,:,:],(1,0)).copy()
    os.T = np.transpose(nf.variables['T'][sample, :, :, :], (2,1,0)).copy()
    os.S = np.transpose(nf.variables['S'][sample, :, :, :], (2, 1, 0)).copy()
    os.U = np.transpose(nf.variables['U'][sample, :, :,:-1], (2, 1, 0)).copy()
    os.V = np.transpose(nf.variables['V'][sample, :, :-1, :], (2, 1, 0)).copy()
    try:
        os.X = np.transpose(nf.variables['X'][sample, :, :, :], (2, 1, 0)).copy()
    except:
        print("Passive tracer not found in init file.")
    nf.close()

    os.calcKmmDzz()

    return os

def loadSINMODState(sp, file, sample, subset=[],subsubArea=[]):
    nf = Dataset(file, "r")
    tim = nf.variables['time']
    nSamples = tim.shape[0]
    if sample < 0:
        sample = nSamples - 1
    timeVec = tim[sample,:]
    initTime = datetime.datetime(timeVec[0], timeVec[1], timeVec[2], timeVec[3], timeVec[4], timeVec[5])

    dims = nf.variables['temperature'].shape
    imax = dims[3]
    jmax = dims[2]
    kmax = dims[1]
    if len(subset)==0:
        subset = [0, imax, 0, jmax]
    imax_m = subset[1]-subset[0]
    jmax_m = subset[3] - subset[2]
    os = sp.getOcean(imax_m, jmax_m, kmax)
    os.depth = np.transpose(nf.variables['depth'][subset[2]:subset[3], subset[0]:subset[1]], (1, 0)).copy()
    os.depth[np.where(os.depth<0)] = 0

    layerDepths = nf.variables['zc'][:]
    os.layerDepths = layerDepths
    dz = np.zeros((kmax))
    dz[0] = layerDepths[0]
    for i in range(1, len(dz)):
        dz[i] = layerDepths[i] - layerDepths[i - 1]
    os.dz = dz

    os.E = np.transpose(nf.variables['elevation'][sample, subset[2]:subset[3], subset[0]:subset[1]], (1, 0)).copy()
    os.T = np.transpose(nf.variables['temperature'][sample, :, subset[2]:subset[3], subset[0]:subset[1]], (2, 1, 0)).copy()
    os.S = np.transpose(nf.variables['salinity'][sample, :, subset[2]:subset[3], subset[0]:subset[1]], (2, 1, 0)).copy()
    os.U = np.transpose(nf.variables['u_velocity'][sample, :, subset[2]:subset[3], subset[0]:subset[1]-1], (2, 1, 0)).copy()
    os.V = np.transpose(nf.variables['v_velocity'][sample, :, subset[2]:subset[3]-1, subset[0]:subset[1]], (2, 1, 0)).copy()

    #################################################################
    avgStd = Dataset("C:/Users/Neio3/Desktop/Fordypningsprosjekt/pyMiniOcean/output_files/stateAvgStd.nc", "r")

    #E_avg= np.transpose(avgStd.variables['E_avg'][:, :]).copy() ###transpose?? copy???
    E_std= np.transpose(avgStd.variables['E_std'][:, :]).copy()

    #T_avg= np.transpose(avgStd.variables['T_avg'][:, :, :]).copy()
    T_std= np.transpose(avgStd.variables['T_std'][:, :, :]).copy()

    #S_avg = np.transpose(avgStd.variables['S_avg'][:, :, :]).copy()
    S_std =np.transpose(avgStd.variables['S_std'][:, :, :]).copy()

    #U_avg = np.transpose(avgStd.variables['U_avg'][:, :, :]).copy()
    U_std = np.transpose(avgStd.variables['U_std'][:, :, :]).copy()
    #V_avg = np.transpose(avgStd.variables['V_avg'][:, :, :]).copy()
    V_std = np.transpose(avgStd.variables['V_std'][:, :, :]).copy()


    for x in range(subsubArea[0], subsubArea[1]):
        for y in range(subsubArea[2], subsubArea[3]):

           # print(os.E[x, y])
           # print("+")
            #print(E_std[y-subsubArea[2],x-subsubArea[0]])
           # print("\n")

            os.E[x, y] += np.random.normal(0, E_std[y-subsubArea[2],x-subsubArea[0]] * 0.05) ############## std til pertubasjon = 5% av std av variabelen
            for z in range(0, subsubArea[4]):

                os.T[x, y, z] += np.random.normal(0, T_std[y - subsubArea[2], x - subsubArea[0], z]* 0.05)
                os.S[x, y, z] += np.random.normal(0, S_std[y - subsubArea[2], x - subsubArea[0], z]* 0.05)    #####transpose?????????? indexing??????

                print(x - subsubArea[0])
                print(y - subsubArea[2])
                print("")
                if x - subsubArea[0] < x-subsubArea[1] - 1:
                    os.U[x, y, z] += np.random.normal(0, U_std[y - subsubArea[2], x - subsubArea[0], z]* 0.05)

                if y - subsubArea[2] < y-subsubArea[3]-1:
                    os.V[x, y, z] += np.random.normal(0, V_std[y - subsubArea[2], x - subsubArea[0], z]* 0.05)
    avgStd.close()
    ##################################################


    #print(nf.variables['u_velocity'].shape)
    #print(os.U.shape)
    #print(os.V.shape)

    os.T[os.T.mask] = 0
    os.S[os.T.mask] = 0

    nf.close()

    os.calcKmmDzz()

    return os, initTime


# Open a SINMOD atmo data file, read and interpret all sample times as datetime objects
def getSINMODAtmoTimes(file):
    nf = Dataset(file, "r")
    tim = nf.variables['time']
    nSamples = tim.shape[0]
    data = tim[:]
    times = []
    timeUnits = tim.getncattr('units')
    nf.close()
    try:
        refTime = datetime.datetime.strptime(timeUnits, 'seconds since %Y-%m-%d %H:%M:%S')
        timeStep = data[1] - data[0]
        for d in data:
            tt = refTime + datetime.timedelta(seconds=round(d))
            times.append(tt)

    except:
        print("Unexpected time format in atmo file.")
        import os
        os.exit()

    return times, timeStep


# Read a given subset area and a given sample number of wind information from a SINMOD atmo file.
def loadSINMODAtmo(file, sample, subset=[]):
    nf = Dataset(file, "r")
    tim = nf.variables['time']
    dims = nf.variables['x_wind'].shape
    imax = dims[2]
    jmax = dims[1]
    if len(subset)==0:
        subset = [0, imax, 0, jmax]
    WU = np.transpose(nf.variables['x_wind'][sample,subset[2]:subset[3], subset[0]:subset[1]], (1, 0)).copy()
    WV = np.transpose(nf.variables['y_wind'][sample, subset[2]:subset[3], subset[0]:subset[1]], (1, 0)).copy()

    return WU, WV

def getDepthMatrix(file):
    nf = Dataset(file, "r")
    depth = np.transpose(nf.variables['depth'][:, :], (1, 0)).copy()
    return depth


