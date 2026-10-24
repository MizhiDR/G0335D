import os,re
base=r'gree_g3s/system_dump'
for lf in ['proprietary-files.txt','proprietary-files-qc.txt','proprietary-files-qc-perf.txt']:
    p=os.path.join(r'G0335D/device/gree/g0335d',lf)
    lines=open(p,encoding='utf-8').read().splitlines()
    total=0; missing=[]; present=[]
    for ln in lines:
        s=ln.strip()
        if not s or s.startswith('#'): continue
        # optional '-' prefix
        opt=False
        if s.startswith('-'): opt=True; s=s[1:]
        # hash spec path|hash
        path=s.split('|')[0].strip()
        total+=1
        src=os.path.join(base,path)
        if os.path.exists(src): present.append(path)
        else: missing.append(path)
    print(lf,'total',total,'present',len(present),'missing',len(missing))
    for m in missing[:20]: print('  MISS',m)
