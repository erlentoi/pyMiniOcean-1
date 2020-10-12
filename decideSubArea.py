import numpy as np

def decideSubArea(os,imax,jmax, imax_sub,jmax_sub,kmax_sub):

   areaTooShallow = True

   while areaTooShallow:
      iStart = np.random.randint(0,imax-imax_sub+1)
      iEnd = iStart+imax_sub

      jStart = np.random.randint(0,jmax-jmax_sub+1)
      jEnd = jStart+jmax_sub

      shouldLoop = True
      for i in range(iStart,iEnd):
         for j in range(jStart,jEnd):
            if os.kmm[i, j] < kmax_sub:
               shouldLoop = False
               break
         if not shouldLoop:
            break
      if shouldLoop:
         areaTooShallow = False
# Hva skal skje hvis det ikke finnes et dypt nok område?
   print("FOUND AREA:", iStart, iEnd, jStart, jEnd)
   return iStart, iEnd, jStart, jEnd









