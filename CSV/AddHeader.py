#!python3
import csv

for mode in ['normal', 'relaxed']:
    for alpha in ['0.01', '0.05']:
        for phi in ['3', '5', '7', '99']:
            for pixelType in ['background', 'foreground']:
                for pixelPos in ['corner', 'edge', 'free']:
                    fname = 'C:/Users/Domin/Dropbox/Masterarbeit/CSV/CSV_SinglePixel/' + mode + '/alpha' + alpha + '/phi' + phi + '/' + pixelType + '_' + pixelPos + '.csv'
                    with open(fname, newline='') as f:
                        r = csv.reader(f)
                        data = [line for line in r]
                    with open(fname, 'w', newline='') as f:
                        w = csv.writer(f)
                        if pixelType == 'background':
                            w.writerow(['sigma','typeI','typeI_o','typeI_oc'])
                        elif pixelType == 'foreground':
                            w.writerow(['sigma','typeII','typeII_o','typeII_oc'])
                        w.writerows(data)