clc;
a=[16.7344
16.6573
16.5788
16.7124
16.5962
];
tru_val=18.9;

a=a';

vara=var(a)

meana=mean(a)

max_erra=max(abs(max(a)-tru_val),abs(min(a)-tru_val))/tru_val*100

avg_erra=abs(meana-tru_val)/tru_val*100

% err=(max(a)-min(a))/min(a)*100
