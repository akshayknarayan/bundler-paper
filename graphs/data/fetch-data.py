#!/usr/bin/python3

import subprocess as sh
import threading
import os

files=[
    "https://people.csail.mit.edu/akshayn/bundler-project/vary_offered_load.data" ,
    "https://people.csail.mit.edu/akshayn/bundler-project/lowdelays.data",
    "https://people.csail.mit.edu/akshayn/bundler-project/strictprio.data",
    "https://people.csail.mit.edu/akshayn/bundler-project/overview_benefits.data",
    "https://people.csail.mit.edu/akshayn/bundler-project/proxy.data",
    "https://people.csail.mit.edu/akshayn/bundler-project/udping_results.out",
    "https://people.csail.mit.edu/akshayn/bundler-project/bmon_results.out",
    "https://people.csail.mit.edu/akshayn/bundler-project/vary_inelastic.data",
    "https://people.csail.mit.edu/akshayn/bundler-project/tputdelay.data",
    "https://people.csail.mit.edu/akshayn/bundler-project/waterfall.data",
    "https://people.csail.mit.edu/akshayn/bundler-project/minrtt-50-delay-dist.data",
    "https://people.csail.mit.edu/akshayn/bundler-project/minrtt-delay-dist.data",
    "https://people.csail.mit.edu/akshayn/bundler-project/bundler_cc_alg_choice.data",
    "https://people.csail.mit.edu/akshayn/bundler-project/overview_benefits.data",
    "https://people.csail.mit.edu/akshayn/bundler-project/twobundler.data",
    "https://people.csail.mit.edu/akshayn/bundler-project/vary_elastic.data",
    "https://people.csail.mit.edu/akshayn/bundler-project/endhost_cc_alg_choice.data",
    "https://people.csail.mit.edu/akshayn/bundler-project/84-10000-nimbus-sfq-62-pl-mixed-diff.data",
    "https://people.csail.mit.edu/akshayn/bundler-project/84-10000-nimbus-sfq-62-pl-mixed-epochs.data",
]

def get_file(url):
    filename = url.split("/")[-1]
    if os.path.exists(filename):
        print(f"{filename} already present")
    else:
        sh.run(f"wget {url}", shell=True)

ts = [threading.Thread(target=get_file, args=(f,)) for f in files]
[t.start() for t in ts]
[t.join() for t in ts]
