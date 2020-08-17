#!python3
import csv

for mode in ['normal', 'relaxed']:
    for alpha in ['0.01', '0.05']:
        for phi in ['3', '5', '7', '99']:
            for pixelType in ['foreground']:
                for pixelPos in ['corner', 'edge', 'free']:
                    fname = 'C:/Users/Domin/Dropbox/Masterarbeit/CSV/CSV_SinglePixel/' + mode + '/alpha' + alpha + '/phi' + phi + '/' + pixelType + '_' + pixelPos + '.csv'
                    with open(fname, newline='') as f:
                        r = csv.reader(f)
                        data = [line for line in r]
                        data_write = data.copy()
                        data_write[0] = ['sigma', 'upperBound']
                        for i in range(1, 151):
                            data_write[i] = [data[i][0], str(min(float(data[i][1]) * (int(phi) ** 2), 1))]
                    fname = 'C:/Users/Domin/Dropbox/Masterarbeit/CSV/CSV_UpperBound/' + mode + '/alpha' + alpha + '/phi' + phi + '/' + pixelType + '_' + pixelPos + '.csv'
                    with open(fname, 'w', newline='') as f:
                        w = csv.writer(f)
                        w.writerows(data_write)