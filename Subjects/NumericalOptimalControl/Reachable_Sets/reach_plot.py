import numpy as np
import matplotlib.pyplot as plt
import openpyxl


# Timing the various points in x-y plane
wb = openpyxl.load_workbook('example.xlsx')
state_sheet = wb['States']
time_sheet = wb['Time']
data_sheet = wb['Data']

m = int(data_sheet['A1'].value)
n = int(data_sheet['B1'].value)

dist_scale = 0.2
v = 1
dt = dist_scale*v
time_scale = np.linspace(0, 10, 10/dt)

points = np.zeros([m*n, 2])
T = np.zeros([m*n])
counter = 0
for i in range(0, m):
    for j in range(0, n):
        points[counter, 0] = float(state_sheet['A'+str(counter+1)].value)
        points[counter, 1] = float(state_sheet['B'+str(counter+1)].value)
        T[counter] = float(time_sheet['A'+str(counter+1)].value)
        counter += 1



Time = []
for j in range(0, int(10/dt)):
    Time.append(np.array([points[i,:] for i in range(0, m*n) if time_scale[j]<T[i]<=time_scale[j+1]]))


# count = 0
# for pt in Time:
#     if len(pt) !=0:
#         plt.figure(count)
#         plt.plot(pt[:,0], pt[:,1])
#     count += 1
X = points[:,0].reshape([m, n])
Y = points[:,1].reshape([m, n])
Z = T[:].reshape([m, n])
plt.style.use('seaborn-white')
plt.contour(X , Y, Z, 20, cmap='RdGy')
plt.grid()
plt.show()
