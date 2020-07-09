#!python3
import csv

for mode in ['normal', 'relaxed']:
    for alpha in ['0.01', '0.05']:
        for phi in ['3', '5', '7', '99']:
            for dim in ['128', '256', '512']:
                for filetype in ['', '_o', '_oc']:
                    name = 'C:/Users/Domin/Dropbox/Masterarbeit/ROI-Detection/SIMULATION/CSV/' + mode + '/alpha' + alpha + '/phi' + phi + '/dim' + dim + '/resultsErrorTestCasesTypeI' + filetype + '.csv'
                    with open(name, newline='') as f:
                        r = csv.reader(f)
                        data = [line for line in r]
                    with open(name, 'w', newline='') as f:
                        w = csv.writer(f)
                        w.writerow(['sigma','probtypeI'])
                        w.writerows(data)