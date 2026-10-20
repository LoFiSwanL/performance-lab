#!/usr/bin/env python3
"""Recompute tabular results from the original logs; no synthetic measurements."""
import json
import re
import statistics
from pathlib import Path
root = Path(__file__).resolve().parent.parent
folder = root / 'results'
summary = {}
for opt in (0, 3):
    times, users, rss = [], [], []
    stats = {}
    for rep in (1, 2, 3):
        text = (folder / f'O{opt}_time{rep}.txt').read_text()
        value = re.search(r'Elapsed .*?: (\S+)', text).group(1)
        parts = [float(p) for p in value.split(':')]
        seconds = 0
        for p in parts: seconds = seconds * 60 + p
        times.append(seconds)
        users.append(float(re.search(r'User time \(seconds\): ([\d.]+)', text).group(1)))
        rss.append(int(re.search(r'Maximum resident set size \(kbytes\): (\d+)', text).group(1)))
        text = (folder / f'O{opt}_stat{rep}.txt').read_text()
        for event in ('cycles', 'instructions', 'L1-dcache-loads', 'L1-dcache-load-misses', 'LLC-loads', 'LLC-load-misses', 'branch-misses'):
            match = re.search(r'^\s*([\d,]+)\s+' + re.escape(event) + r'\s', text, re.M)
            if match: stats.setdefault(event, []).append(int(match.group(1).replace(',', '')))
    energies = [json.loads((folder / f'O{opt}_energy{r}.json').read_text()) for r in (1,2,3)]
    summary[f'O{opt}'] = dict(time_s=times, median_time_s=statistics.median(times),
                             user_s=users, rss_KiB=rss,
                             perf_medians={k:statistics.median(v) for k,v in stats.items()},
                             energy_runs=energies,
                             energy_medians={k:statistics.median(e[k] for e in energies) for k in
                                 ('elapsed_s', 'module_energy_J', 'mean_module_power_W', 'baseline_W', 'incremental_energy_estimate_J')})
(folder / 'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
a,b = summary['O0'],summary['O3']
rows = [('Час, медіана (с)',a['median_time_s'],b['median_time_s'])]
for key in a['perf_medians']:
    rows.append((key,a['perf_medians'][key],b['perf_medians'][key]))
for key in a['energy_medians']:
    rows.append((key,a['energy_medians'][key],b['energy_medians'][key]))
text = '| Показник | -O0 | -O3 |\n|---|---:|---:|\n'
for label,x,y in rows: text += f'| {label} | {x:.3f} | {y:.3f} |\n'
(folder/'comparison.md').write_text(text)
print(text)
