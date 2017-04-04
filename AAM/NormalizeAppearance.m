function g=NormalizeAppearance(vect)
g_mean=mean(vect);
g_std=std(vect);
g=(vect-g_mean)/g_std;
end