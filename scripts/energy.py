#!/usr/bin/env python3
"""Measure module VDD_IN; incremental process energy is a baseline estimate."""
import csv
import json
from pathlib import Path
import subprocess
import sys
import time

prefix = Path(sys.argv[1])
command = sys.argv[2:]
prefix.parent.mkdir(parents=True, exist_ok=True)
labels = [p for p in Path('/sys/class/hwmon').glob('hwmon*/in*_label')
          if p.read_text().strip() == 'VDD_IN']
if len(labels) != 1:
    raise SystemExit('Expected exactly one VDD_IN rail')
label = labels[0]
channel = label.name.split('_')[0][2:]
voltage = label.with_name('in' + channel + '_input')
current = label.with_name('curr' + channel + '_input')
rows = []

def sample(phase):
    t = time.monotonic()
    mv, ma = int(voltage.read_text()), int(current.read_text())
    rows.append((phase, t, mv, ma, mv * ma / 1_000_000))

def idle(phase, duration=8):
    end = time.monotonic() + duration
    while time.monotonic() < end:
        sample(phase)
        time.sleep(0.05)

def integrate(phase):
    points = [(r[1], r[4]) for r in rows if r[0] == phase]
    energy = sum((b[0]-a[0])*(a[1]+b[1])/2 for a,b in zip(points,points[1:]))
    duration = points[-1][0] - points[0][0]
    return energy, duration

idle('idle_before')
with prefix.with_suffix('.stdout.txt').open('w') as out:
    sample('run')
    start = rows[-1][1]
    child = subprocess.Popen(command, stdout=out)
    while child.poll() is None:
        sample('run')
        time.sleep(0.05)
    sample('run')
    end = rows[-1][1]
    code = child.returncode
idle('idle_after')
with prefix.with_suffix('.csv').open('w') as f:
    writer = csv.writer(f)
    writer.writerow(['phase','monotonic_s','voltage_mV','current_mA','power_W'])
    writer.writerows(rows)
e0,t0 = integrate('idle_before')
e1,t1 = integrate('idle_after')
e,t = integrate('run')
baseline = (e0/t0 + e1/t1)/2
result = dict(command=command, returncode=code, rail='VDD_IN',
              sensor=str(label.parent), interval_s=0.05,
              elapsed_s=t, module_energy_J=e, mean_module_power_W=e/t,
              idle_before_W=e0/t0, idle_after_W=e1/t1,
              baseline_W=baseline, incremental_energy_estimate_J=e-baseline*t,
              limitation='Module rail, not wall power. Incremental energy is an estimate; includes background/DVFS effects. Polling adds up to about 50 ms.')
prefix.with_suffix('.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result,indent=2))
if code: raise SystemExit(code)
