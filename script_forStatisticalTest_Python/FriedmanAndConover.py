"""
Statistical Analysis Script: Friedman and Conover Tests

Usage:
    python FriedmanAndConover.py <data.csv>

Input Data Format:
    The CSV file must follow this structure (no header row expected):
    
    stim1, <value_slice1>, <value_slice2>, ...
    stim2, <value_slice1>, <value_slice2>, ...
    stim3, <value_slice1>, <value_slice2>, ...

    - Rows represent different stimuli.
    - Columns represent different tissue slices.
"""

import sys
import pandas as pd
from scipy import stats
import numpy as np
import scikit_posthocs as sp
import math
from matplotlib.colors import LinearSegmentedColormap,LogNorm
import seaborn as sns
import matplotlib.pyplot as plt
import os


# scientific notation used in the colormap for p-value
def format_scientific(value):
    parts = f"{value:.1e}".split('e')
    base = parts[0]
    exponent = int(parts[1]) 
    
    if exponent == 0:
        return f"${base}$"
    else:
        return f"${base} \\times 10^{{{exponent}}}$"


def Func_print_partition():
    print('---------------------------------------------------')
    return


# --- Main code ---
# read data from csv
args = sys.argv
filename_CSV  = args[1]

df = pd.read_csv(filename_CSV,header=None)

Func_print_partition()
print(filename_CSV)



# Friedman test
statistic, p_value = stats.friedmanchisquare(*[df.loc[x,1:] for x in np.arange(df.shape[0])])
if p_value < 0.05:
    print('Friedman Test : X^2 = '+'{:.3g}'.format(statistic)+', p<0.05 (p='+'{:.3g}'.format(p_value)+')')
else:
    print('Friedman Test : X^2 = '+'{:.3g}'.format(statistic)+', p>0.05 (p='+'{:.3g}'.format(p_value)+')')
    sys.exit() # if p>0.05, post-hoc test is not running


# Friedman test
print('Results in Conover post-hoc test\n')
data = np.array(df.loc[:,1:])
p_valueList = sp.posthoc_conover_friedman(data.T,p_adjust='holm')

for ii in range(0, df.shape[0], 1):
    for jj in range(ii+1, df.shape[0], 1):
        if p_valueList.loc[ii,jj] <= 0.001:
            print(df.loc[ii,0] + ' v.s. ' + df.loc[jj,0]+': ***  p<0.001 (p='+'{:.3g}'.format(p_valueList.loc[ii,jj])+')')
        elif p_valueList.loc[ii,jj] <= 0.01:
            print(df.loc[ii,0] + ' v.s. ' + df.loc[jj,0]+': **   p<0.010 (p='+'{:.3g}'.format(p_valueList.loc[ii,jj])+')')
        elif p_valueList.loc[ii,jj] <= 0.05:
            print(df.loc[ii,0] + ' v.s. ' + df.loc[jj,0]+': *    p<0.050 (p='+'{:.3g}'.format(p_valueList.loc[ii,jj])+')')
        elif p_valueList.loc[ii,jj] <= 0.5:
            print(df.loc[ii,0] + ' v.s. ' + df.loc[jj,0]+': n.s. p>0.050 (p='+'{:.3g}'.format(p_valueList.loc[ii,jj])+')')

Func_print_partition()


# colormap for p-value - step1 : make original colorbar
colormap_minValue = 1e-20
colormap_maxValue = 1
threshold_value = 1-(math.log10(0.05) / math.log10(colormap_minValue))
mycolors = [
    (0.00000, [0.961, 0.762, 0.762]),
    (colormap_minValue, [0.961, 0.762, 0.762]),
    (threshold_value, [255/255, 235/255, 235/255]),
    (threshold_value, [255/255, 248/255, 220/255]),    
    (1.00000, [245/255, 250/255, 245/255])      
]

my_cmap = LinearSegmentedColormap.from_list('my_custom_pvalue_cmap', mycolors,N=10000)


# colormap for p-value - step2: make string of p-value
fmt_string = '.2e' 
formatted_values = p_valueList.map(lambda x: format_scientific(x))

annot_labels = np.where(p_valueList <= 0.001,formatted_values,formatted_values)

annot_labels = pd.DataFrame(annot_labels,index=p_valueList.index,columns=p_valueList.columns)


# colormap for p-value - step3: plot
if df.shape[0] == 7:
    fontSize = 22
elif df.shape[0] == 8:
    fontSize = 19
elif df.shape[0] == 10:
    fontSize = 14
else:
    fontSize = 1

plt.rcParams['font.family'] = 'Arial'
fig, ax = plt.subplots(figsize=(10, 8))
mask = 1 - np.triu(np.ones_like(p_valueList, dtype=bool)).T
sns.heatmap(p_valueList, annot=annot_labels, annot_kws={"fontsize":fontSize,"color": 'black'}, fmt='', cmap=my_cmap, mask=mask, cbar_kws={'shrink': 0.8},
            ax=ax, xticklabels=df.loc[:,0], yticklabels=df.loc[:,0], norm=LogNorm(vmin=colormap_minValue, vmax=colormap_maxValue))


fig = plt.gcf()
fig.set_size_inches(16.5, 7)
plt.title(filename_CSV)
plt.tight_layout()

# colormap for p-value - step4: save
plt.savefig('SavePNG//'+os.path.splitext(os.path.basename(filename_CSV))[0]+'.png', format='png', bbox_inches='tight')
plt.savefig('SaveSVG//'+os.path.splitext(os.path.basename(filename_CSV))[0]+'.svg', format='svg', bbox_inches='tight')
plt.close()