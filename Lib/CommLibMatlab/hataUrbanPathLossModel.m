function l = hataUrbanPathLossModel(d, f)

par.model = 'large cities';
par.model = 'other';
par.hmobile = 1;
par.hbase = 30;

if strcmp(par.model, 'large cities')
    C_H = 3.2*(log10(11.75*par.hmobile)).^2-4.97;
else
    C_H = 0.8 + (1.1*log10(f)-0.7)*par.hmobile - 1.56*log10(f);
end

l = 69.55+26.16*log10(f)-13.82*log10(par.hbase)-C_H+...
    (44.9 - 6.55*log10(par.hbase))*log10(d/1000);