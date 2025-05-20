import glob
import os
from tqdm import tqdm

editions = os.path.join("data", "editions")

files = glob.glob("./data/editions/BR-*/*.xml")
for x in tqdm(files, total=len(files)):
    fname = os.path.split(x)[-1]
    new_path = os.path.join(editions, fname)
    os.rename(x, new_path)

empty_dirs = glob.glob("./data/editions/*/")
for d in empty_dirs:
    try:
        os.rmdir(d)
    except OSError:
        pass
